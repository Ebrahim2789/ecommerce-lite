import 'package:dalell/constants/routes.dart';
import 'package:dalell/services/auth/auth_exceptions.dart';
import 'package:dalell/services/auth/auth_services.dart';
import 'package:dalell/utilities/show_error_dialog.dart';
import 'package:flutter/material.dart';
// import 'dart:developer' as devtools show log;

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
    WidgetsFlutterBinding.ensureInitialized;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.blue[500],
      ),
      body: Column(
        children: [
          TextField(
            decoration:
                const InputDecoration(hintText: 'Enter your email here'),
            controller: _email,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: false,
            obscureText: false,
          ),
          TextField(
            decoration:
                const InputDecoration(hintText: 'Enter your password here'),
            controller: _password,
            autocorrect: false,
            enableSuggestions: false,
            obscureText: true,
          ),
          TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;

                try {
                  await AuthServices.firebase().login(
                    email: email,
                    password: password,
                  );

                  final user = AuthServices.firebase().currentUser;
                  if (!context.mounted) return;

                  if (user?.isEmailVerified ?? false) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      mainPageroute,
                      (route) => false,
                    );
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyEmailViewRoute,
                      (route) => false,
                    );
                  }
                } on UserNotFoundAuthException {
                  await showErrorDialog(context, 'user not found');
                } on WrongPasswordAuthException {
                  await showErrorDialog(context, 'Wrong credentials}');
                } on GennericAuthException {
                  await showErrorDialog(context, 'Authentication error');
                }
              },
              child: const Text('Login')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text("Regiter here"),
          )
        ],
      ),
    );
  }
}
