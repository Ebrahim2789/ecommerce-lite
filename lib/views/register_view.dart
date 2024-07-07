import 'package:dalell/constants/routes.dart';
import 'package:dalell/services/auth/auth_exceptions.dart';
import 'package:dalell/services/auth/auth_services.dart';
import 'package:dalell/utilities/show_error_dialog.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
    WidgetsFlutterBinding.ensureInitialized();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.blue[500],
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            decoration:
                const InputDecoration(hintText: 'Enter your email here'),
            obscureText: false,
            enableSuggestions: false,
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _password,
            decoration:
                const InputDecoration(hintText: 'Enter your password here'),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          TextButton(
              onPressed: () async {
                final email = _email.text;

                final password = _password.text;

                try {
                  AuthServices.firebase().createUsre(
                    email: email,
                    password: password,
                  );
                  AuthServices.firebase().sendEmailVerification();

                  Navigator.of(context).pushNamed(verifyEmailViewRoute);
                } on WeakPasswordAuthException {
                  await showErrorDialog(
                      context, 'please dont do this weak password');
                } on EmailAlreadyInUSEAuthException {
                  await showErrorDialog(
                      context, 'Email already in use try agian');
                } on InvalidEmailAuthException {
                  await showErrorDialog(context, 'Invalid email address');
                } on GennericAuthException {
                  await showErrorDialog(context, 'Failed to register');
                }
              },
              child: const Text('Register')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text('Login'))
        ],
      ),
    );
  }
}
