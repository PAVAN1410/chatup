import 'package:flutter/material.dart';
import 'package:skype_3/Screens/Page_Views/search_screen.dart';
import 'package:skype_3/utils/universal_variables.dart';

class QuietBox extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric( horizontal: 25),
        child: Container(
          color: UniversalVariables.separatorColor,
          padding: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: <Widget>[
              Text('This is where all the contacts are listed',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
              ),

              SizedBox(
                height: 25 ,
              ),

              Text('search for ur friends and family to start calling or chatting with them',
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 1.2,
                fontWeight: FontWeight.normal,
                fontSize: 19,
              ),
              ),
              SizedBox(
                height: 25 ,
              ),
              FlatButton(
                onPressed: () => Navigator.push(context,
                MaterialPageRoute(
                  builder:(context) => SearchScreen() )),
                 child: Text('Start Searching'))
              
            ],
          ),
        ),
        ),
    );
  }

}