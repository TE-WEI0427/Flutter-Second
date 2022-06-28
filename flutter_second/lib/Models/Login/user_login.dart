class UserLogin {
  late String email;
  late String password;
  UserLogin(this.email, this.password);
  Map toJson() => {'email': email, 'password': password};
}
