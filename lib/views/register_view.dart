import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/constants/show_error_dialog.dart';
import 'package:mynotes/firebase_options.dart';


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
        body: FutureBuilder(
          future: Firebase.initializeApp(
                        options: DefaultFirebaseOptions.currentPlatform,
                      ),
          builder: (context, snapshot) {
            switch(snapshot.connectionState){
              
              case ConnectionState.done:
                return Column(
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
                  try {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email ,
                    password: password ,
                    );
                    Navigator.of(context).pushNamed(verifyEmailRoute) ;
                  }on FirebaseAuthException catch(e) {
                    if (e.message == "Password should be at least 6 characters"){
                     await showErrorDialog(context, "Weark Password") ;
                    }else if (e.code == 'email-already-in-use'){
                    }else if (e.code == "invalid-email"){
                      await showErrorDialog(context, "Invalid Email") ;
                    }else{
                      await showErrorDialog(context, '${e.code}') ;
                    }
                     
                    } catch (e){
                      await showErrorDialog(context, e.toString()) ;
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
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false) ;
                }, child: const Text("restart"))
            ],
          ) ;
          default:
            return const Text('Loading...') ;
                
            }
            
          },
        ),
    );
  }
}

