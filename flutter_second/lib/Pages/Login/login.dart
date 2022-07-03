import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_second/Models/Login/user_login.dart';
import 'package:flutter_second/Others/common_components.dart';
// import 'package:flutter_second/page/forgot_password.dart';
import 'package:flutter_second/Pages/Login/terms_of_service.dart';
import 'package:flutter_second/Pages/Login/verify_email.dart';
import 'package:flutter_second/Service/login_service.dart';
import 'package:flutter_second/globals.dart' as globals;

/// Login頁面
class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Login',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;

  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  // 登入按鈕事件
  void _login() async {
    final bool? isValid = _form.currentState?.validate();
    if (isValid == true) {
      // debugPrint('All check pass!');
      // debugPrint('Email:${_email.text}');
      // debugPrint('Password:${_password.text}');

      String message = "";

      LoginService loginService = LoginService();

      var res = await loginService.verify(globals.token.getItem("token"));

      if (res.toString().contains("resultCode")) {
        message = res["msg"];
        if (res["resultCode"] == "10") {
          globals.token.setItem("token", res["token"]);

          debugPrint('[token]:[${res["token"]}]');
          UserLogin userLogin = UserLogin(_email.text, _password.text);

          res = await loginService.login(userLogin);

          // set message
          if (res.toString().contains("resultCode")) {
            message = res["msg"];
            if (res["resultCode"] == "10") {
              globals.token.setItem("token", res["token"]);
              debugPrint('[token]:[${res["token"]}]');
            }
          } else {
            if (res.toString().contains("status")) {
              Map maps = jsonDecode(res);
              message = maps["errors"].toString();
            } else {
              message = res.toString();
            }
          }

          // show message
          debugPrint('[msg]:[$message]');
          Future.delayed(
              Duration.zero, () => showAlertDialog(context, "提示", message));
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SingleChildScrollView(
          child: Form(
        key: _form,
        child: Column(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Log in',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: TextFormField(
                controller: _email,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: "Email *",
                  hintText: "Your account Email.",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
                // onChanged: (value) => _email.text = value
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: TextFormField(
                  controller: _password,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      labelText: "Password *",
                      hintText: "Your account password.",
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
            TextButton(
              onPressed: () {
                globals.goPage.setItem("goPage", "Forgot Password");
                // runApp(const VerifyEmail());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const VerifyEmailPage()),
                );
              },
              child: const Text(
                'Forgot Password',
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 48.0,
              height: 48.0,
              child:
                  ElevatedButton(onPressed: _login, child: const Text("Login")),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Does not have account?'),
                TextButton(
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 15),
                  ),
                  onPressed: () {
                    globals.goPage.setItem("goPage", "Register An Account");
                    // runApp(const TermsOfService());
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TermsOfServicePage()),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      )),
    );
  }
}
