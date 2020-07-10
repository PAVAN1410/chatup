import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype_3/Models/call.dart';
import 'package:skype_3/Resources_/callMethods.dart';
import 'package:skype_3/Screens/Call_Screens/pickUp/pickup_screen.dart';
import 'package:skype_3/provider/user_provider.dart';

class pickUpLayout extends StatelessWidget {
  
  final Widget scaffold;
  final CallMethods callMethods = CallMethods();

  pickUpLayout({this.scaffold});
  @override
  Widget build(BuildContext context) {
    
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return (userProvider != null && userProvider.getUser != null) ? 
    StreamBuilder<DocumentSnapshot>(
      stream: callMethods.callStream(uid:userProvider.getUser.uid),
      builder: (context,snapshot){
        if(snapshot.hasData && snapshot.data.data != null){
          Call call = Call.fromMap(snapshot.data.data);
          if (!call.hasDailled) {
            return pickupScreen(call: call);
          }
          return scaffold;
        }else{
          return scaffold;
        }
      },
    ): Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      )
    );
  }
}