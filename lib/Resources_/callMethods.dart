import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skype_3/Models/call.dart';
import 'package:skype_3/constants/Strings.dart';

class CallMethods{
  final CollectionReference callConnection =
       Firestore.instance.collection(CALL_CONNECTION);

  Stream<DocumentSnapshot> callStream({String uid}) =>
      callConnection.document(uid).snapshots();
  
  Future<bool> makeCall({Call call}) async{
    try {
      call.hasDailled = true;
      Map<String,dynamic> hasDiledMap = call.toMap(call);
      call.hasDailled = false;
      Map<String,dynamic> hasNotDiledMap = call.toMap(call);

      await callConnection.document(call.callerId).setData(hasDiledMap);
      await callConnection.document(call.recieverId).setData(hasNotDiledMap);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall({Call call}) async{
    try {
      await callConnection.document(call.callerId).delete();
      await callConnection.document(call.recieverId).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}