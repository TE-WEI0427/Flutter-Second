namespace flutter_second_api.Data
{
    public class DataContext : DbContext
    {
        public DataContext(DbContextOptions<DataContext> options):base (options) 
        { 
        
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            base.OnConfiguring(optionsBuilder);
            optionsBuilder.UseSqlServer("Server=.;Database=flutter_second_UserDB;Trusted_Connection=True;");
        }

        public DbSet<User> Users => Set<User>();

        public DbSet<VerifyCode> VerifyCodes => Set<VerifyCode>();
    }
}
