import 'package:flutter/material.dart';
import 'package:skype_3/Models/call.dart';
import 'package:skype_3/Resources_/callMethods.dart';
import 'package:skype_3/Screens/Call_Screens/call_screen.dart';
import 'package:skype_3/utils/permissions.dart';

class pickupScreen extends StatelessWidget {
  
  final Call call;
  final CallMethods callMethods = CallMethods();

  pickupScreen({
    @required this.call,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Incoming',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(height: 50,),
            Image.network(
              call.callerPic,
              height: 150,
              width: 150,
            ),
            SizedBox(height: 35,),
            Text(
              call.callerName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25
              ),
            ),
            SizedBox(height: 50,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.call_end),
                 onPressed: () async{
                   await callMethods.endCall(call : call);
                 },
                 color: Colors.redAccent),
                 IconButton(
                   icon: Icon(Icons.call),
                   color: Colors.green,
                   onPressed: () async => await Permissions.cameraAndMicrophonePermissionsGranted() ?
                     Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder:(context) =>
                         CallScreen(call : call), )
                          ) : {},
                   
                 ),
              ],
            )
          ],
        ),
      ),
    );
  }
}