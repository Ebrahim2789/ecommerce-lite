import 'package:dalell/constants/routes.dart';
import 'package:dalell/services/auth/auth_services.dart';
import 'package:dalell/views/login_view.dart';
import 'package:dalell/views/notes/main_view.dart';
import 'package:dalell/views/notes/new_notes_view.dart';
import 'package:dalell/views/register_view.dart';
import 'package:dalell/views/verify_email_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter App',
    theme: ThemeData(useMaterial3: true),
    home: const HomePage(),
    // initialRoute: '/',
    routes: {
      // When navigating to the "/" route, build the FirstScreen widget.
      loginRoute: (context) => const LoginView(),
      // When navigating to the "/second" route, build the SecondScreen widget.
      registerRoute: (context) => const RegisterView(),
      mainPageroute: (context) => const MainView(),
      verifyEmailViewRoute: (context) => const VerifyEmailView(),
      newNoteRoute: (context) => const NewNoteView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized;
    return FutureBuilder(
      future: AuthServices.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthServices.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const MainView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
