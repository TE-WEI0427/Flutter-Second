// api service
import 'package:flutter_second/Models/Login/send_email.dart';
import 'package:flutter_second/Models/Login/user_login.dart';
import 'package:flutter_second/Service/http_service.dart';

class LoginService {
  login(UserLogin userLogin) {
    return postHttp("/api/User/Login", userLogin.toJson());
  }

  getVerificationCode(SendEmail sendEmail) {
    return postHttp("/api/Email/SendEmail", sendEmail.toJson());
  }

  submitVerificationCode(String verificationCode) {
    return getHttp(
        "/api/Verification/CheckVerificationCode?verificationCode=$verificationCode");
  }

  submitAccountForm(UserRegister userRegister) {
    return postHttp("/api/User/Register", userRegister.toJson());
  }

  verify(String token) {
    return getHttp("/api/User/Verify?token=$token");
  }

  forgotPassword(String email) {
    return getHttp("/api/User/forgot-password?email=$email");
  }

  resetPassword(ResetPassword resetPassword) {
    return postHttp("/api/User/reset-password", resetPassword.toJson());
  }
}
