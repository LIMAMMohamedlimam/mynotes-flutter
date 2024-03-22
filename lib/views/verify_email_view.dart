
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';

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
           await AuthService.firebase().sendEmailVerification() ;      
          },
        child: const Text("Resend email verification"),
        ),
        TextButton(
          onPressed:  () async {
          await AuthService.firebase().logOut() ;
          Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false) ;
        }, 
        child: const Text("Restart"))

        ]
        ),
    );
    
  }
}