
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/constants/show_error_dialog.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'dart:developer' as devtools show log ;

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
                    final email = _email.text.trimRight();
                    final password = _password.text ;
                    try{
                      await AuthService.firebase().logIn(
                      email: email ,
                      password: password ,
                      );
                      final user = AuthService.firebase().currentUser ;
                      if (user != null ){
                        if(user.isEmailVerified){
                        Navigator.of(context).pushNamedAndRemoveUntil(ntoesRoute, (route) => false ,) ;
                        }else{
                          Navigator.of(context).pushNamed(verifyEmailRoute) ;
                        }
                      }
                    } on InvalidEmail catch (e){
                      devtools.log(e.toString()) ;
                       await showErrorDialog(context, "Wrong Email") ;
                    } on InvalidCredentials catch(e) {
                      devtools.log(e.toString()) ;
                        await showErrorDialog(context," La combinaison email-code est invalid") ;
                    } on GenericAuthException catch (_){
                      await showErrorDialog(context, "Authentication Error") ;
                    }
                    }, 

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


