
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/constants/show_error_dialog.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text('Verify Email'),),
      body: Column (
        children :[ 
        const Text("Check you email inbox to verify your email"),
        const Text("haven't you receive an email"),
        TextButton(
          onPressed:  () async {
            try {
                  final user = FirebaseAuth.instance.currentUser ;
                  await user?.sendEmailVerification() ;
                } on FirebaseAuthException catch (e) {
                  Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false) ;
                }
          },
        child: const Text("Resend email verification"),
        ),
        TextButton(
          onPressed:  () async {
          await FirebaseAuth.instance.signOut() ;
          Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false) ;
        }, 
        child: const Text("Restart"))

        ]
        ),
    );
    
  }
}