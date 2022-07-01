namespace flutter_second_api.Models
{
    public class VerifyCode
    {
        public int id { get; set; }
        public string Code { get; set; } = String.Empty;
        public string UserEmail { get; set; } = String.Empty;
        public DateTime CreateTime { get; set; }
        public DateTime? VerificationTime { get; set; }
    }
}
