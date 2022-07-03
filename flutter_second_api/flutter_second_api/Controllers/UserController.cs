using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;

namespace flutter_second_api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly DataContext _context;
        private readonly IConfiguration _config;

        string resultCode = "10";

        public UserController(DataContext context, IConfiguration config)
        {
            _context = context;
            _config = config;
        }

        [HttpPost("Register")]
        public async Task<IActionResult> Register(UserRegisterRequest request)
        {
            JObject jo = new();

            try
            {
                if (_context.Users.Any(u => u.Email == request.Email))
                {
                    return BadRequest("User already exists.");
                }

                CreatePasswordHash(request.Password,
                    out byte[] PasswordHash,
                    out byte[] PasswordSalt);

                var user = new User
                {
                    Email = request.Email,
                    PasswordHash = PasswordHash,
                    PasswordSalt = PasswordSalt,
                    VerificationToken = CreateRandomToken()
                };

                _context.Users.Add(user);
                await _context.SaveChangesAsync();

                jo.Add("msg", $"User successfully created!, {user.Email}! (☝ ՞ਊ ՞）☝");
                jo.Add("resultCode", resultCode);
                jo.Add("token", user.VerificationToken);

                return Ok(JsonConvert.SerializeObject(jo, Formatting.Indented));
            }
            catch (Exception ex)
            {
                resultCode = "20";
                jo.Add("resultCode", resultCode);
                jo.Add("msg", ex.Message);
                return Ok(JsonConvert.SerializeObject(jo, Formatting.Indented));
            }
        }

        [HttpPost("Login")]
        public async Task<IActionResult> Login(UserLoginRequest request)
        {
            JObject jo = new();

            try
            {
                var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == request.Email);

                if (user == null)
                {
                    return BadRequest("查無使用者.");
                }

                if (!VerifyPasswordHash(request.Password, user.PasswordHash, user.PasswordSalt))
                {
                    return BadRequest("密碼不正確.");
                }

                if (user.VerifiedAt == null)
                {
                    return BadRequest("帳戶尚未驗證");
                }

                DateTime dt = DateTime.Now;

                if (user.VerifiedAt < dt.AddDays(-1))
                {
                    string msg = await RefreshToken(user, dt);
                }

                jo.Add("msg", $"Welcome back, {user.Email}! (☝ ՞ਊ ՞）☝");
                jo.Add("resultCode", resultCode);
                jo.Add("token", user.VerificationToken);

                return Ok(JsonConvert.SerializeObject(jo, Formatting.Indented));
            }
            catch (Exception ex)
            {
                resultCode = "20";
                jo.Add("resultCode", resultCode);
                jo.Add("msg", ex.Message);
                return Ok(JsonConvert.SerializeObject(jo, Formatting.Indented));
            }
        }

        [HttpGet("Verify")]
        public async Task<IActionResult> Verify(string token)
        {
            JObject jo = new();

            try
            {
                var user = await _context.Users.FirstOrDefaultAsync(u => u.VerificationToken == token);

                if (user == null)
                {
                    return BadRequest("Invaild token.");
                }

                DateTime dt = DateTime.Now;

                user.VerifiedAt = DateTime.Now;
                user.VerificationToken = CreateToken(user.Email, dt.AddDays(1));

                await _context.SaveChangesAsync();

                jo.Add("msg", $"User verified, {user.Email}! (☝ ՞ਊ ՞）☝");
                jo.Add("resultCode", resultCode);
                jo.Add("token", user.VerificationToken);

                return Ok(JsonConvert.SerializeObject(jo, Formatting.Indented));
            }
            catch (Exception ex)
            {
                resultCode = "20";
                jo.Add("resultCode", resultCode);
                jo.Add("msg", ex.Message);
                return Ok(JsonConvert.SerializeObject(jo, Formatting.Indented));
            }
        }

        [HttpGet("forgot-password")]
        public async Task<IActionResult> ForgotPassword(string email)
        {
            JObject jo = new();

            try
            {
                var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == email);

                if (user == null)
                {
                    return BadRequest("User not found.");
                }

                DateTime dt = DateTime.Now.AddDays(1);

                user.PasswordResstToken = CreateToken(email, dt);
                user.ResetTokenExpires = dt;

                await _context.SaveChangesAsync();


                jo.Add("msg", $"請重設密碼, {user.Email}! (☝ ՞ਊ ՞）☝");
                jo.Add("resultCode", resultCode);
                jo.Add("token", user.VerificationToken);
                jo.Add("resetToken", user.PasswordResstToken);

                return Ok(JsonConvert.SerializeObject(jo, Formatting.Indented));
            }
            catch (Exception ex)
            {
                resultCode = "20";
                jo.Add("resultCode", resultCode);
                jo.Add("msg", ex.Message);
                return Ok(JsonConvert.SerializeObject(jo, Formatting.Indented));
            }
        }

        [HttpPost("reset-password")]
        public async Task<IActionResult> ResetPassword(ResetPasswordRequest request)
        {
            JObject jo = new();

            try
            {
                var user = await _context.Users.FirstOrDefaultAsync(u => u.PasswordResstToken == request.Token);

                if (user == null || user.ResetTokenExpires < DateTime.Now)
                {
                    return BadRequest("Invaild token.");
                }

                CreatePasswordHash(request.Password, out byte[] passwordHash, out byte[] passwordSalt);

                DateTime dt = DateTime.Now;
                user.PasswordHash = passwordHash;
                user.PasswordSalt = passwordSalt;
                user.PasswordResstToken = null;
                user.ResetTokenExpires = null;
                user.VerifiedAt = DateTime.Now;
                user.VerificationToken = CreateToken(user.Email, dt.AddDays(1));

                await _context.SaveChangesAsync();

                jo.Add("msg", $"密碼重設成功, {user.Email}! (☝ ՞ਊ ՞）☝");
                jo.Add("resultCode", resultCode);
                jo.Add("token", user.VerificationToken);

                return Ok(JsonConvert.SerializeObject(jo, Formatting.Indented));
            }
            catch (Exception ex)
            {
                resultCode = "20";
                jo.Add("resultCode", resultCode);
                jo.Add("msg", ex.Message);
                return Ok(JsonConvert.SerializeObject(jo, Formatting.Indented));
            }
        }

        private void CreatePasswordHash(string password, out byte[] passwordHash, out byte[] passwordSalt)
        {
            using (var hmac = new HMACSHA512())
            {
                passwordSalt = hmac.Key;
                passwordHash = hmac
                    .ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));
            }
        }

        private bool VerifyPasswordHash(string password, byte[] passwordHash, byte[] passwordSalt)
        {
            using (var hmac = new HMACSHA512(passwordSalt))
            {
                var computedHash = hmac
                    .ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));

                return computedHash.SequenceEqual(passwordHash);
            }
        }

        private static string CreateRandomToken()
        {
            return Convert.ToHexString(RandomNumberGenerator.GetBytes(64));
        }

        /// <summary>
        /// 創建Token
        /// </summary>
        /// <param name="email">電子郵件</param>
        /// <returns></returns>
        private string CreateToken(string email, DateTime dt)
        {
            List<Claim> claims = new();

            // 要加入 token 的資料
            if (email != "")
            {
                claims.Add(new Claim(ClaimTypes.Email, email));
            }

            if (dt != DateTime.MinValue)
            {
                claims.Add(new Claim(ClaimTypes.Expired, dt.ToString("yyyy-MM-dd HH:mm:ss.ss")));
            }

            var key = new SymmetricSecurityKey(System.Text.Encoding.UTF8.GetBytes(_config.GetSection("SecretKey:Token").Value));

            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha512Signature);

            var token = new JwtSecurityToken(
                claims: claims,
                expires: DateTime.Now.AddDays(1),
                signingCredentials: creds
                );

            var jwt = new JwtSecurityTokenHandler().WriteToken(token);

            return jwt;
        }

        private async Task<string> RefreshToken(User user, DateTime dt)
        {
            user.VerifiedAt = dt;
            user.VerificationToken = CreateToken(user.Email, dt.AddDays(1));

            await _context.SaveChangesAsync();

            return "";
        }
    }
}
