using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace flutter_second_api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class VerificationController : ControllerBase
    {
        private readonly DataContext _context;

        string resultCode = "10";

        public VerificationController(DataContext context)
        {
            _context = context;
        }

        [HttpGet("CheckVerificationCode")]
        public async Task<IActionResult> CheckVerificationCode(string verificationCode)
        {
            JObject jo = new();

            try
            {
                if (verificationCode.Length != 8)
                {
                    return BadRequest("驗證碼長度不符，請重新輸入... (눈‸눈)");
                }

                var code = await _context.VerifyCodes.FirstOrDefaultAsync(c => c.Code == verificationCode);

                if (code == null)
                {
                    return BadRequest("查無驗證碼 (눈‸눈)");
                }

                if (code.CreateTime.AddDays(1) < DateTime.Now)
                {
                    return BadRequest("驗證碼已過期，請重新寄送驗證碼 (눈‸눈)");
                }

                if (code.VerificationTime != null)
                {
                    return BadRequest("驗證碼無效 (눈‸눈)");
                }

                code.VerificationTime = DateTime.Now;
                await _context.SaveChangesAsync();

                jo.Add("msg", $"Email verified, {code.UserEmail}! :)");
                jo.Add("userEmail", code.UserEmail);
                jo.Add("resultCode", resultCode);

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
    }
}
