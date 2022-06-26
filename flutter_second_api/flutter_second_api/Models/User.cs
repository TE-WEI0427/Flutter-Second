namespace flutter_second_api.Models
{
    public class User
    {
        public int id { get; set; }
        public string Email { get; set; } = string.Empty;
        public byte[] PasswordHash { get; set; } = new byte[32];
        public byte[] PasswordSalt { get; set; } = new byte[32];
        public string? VerificationToken { get; set; }
        public DateTime? VerifiedAt { get; set; }
        public string? PasswordResstToken { get; set; }
        public DateTime? ResetTokenExpires { get; set; }
    }
}
