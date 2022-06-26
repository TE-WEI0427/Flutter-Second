using System.ComponentModel.DataAnnotations;

namespace flutter_second_api.Models
{
    public class UserRegisterRequest
    {
        [Required, EmailAddress(ErrorMessage = "信箱格式不正確")]
        public string Email { get; set; } = string.Empty;
        [Required, MinLength(6, ErrorMessage = "最少6碼")]
        public string Password { get; set; } = String.Empty;
        [Required, Compare("Password", ErrorMessage = "與輸入密碼不同")]
        public string ConfirmPassword { get; set; } = String.Empty;
    }
}
