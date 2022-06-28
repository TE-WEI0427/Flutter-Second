using MailKit.Net.Smtp;
using Microsoft.AspNetCore.Mvc;
using MimeKit;
using MimeKit.Text;
using MailKit.Security;

namespace flutter_second_api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmailController : ControllerBase
    {
        private readonly IEmailService _emailService;
        public EmailController(IEmailService emailService)
        {
            _emailService = emailService;
        }

        [HttpPost("SendEmail")]
        public IActionResult SendEmail(EmailDTO request)
        {
            _emailService.SendEmail(request);

            return Ok();
        }
    }
}
