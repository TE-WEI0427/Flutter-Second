using System.ComponentModel.DataAnnotations;

namespace flutter_second_api.Models
{
    public class UserLoginRequest
    {
        [Required, EmailAddress(ErrorMessage = "信箱格式不正確")]
        public string Email { get; set; } = string.Empty;
        [Required]
        public string Password { get; set; } = String.Empty;
    }
}
