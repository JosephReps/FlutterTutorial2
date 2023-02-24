import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_flutter_2/constants/routes.dart';
import 'package:tutorial_flutter_2/firebase_options.dart';
import 'package:tutorial_flutter_2/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
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
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;

                  await Firebase.initializeApp(
                    options: DefaultFirebaseOptions.currentPlatform,
                  );

                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    if (!mounted) return;

                    if (FirebaseAuth.instance.currentUser?.emailVerified ??
                        false) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        homeRoute,
                        (route) => false,
                      );
                    }
                  } on FirebaseAuthException catch (e) {
                    if (!mounted) return;
                    if (e.code == 'wrong-password') {
                      await showErrorDialog(context, "Invalid credentials.");
                    } else if (e.code == 'user-not-found') {
                      await showErrorDialog(context, "User not found.");
                    } else {
                      await showErrorDialog(
                          context, e.message ?? "An unknown error occured");
                    }
                  } catch (e) {
                    if (!mounted) return;
                    await showErrorDialog(context, e.toString());
                  }
                },
                child: const Text("Login"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(registerRoute, (route) => false);
                },
                child: const Text("Register here"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
