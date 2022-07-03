import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_second/Models/Login/user_login.dart';
import 'package:flutter_second/Others/common_components.dart';
import 'package:flutter_second/Pages/Login/login.dart';
import 'package:flutter_second/Service/login_service.dart';
import 'package:flutter_second/globals.dart' as globals;

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      // title: 'Register',
      home: SignInPage(),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isObscure = true;

  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _email =
      TextEditingController(text: globals.email.getItem("email"));
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  final Text pageTitle = Text(globals.goPage.getItem("goPage"),
      style: const TextStyle(fontSize: 20));

  void submitAccountForm() async {
    final bool? isValid = _form.currentState?.validate();
    if (isValid == true) {
      // debugPrint('Register An Account!');
      // debugPrint('Email:${_email.text}');
      // debugPrint('Password:${_password.text}');
      // debugPrint('ConfirmPassword:${_confirmPassword.text}');

      String message = "";

      LoginService loginService = LoginService();
      UserRegister userRegister =
          UserRegister(_email.text, _password.text, _confirmPassword.text);

      var res = await loginService.submitAccountForm(userRegister);

      // set message
      if (res.toString().contains("resultCode")) {
        message = res["msg"];
        if (res["resultCode"] == "10") {
          globals.token.setItem("token", res["token"]);
          debugPrint('[token]:[${res["token"]}]');

          runApp(const Login());
        }
      } else {
        if (res.toString().contains("status")) {
          Map maps = jsonDecode(res);
          message = maps["errors"].toString();
        } else {
          message = res.toString();
        }
        // show message
        debugPrint('[msg]:[$message]');
        Future.delayed(
            Duration.zero, () => showAlertDialog(context, "提示", message));
      }
    }
  }

  void submitEditPassword() async {
    final bool? isValid = _form.currentState?.validate();
    if (isValid == true) {
      // debugPrint('Register An Account!');
      // debugPrint('Email:${_email.text}');
      // debugPrint('Password:${_password.text}');
      // debugPrint('ConfirmPassword:${_confirmPassword.text}');

      String message = "";

      LoginService loginService = LoginService();

      var res = await loginService.forgotPassword(_email.text);

      // set message
      if (res.toString().contains("resultCode")) {
        message = res["msg"];
        debugPrint('[msg]:[${res["msg"]}]');
        if (res["resultCode"] == "10") {
          globals.token.setItem("token", res["token"]);
          globals.token.setItem("resetToken", res["resetToken"]);
          debugPrint('[token]:[${res["token"]}]');
          debugPrint('[resetToken]:[${res["resetToken"]}]');

          ResetPassword resetPassword = ResetPassword(
              globals.token.getItem("resetToken"),
              _password.text,
              _confirmPassword.text);

          res = await loginService.resetPassword(resetPassword);

          // set message
          if (res.toString().contains("resultCode")) {
            message = res["msg"];
            debugPrint('[msg]:[${res["msg"]}]');
            if (res["resultCode"] == "10") {
              globals.token.setItem("token", res["token"]);
              globals.token.setItem("resetToken", "");
              debugPrint('[token]:[${res["token"]}]');
              // runApp(const Login());
              // ignore: use_build_context_synchronously
              Navigator.push(context,
                  MaterialPageRoute<void>(builder: (BuildContext context) {
                return const LoginPage();
              }));
            }
          } else {
            if (res.toString().contains("status")) {
              Map maps = jsonDecode(res);
              message = maps["errors"].toString();
            } else {
              message = res.toString();
            }
            // show message
            debugPrint('[msg]:[$message]');
            Future.delayed(
                Duration.zero, () => showAlertDialog(context, "提示", message));
          }
        }
      } else {
        if (res.toString().contains("status")) {
          Map maps = jsonDecode(res);
          message = maps["errors"].toString();
        } else {
          message = res.toString();
        }
        // show message
        debugPrint('[msg]:[$message]');
        Future.delayed(
            Duration.zero, () => showAlertDialog(context, "提示", message));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              runApp(const Login());
              // Navigator.push(context,
              //     MaterialPageRoute<void>(builder: (BuildContext context) {
              //   return const LoginPage();
              // }));
            }),
        title: pageTitle,
      ),
      // Change to buildColumn() for the other column example
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: pageTitle),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 16.0),
                child: TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: "Email *",
                      hintText: "Enter your email.",
                    ),
                    enabled: false),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 16.0),
                child: TextFormField(
                    controller: _password,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        labelText: "Password *",
                        hintText: "Enter your password.",
                        suffixIcon: IconButton(
                            icon: Icon(_isObscure
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            })),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    }),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 16.0),
                child: TextFormField(
                    controller: _confirmPassword,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        labelText: "Confirm Password *",
                        hintText: "Enter your password again.",
                        suffixIcon: IconButton(
                            icon: Icon(_isObscure
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            })),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'This field is required';
                      }
                      if (value != _password.text) {
                        return 'Not Match Password';
                      }
                      return null;
                    }),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 48.0,
                height: 48.0,
                child: ElevatedButton(
                    onPressed: globals.goPage.getItem("goPage") == "Register"
                        ? submitAccountForm
                        : submitEditPassword,
                    child: const Text("Submit")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
