import 'package:dalell/constants/routes.dart';
import 'package:dalell/services/auth/auth_services.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verfiy your email'),
      ),
      body: Column(
        children: [
          const Text(
            "We've sent your email verfication. Please open it to verify your email",
            style: TextStyle(fontSize: 16),
          ),
          const Text(
            "If you have't verify your email. Please verfiy your email",
            style: TextStyle(fontSize: 16),
          ),
          TextButton(
            onPressed: () async {
              await AuthServices.firebase().sendEmailVerification();
            },
            child: const Text('Send email verfication'),
          ),
          TextButton(
            onPressed: () async {
              await AuthServices.firebase().logout();
              if (!context.mounted) return;
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }
}
