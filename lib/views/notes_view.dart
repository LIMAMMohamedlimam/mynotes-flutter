

import 'package:flutter/material.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'package:mynotes/services/auth/auth_service.dart';



class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  AppBar(
        title: const Text("Main UI"),
        backgroundColor: Colors.blue,
        titleTextStyle: const TextStyle(fontSize : 20 , color: Colors.white),
        actions: [
          PopupMenuButton<MenuAction>( 
            iconColor: Colors.white,
            onSelected: (value) async {
              switch(value){
                case MenuAction.logout :
                  final shouldLogout = await showLogOutDialog(context) ;
                  if(shouldLogout){
                    await AuthService.firebase().logOut() ;
                    Navigator.of(context).pushNamedAndRemoveUntil('/login/', (route) => false , ) ;
                  }
                  break ;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(value:MenuAction.logout ,child: Text("Log out"),)
              ] ;
              
            },)
        ],
         ),
        body: const  Text("Hello World") ,
    );
  }
}



Future <bool> showLogOutDialog (BuildContext context){
  return showDialog<bool>(context: context , builder: (context) {
    return   AlertDialog(
      title:   const Text("Sign Out"),
      content: const   Text('Are you sure you want to log out ?'),
      actions: [
        TextButton(onPressed: () {
          Navigator.of(context).pop(false) ;
        }, child: const Text("Cancel")),
        TextButton(onPressed: () {
          Navigator.of(context).pop(true) ;
        }, child: const Text("Log out")),

      ],
    ) ;
  },).then((value) => value ?? false) ;
}
