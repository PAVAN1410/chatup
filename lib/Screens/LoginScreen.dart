import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skype_3/Resources_/firebase_repository.dart';
import 'package:skype_3/Screens/HomeScreen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skype_3/utils/universal_variables.dart';

class LoignScreen extends StatefulWidget {
  @override
  _LoignScreenState createState() => _LoignScreenState();
}

class _LoignScreenState extends State<LoignScreen> {
 
 FirebaseRepository _repository = FirebaseRepository();
 bool isLoginPressed= false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
        body: Stack(
          
          children: <Widget>[
            Center(child: loginButton(),),
            isLoginPressed? Center(child: CircularProgressIndicator(),) : Center()
          ],
          ),
        
    );
  }
  Widget loginButton(){

    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: UniversalVariables.senderColor,
          child: Center(
        child: FlatButton( 
          padding: EdgeInsets.all(35.0),
            child: Text("login",
            style: TextStyle(
                fontSize: 35.0,
                fontStyle: FontStyle.normal,
                letterSpacing: 1.2)
                ),
            onPressed: ()=> performLogin(),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            
      ),
    );
  }

  void performLogin(){
    setState(() {
      isLoginPressed = true;
    });
    print('object');
    _repository.signIn().then((FirebaseUser user){
      if(user != null){
        authenticateUser(user);
      }
      else{
        print('some error occured');
      }
    });
  }

  void authenticateUser(FirebaseUser user){
    _repository.authenticateUser(user).then((isNewUser){

setState(() { 
  isLoginPressed = false;
});
      if(isNewUser){
        _repository.addDataToDb(user).then((value){
          Navigator.pushReplacement(context, 
          MaterialPageRoute(builder: (context){
            return HomeScreen();
          }));
        });
      }
      else{
        Navigator.pushReplacement(context, 
        MaterialPageRoute(builder: (context){
          return HomeScreen();
        }));
      }
    });
  }
}