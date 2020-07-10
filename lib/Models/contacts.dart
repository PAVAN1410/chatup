import 'package:cloud_firestore/cloud_firestore.dart';

class Contact{
 String uid;
 Timestamp addedOn;

 Contact ({
   this.addedOn,
   this.uid
 }) ;

 Map toMap(Contact contact){

   var data = Map<String,dynamic>();
   data['contact_id'] = this.uid;
   data['added_on'] =  this.addedOn;
   return data;
 }
 

 Contact.fromMap(Map<String,dynamic> mapData)
 {
   this.uid = mapData['contact_id'];
   this.addedOn = mapData['added_on'];
 }
}