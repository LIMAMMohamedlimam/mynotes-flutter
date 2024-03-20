


import 'dart:developer' as devetools show log ;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/constants/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

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
        title: const Text("Login" ) ,
        titleTextStyle: const TextStyle(color: Colors.white , fontSize: 20 ),
        backgroundColor: Colors.blue, ),
       body: Column(
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
                    final email = _email.text ;
                    final password = _password.text ;
                    try{
                      final userCredential = await  FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email ,
                      password: password ,
                      );
                      final user = FirebaseAuth.instance.currentUser ;
                      devetools.log(userCredential.toString()) ;
                      if (user != null ){
                        if(user.emailVerified){
                        Navigator.of(context).pushNamedAndRemoveUntil(ntoesRoute, (route) => false ,) ;
                        }else{
                          Navigator.of(context).pushNamed(verifyEmailRoute) ;
                        }
                      }
                    } on FirebaseAuthException catch(e){
                      if(e.code == "invalid-email"){
                        showErrorDialog(context, "Wrong Email") ;
                      }
                      if(e.code == 'invalid-credential'){
                        showErrorDialog(context," La combinaison email-code est invalid") ;
                      }else{
                        showErrorDialog(context , "${e.code} wait !!") ;
                        devetools.log(e.code) ;
                      }
                    }catch (e){
                      devetools.log(e.runtimeType.toString()) ;
                      await showErrorDialog(context, e.toString()) ;
                    }}, 

                  child: const Text('Login'),
                  ),
                TextButton(
                  onPressed: (){
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      registerRoute, (route) => false
                      ) ;
                  },
                  child: const Text("Not registered yet?  Register here!"))
              ],
            ),
     ) ;
          }
        }


