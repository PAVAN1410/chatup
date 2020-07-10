import 'package:flutter/material.dart';
import 'package:skype_3/utils/universal_variables.dart';


class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0
      ,width: 60.0,
      decoration: BoxDecoration(
        gradient: UniversalVariables.fabGradient,
        borderRadius: BorderRadius.circular(100),
      ),
      
      child: Align(
        alignment: Alignment.center,
        child: Icon(
        Icons.edit,
        color: Colors.white,
        ) ,
      ),
      
        //padding: EdgeInsets.all(25),
    );
  }
}