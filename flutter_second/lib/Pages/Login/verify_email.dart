import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_second/Models/Login/send_email.dart';
import 'package:flutter_second/Others/common_components.dart';
import 'package:flutter_second/Others/html_code.dart';
import 'package:flutter_second/Pages/Login/login.dart';
import 'package:flutter_second/Pages/Login/register_forgot_password.dart';
import 'package:flutter_second/Service/login_service.dart';
import 'package:flutter_second/globals.dart' as globals;

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'VerifyEmail',
      home: VerifyEmailPage(),
    );
  }
}

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _verCode = TextEditingController();

  late bool _isButtonDisabled;

  LoginService loginService = LoginService();
  String message = "";

  @override
  // ignore: must_call_super
  void initState() {
    _isButtonDisabled = false;
  }

  void getVerificationCode() async {
    // debugPrint('Email:${_email.text}');

    SendEmail sendEmail = SendEmail(_email.text, "App帳號申請:驗證信箱", emailHtml);

    var res = await loginService.getVerificationCode(sendEmail);

    // set message
    if (res.toString().contains("resultCode")) {
      message = res["msg"];
      debugPrint('[msg]:[${res["msg"]}]');
      globals.email.setItem("email", _email.text);
      if (res["resultCode"] == "10") {
        // show message
        Future.delayed(
            Duration.zero, () => showAlertDialog(context, "提示", message));
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

  void submitVerificationCode() async {
    // debugPrint("VerificationCode : ${_verCode.text}");
    debugPrint("GoPage : ${globals.goPage.getItem("goPage")}");

    var res = await loginService.submitVerificationCode(_verCode.text);

    // set message
    if (res.toString().contains("resultCode")) {
      message = res["msg"];
      debugPrint('[msg]:[${res["msg"]}]');
      if (res["resultCode"] == "10") {
        globals.email.setItem("email", res["userEmail"]);
        // runApp(const Register());
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignInPage()),
        );
      } else {
        // show message
        debugPrint('[msg]:[${res["msg"]}]');
        Future.delayed(
            Duration.zero, () => showAlertDialog(context, "提示", message));
        globals.email.setItem("email", "");
      }
    } else {
      globals.email.setItem("email", "");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (globals.goPage.getItem("goPage") == "Forgot Password") {
                    Navigator.pop(context);
                  } else {
                    runApp(const Login());
                  }

                  // Navigator.push(context,
                  //     MaterialPageRoute<void>(builder: (BuildContext context) {
                  //   return const LoginPage();
                  // }));
                }),
            title: const Text('VerifyEmail')),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Verify Email',
              style: TextStyle(fontSize: 20),
            ),
          ),
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
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _email,
            builder: (context, value, child) {
              return SizedBox(
                width: MediaQuery.of(context).size.width - 48.0,
                height: 48.0,
                child: ElevatedButton(
                    onPressed: _email.text.isNotEmpty
                        ? _isButtonDisabled
                            ? null
                            : getVerificationCode
                        : null,
                    child: const Text("Send Verification Code To Mailbox")),
              );
            },
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: TextFormField(
              controller: _verCode,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.verified_user_outlined),
                labelText: "Verification code *",
                hintText: "Your verification code in the email.",
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _verCode,
            builder: (context, value, child) {
              return SizedBox(
                width: MediaQuery.of(context).size.width - 48.0,
                height: 48.0,
                child: ElevatedButton(
                    onPressed: _verCode.text.isNotEmpty
                        ? submitVerificationCode
                        : null,
                    child: const Text("Submit")),
              );
            },
          ),
        ])));
  }
}
