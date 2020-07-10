import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype_3/Models/user.dart';
import 'package:skype_3/Resources_/firebase_repository.dart';
import 'package:skype_3/Screens/HomeScreen.dart';
import 'package:skype_3/Screens/LoginScreen.dart';
import 'package:skype_3/Screens/Page_Views/search_screen.dart';
import 'package:skype_3/provider/image_upload_provider.dart';
import 'package:skype_3/provider/user_provider.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    FirebaseRepository _repository = FirebaseRepository();

    // return MaterialApp(home: speechToText());

    return MultiProvider(
      providers: [
          ChangeNotifierProvider<ImageUploadProvider>(
      create: (context) => ImageUploadProvider(),),
      ChangeNotifierProvider(
        create: (context) => UserProvider(),
      )],
    
     child: MaterialApp(
        title: "Skype clone",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(brightness: Brightness.dark,),
        initialRoute: '/',
        routes: {
          '/SearchScreen' : (context) => SearchScreen(),
        },
            home: FutureBuilder(
              future: _repository.getCurrrentUser(),
              builder: (context,AsyncSnapshot<FirebaseUser> snapshot){
                if(snapshot.hasData){
                  print('++++++++++++++++++++++++++++++++++++++++++++++')
;                  print('++++++++++++++++++ ${snapshot.data.photoUrl}');
                  return HomeScreen();
                }
                else{
                  return LoignScreen();
                }
                
              }

              
              
              )
      ));
    
  }
}