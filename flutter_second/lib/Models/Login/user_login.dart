class UserLogin {
  late String email;
  late String password;
  UserLogin(this.email, this.password);
  Map toJson() => {'email': email, 'password': password};
}

class UserRegister {
  late String email;
  late String password;
  late String confirmPassword;
  UserRegister(this.email, this.password, this.confirmPassword);
  Map toJson() => {
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword
      };
}

class ResetPassword {
  late String token;
  late String password;
  late String confirmPassword;
  ResetPassword(this.token, this.password, this.confirmPassword);
  Map toJson() => {
        'token': token,
        'password': password,
        'confirmPassword': confirmPassword
      };
}
