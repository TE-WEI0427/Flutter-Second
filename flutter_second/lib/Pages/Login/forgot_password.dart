import 'package:flutter/material.dart';
import 'package:flutter_second/Pages/Login/login.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'ForgotPassword',
      home: ForgotPasswordPage(),
    );
  }
}

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool _isObscure = true;

  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  void _trySubmitForm() {
    final bool? isValid = _form.currentState?.validate();
    if (isValid == true) {
      debugPrint('Change Password Successful !');
      debugPrint('Password:${_password.text}');
      debugPrint('ConfirmPassword:${_confirmPassword.text}');
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
          title: const Text('ForgotPassword'),
        ),
        body: SingleChildScrollView(
            child: Form(
                key: _form,
                child: Column(children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'Forgot Password',
                        style: TextStyle(fontSize: 20),
                      )),
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
                        onPressed: _trySubmitForm,
                        child: const Text("SaveChange")),
                  ),
                ]))));
  }
}
