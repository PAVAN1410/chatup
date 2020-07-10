import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skype_3/Models/user.dart';
import 'package:skype_3/Resources_/firebase_repository.dart';
import 'package:skype_3/enum/user_state.dart';
import 'package:skype_3/utils/utilites.dart';

class onlimeDotIndicator extends StatelessWidget {
  
  final String uid;
  final FirebaseRepository _repository = FirebaseRepository();


  getColor(int state){
    switch(Utils.NumToState(state)){

      case UserState.Offline:
        return Colors.red;
      case UserState.OnLine:
        return Colors.green;
      case UserState.Waiting:
        return Colors.orange;
    }
  }
  onlimeDotIndicator({
    @required this.uid,
  });
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _repository.getUserStream(uid: uid) ,
      builder: (context,snapshot){
        User user;
        if(snapshot.data != null && snapshot.data.data != null ){
          user = User.fromMap(snapshot.data.data);
        }

        return Container(
          height: 10,
          width: 10,
          margin: EdgeInsets.only(right: 8,top: 8),
          decoration: BoxDecoration( 
            shape : BoxShape.circle,
            color: getColor(user?.state)
            )
        );
      });
  }
}