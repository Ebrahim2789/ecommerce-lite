import 'package:dalell/firebase_options.dart';
import 'package:dalell/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primaryColor: Colors.blue,
    ),
    home: const HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home page'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
          future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                // checking user
                final user = FirebaseAuth.instance.currentUser;
                // final emailVerified=user?.emailVerified??false;

                if (user?.emailVerified ?? false) {
                  print('You are verified');
                } else {
                  print('You need to verify your email first');
                }
                return const Text("Done");

              default:
                return const Text('Loading ....');
            }
          }),
    );
  }
}
