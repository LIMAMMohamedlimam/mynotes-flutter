import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
      ),
      home: const HomePage(),
      routes: {
        loginRoute :(context) => const LoginView() ,
        registerRoute :(constexte) => const RegisterView(),
        ntoesRoute :(context) => const NotesView(),
        verifyEmailRoute :(context) => const VerifyEmailView() ,
      },
    ),
    );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
          future: AuthService.firebase().initialize(),
          builder: (context, snapshot) {
            switch(snapshot.connectionState){
              
              case ConnectionState.done:
                final user = AuthService.firebase().currentUser ;

                if (user != null ){
                  if (user.isEmailVerified){
                    return const NotesView() ;
                  }else{
                    Navigator.of(context).pushNamed(verifyEmailRoute) ;
                  }
                }else{
                  return const LoginView() ;
                }
                /* if(user?.emailVerified ?? false ){
                  return const Text("Done") ;
                }else{
                  return const VerifyEmailView() ;

                } */ 
                
                return const VerifyEmailView() ;
                
          default:
            return const CircularProgressIndicator() ;
                
            }
            
          } 
    );
  }
}






