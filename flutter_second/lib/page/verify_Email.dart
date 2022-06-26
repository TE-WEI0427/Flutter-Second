import 'package:flutter/material.dart';

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
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('VerifyEmail')),
        body: SingleChildScrollView(
            key: _form,
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 16.0),
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
              SizedBox(
                width: MediaQuery.of(context).size.width - 48.0,
                height: 48.0,
                child: ElevatedButton(
                    onPressed: () {}, child: const Text("Send Verify Message")),
              )
            ])));
  }
}
