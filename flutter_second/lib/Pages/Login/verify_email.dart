import 'package:flutter/material.dart';
import 'package:flutter_second/Models/Login/send_email.dart';
import 'package:flutter_second/Pages/Login/login.dart';
import 'package:flutter_second/Pages/Login/register.dart';
import 'package:flutter_second/Service/login_service.dart';
import 'package:flutter_second/globals.dart' as globals;
import 'package:flutter_second/Pages/Login/forgot_password.dart';

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

  @override
  // ignore: must_call_super
  void initState() {
    _isButtonDisabled = false;
  }

  // ignore: non_constant_identifier_names
  void SubmitVerificationCode() {
    // ignore: avoid_print
    print("VerificationCode : ${_verCode.text}");
    // ignore: avoid_print
    print("GoPage : ${globals.goPage}");
    switch (globals.goPage) {
      case "Forgot Password":
        // runApp(const ForgotPassword());
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
        );
        break;
      case "Register":
        // runApp(const Register());
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterPage()),
        );
        break;
    }
  }

  void getVerificationCode() {
    LoginService loginService = LoginService();
    SendEmail sendEmail =
        SendEmail(_email.text, "Verification Code", "<i>Test</i>");
    loginService.getVerificationCode(sendEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  // runApp(const Login());
                  Navigator.push(context,
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                    return const LoginPage();
                  }));
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
                        ? SubmitVerificationCode
                        : null,
                    child: const Text("Submit")),
              );
            },
          ),
        ])));
  }
}
