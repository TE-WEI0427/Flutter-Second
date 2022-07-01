using System.ComponentModel.DataAnnotations;

namespace flutter_second_api.Models
{
    public class EmailDTO
    {
        [Required, EmailAddress(ErrorMessage = "信箱格式不正確")]
        public string To { get; set; } = string.Empty;
        public string Subject { get; set; } = string.Empty;
        public string Body { get; set; } = string.Empty;
    }
}
