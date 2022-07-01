using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace flutter_second_api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmailController : ControllerBase
    {
        private readonly IEmailService _emailService;
        private readonly DataContext _context;

        string resultCode = "10";

        public EmailController(DataContext context, IEmailService emailService)
        {
            _emailService = emailService;
            _context = context;
        }

        [HttpPost("SendEmail")]
        public async Task<IActionResult> SendEmail(EmailDTO request)
        {
            JObject jo = new();

            try
            {
                var verifyCode = await _context.VerifyCodes.FirstOrDefaultAsync(c => c.UserEmail == request.To);

                if (verifyCode != null && verifyCode.CreateTime.AddDays(1) > DateTime.Now && verifyCode.VerificationTime == null)
                {
                    jo.Add("msg", "已發送驗證碼，請前往信箱確認! (☝ ՞ਊ ՞）☝");
                    jo.Add("resultCode", resultCode);
                }
                else
                {

                    var verifyCode2 = new VerifyCode
                    {
                        Code = CreateVerificationCode(),
                        UserEmail = request.To,
                        CreateTime = DateTime.Now
                    };

                    _context.VerifyCodes.Add(verifyCode2);
                    await _context.SaveChangesAsync();

                    request.Body = request.Body.Replace("VerifyCode", verifyCode2.Code);

                    _emailService.SendEmail(request);

                    jo.Add("msg", "驗證碼發送成功，請前往信箱確認! (☝ ՞ਊ ՞）☝");
                    jo.Add("resultCode", resultCode);
                }

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

        /// <summary>
        /// 產生一組由數字與大小寫英文組成的隨機8碼字串
        /// </summary>
        /// <returns>驗證碼 亂碼</returns>
        private static string CreateVerificationCode()
        {

            string allowedChars = "abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ0123456789";
            int passwordLength = 8;//密碼長度
            char[] chars = new char[passwordLength];
            Random rd = new(); 

            for (int i = 0; i < passwordLength; i++)
            {
                //allowedChars -> 這個String ，隨機取得一個字，丟給chars[i]
                chars[i] = allowedChars[rd.Next(0, allowedChars.Length)];
            }

            return new string(chars);
        }
    }
}
