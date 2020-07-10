import 'package:cloud_firestore/cloud_firestore.dart';

class Message{

  String senderId;
  String recieverId;
  String type;
  String message;
  Timestamp timeStamp;
  String photoUrl;

  Message({
    this.senderId,
    this.recieverId,
    this.type,
    this.message, 
    this.timeStamp, String receiverId
  });

// Is called only when u wish to send an image
  Message.imageMessage({
    this.senderId,
    this.recieverId,
    this.type,
    this.message, 
    this.timeStamp,
    this.photoUrl
  });


  Map toMap() {
    
    var map = Map<String, dynamic>();
    map['senderId'] = this.senderId ;
    map['recieverId'] = this.recieverId ;
    map['type'] = this.type ;
    map['message'] = this.message ;
    map['timeStamp'] = this.timeStamp;
    return map;
  }


  Map toImageMap() {
    
    var map = Map<String, dynamic>();
    map['senderId'] = this.senderId ;
    map['recieverId'] = this.recieverId ;
    map['type'] = this.type ;
    map['message'] = this.message ;
    map['timeStamp'] = this.timeStamp;
    map['photoUrl'] = this.photoUrl;
    return map;
  }

  Message.fromMap( Map<String, dynamic> map ){
    
    //Message _message = Message();

    this.senderId= map['senderId'];
    this.recieverId =  map['recieverId'] ;
    this.type = map['type'] ;
    this.message =map['message'] ;
    this.timeStamp = map['timeStamp'];
    this.photoUrl = map['photoUrl'];

    //return _message;

  }

  // Message.fromImageMap( Map<String, dynamic> map ){
    
  //   //Message _message = Message();

  //   this.senderId= map['senderId'];
  //   this.recieverId =  map['recieverId'] ;
  //   this.type = map['type'] ;
  //   this.message =map['message'] ;
  //   this.timeStamp = map['timeStamp']; 
  //   this.photoUrl = map['photoUrl'];

  //   //return _message;

  // }




}