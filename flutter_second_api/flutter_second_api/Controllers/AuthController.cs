using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace flutter_second_api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly IUserService _userService;

        public AuthController(IUserService userService)
        {
            _userService = userService;
        }

        /// <summary>
        /// 驗證後取得使用者角色
        /// </summary>
        /// <returns></returns>
        [HttpGet("Task"), Authorize]
        public ActionResult<string> Task()
        {
            var userRole = _userService.GetUserRole();
            if(userRole == "admin")
            {
                return Ok("你好 管理者");
            }
            else
            {
                return BadRequest("沒有權限");
            }
        }
    }
}
