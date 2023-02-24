import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:tutorial_flutter_2/constants/routes.dart';
import 'package:tutorial_flutter_2/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _passwordConfirm;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _passwordConfirm = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordConfirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _email,
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: "email"),
              ),
              TextField(
                controller: _password,
                autocorrect: false,
                enableSuggestions: false,
                obscureText: true,
                decoration: const InputDecoration(hintText: "password"),
              ),
              TextField(
                controller: _passwordConfirm,
                autocorrect: false,
                enableSuggestions: false,
                obscureText: true,
                decoration: const InputDecoration(hintText: "confirm password"),
              ),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;

                  try {
                    final userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    devtools.log(userCredential.toString());
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      await showErrorDialog(context, 'Password too trash ma g');
                    } else if (e.code == 'email-already-in-use') {
                      await showErrorDialog(context, 'Email taken ma g');
                    } else if (e.code == 'invalid-email') {
                      await showErrorDialog(context, 'Email invalid ma g');
                    } else {
                      await showErrorDialog(context, 'Error: ${e.code}');
                    }
                  } catch (e) {
                    await showErrorDialog(context, e.toString());
                  }
                },
                child: const Text("Register"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).restorablePushNamedAndRemoveUntil(
                    loginRoute,
                    (route) => false,
                  );
                },
                child: const Text("Login here!"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
