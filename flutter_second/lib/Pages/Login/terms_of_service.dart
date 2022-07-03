import 'package:flutter/material.dart';
import 'package:flutter_second/Pages/Login/login.dart';
import 'package:flutter_second/Pages/Login/verify_email.dart';
import 'package:flutter_second/globals.dart' as globals;

class TermsOfService extends StatelessWidget {
  const TermsOfService({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Terms Of Service',
      home: TermsOfServicePage(),
    );
  }
}

class TermsOfServicePage extends StatefulWidget {
  const TermsOfServicePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TermsOfServicePageState createState() => _TermsOfServicePageState();
}

class _TermsOfServicePageState extends State<TermsOfServicePage> {
  bool isChecked = false;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Terms Of Service"),
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Terms Of Service',
                style: TextStyle(fontSize: 20),
              )),
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla'
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla'
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla'
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla'
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla'
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla'
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla'
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla'
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla'
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla'
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla'
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla'
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla'
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla'
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla'
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla'
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla'
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla'
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla'
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla'
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla'
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla'
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla'
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla'
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla'
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla'
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla'
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla'
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla'
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla'
                'BlaBlaBlaBlaBla....',
                style: TextStyle(fontSize: 20),
              )),
          // CheckboxListTile(
          //   title: const Text("同意"),
          //   value: isChecked,
          //   onChanged: (bool? value) {
          //     setState(() {
          //       isChecked = value!;
          //     });
          //   },
          //   controlAffinity:
          //       ListTileControlAffinity.leading, //  <-- leading Checkbox
          // ),
          const SizedBox(
            height: 20.0,
          ),
          Wrap(direction: Axis.horizontal, children: <Widget>[
            ButtonTheme(
              minWidth: 40.0,
              child: OutlinedButton(
                onPressed: () {
                  globals.goPage.setItem("goPage", "Register");
                  runApp(const VerifyEmail());
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Agree'),
              ),
            ),
            const SizedBox(
              width: 100.0,
            ),
            ButtonTheme(
              minWidth: 40.0,
              child: OutlinedButton(
                onPressed: () {
                  // runApp(const Login());
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Disagree'),
              ),
            )
          ])
        ])));
  }
}
