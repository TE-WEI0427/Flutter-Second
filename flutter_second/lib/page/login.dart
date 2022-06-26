import 'package:flutter/material.dart';
import 'package:flutter_second/page/forgot_Password.dart';
import 'package:flutter_second/page/terms_Of_Service.dart';
import 'package:flutter_second/page/verify_Email.dart';

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

  void _trySubmitForm() {
    final bool? isValid = _form.currentState?.validate();
    if (isValid == true) {
      debugPrint('Change Password Successful !');
      debugPrint('Email:${_email.text}');
      debugPrint('Password:${_password.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SingleChildScrollView(
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
                onChanged: (value) => _email.text = value,
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
                },
                onChanged: (value) => _password.text = value,
              ),
            ),
            TextButton(
              onPressed: () {
                runApp(const VerifyEmail());
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
              child: ElevatedButton(
                  onPressed: _trySubmitForm, child: const Text("Login")),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Does not have account?'),
                TextButton(
                  child: const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 15),
                  ),
                  onPressed: () {
                    runApp(const TermsOfService());
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
