// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/constants/show_error_dialog.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'dart:developer' as devtools show log ;


class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  late final TextEditingController _email ;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController() ;
    _password = TextEditingController() ;
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
      appBar: AppBar(
        title: const Text('Register'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize:20 ),
        backgroundColor: Colors.blue,
        ),
        body: 
          

            Column(
              children: [
                  TextField(
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "Enter your email here"
                    ),
                    controller: _email,
                  ),
                  TextField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: "Enter your password here"
                    ),
                    controller: _password,
                  ),
                  TextButton(
                    onPressed: () async {
                      
                      final email = _email.text.trimRight() ;
                      final password = _password.text ;
                      try {
                        await AuthService.firebase().createUser (
                        email: email ,
                        password: password ,
                        );
                        AuthService.firebase().sendEmailVerification() ;
                        Navigator.of(context).pushNamed(verifyEmailRoute) ;
                      }on WeakPassword {
                          await showErrorDialog(context,"Weak Password") ;
                      }on EmailAlreadyInUse {
                          await showErrorDialog(context, "Email already in use" ) ;
                      }on InvalidEmail catch(e){
                        devtools.log(e.toString()) ;
                          await showErrorDialog(context, "Invalid Email") ;
                      }on GenericAuthException catch (_){
                        await showErrorDialog(context, "Authentication Error") ;
                      }
                    },
                    child: const Text('Register '),
                    ),
                    TextButton(onPressed: (){
                      Navigator.of(context).pushNamedAndRemoveUntil( 
                        loginRoute, (route) => false ) ;
                    }, child: 
                    const Text("Already Registered ? Login here!")
                    ),
                    TextButton(onPressed: (){
                      AuthService.firebase().logOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false) ;
                    }, child: const Text("restart"))
                ],)
                          ) ;
                          
                    
                }
        
          
      
}
      
  

