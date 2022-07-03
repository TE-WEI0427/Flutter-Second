using System.Security.Claims;

namespace flutter_second_api.Service.UserService
{
    /// <summary>
    /// 使用者驗證後要做的事
    /// </summary>
    public class UserService : IUserService
    {
        /// <summary>
        /// 提供目前的存取權 （如果有的話）
        /// </summary>
        private readonly IHttpContextAccessor _httpContextAccessor;

        public UserService(IHttpContextAccessor httpContextAccessor)
        {
            _httpContextAccessor = httpContextAccessor;
        }

        /// <summary>
        /// 取得使用者名稱
        /// </summary>
        /// <returns>Name</returns>
        public string GetUserRole()
        {
            var result = string.Empty;
            if (_httpContextAccessor.HttpContext != null)
            {
                result = _httpContextAccessor.HttpContext.User.FindFirstValue(ClaimTypes.Role);
            }
            return result;
        }
    }
}
