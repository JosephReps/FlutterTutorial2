import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_flutter_2/firebase_options.dart';
import 'package:tutorial_flutter_2/views/home_view.dart';
import 'package:tutorial_flutter_2/views/login_view.dart';
import 'package:tutorial_flutter_2/views/register_view.dart';
import 'package:tutorial_flutter_2/views/verify_email_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      '/login/': (context) => const LoginView(),
      '/register/': (context) => const RegisterView(),
      '/home/': (context) => const HomeView()
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user == null) {
              return const LoginView();
            } else if (!user.emailVerified) {
              return const VerifyEmailView();
            } else {
              return const HomeView();
            }
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
