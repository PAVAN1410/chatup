import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skype_3/Models/contacts.dart';
import 'package:skype_3/Models/message.dart';
import 'package:skype_3/Models/user.dart';
import 'package:skype_3/constants/Strings.dart';
import 'package:skype_3/enum/user_state.dart';
import 'package:skype_3/provider/image_upload_provider.dart';
import 'package:skype_3/utils/utilites.dart';

class FirebaseMethods{

  StorageReference _storageReference;

final FirebaseAuth _auth = FirebaseAuth.instance;
GoogleSignIn _googleSignIn = GoogleSignIn();
static final Firestore firestore =Firestore.instance;
static final CollectionReference _userCollection = firestore.collection(Users_collections);
final CollectionReference _messageCollection = firestore.collection(Message_collections);

// user class
User user = User();

// For checking whether user is present or null
  Future<FirebaseUser> getCurrentUser() async{
    FirebaseUser currentUser ;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

// For fetching current user details

Future<User> getUserDetails() async{
  FirebaseUser currentUser = await getCurrentUser();
  DocumentSnapshot documentSnapshot =
                await _userCollection.document(currentUser.uid).get();
      return User.fromMap(documentSnapshot.data);
}


// For fetching any user details by ID

Future<User> getUserDetailsById(id) async{
  try {
  DocumentSnapshot documentSnapshot =
   await _userCollection.document(id).get();

  return User.fromMap(documentSnapshot.data);    
  } catch (e) {
    return null;
  }
}
// Signing in with google

  // Future<FirebaseUser> signIn() async{

  //   GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
  //   GoogleSignInAuthentication _signInAuthentication =
  //   await _signInAccount.authentication;

  //   final AuthCredential credential = GoogleAuthProvider.getCredential(
  //     idToken: _signInAuthentication.idToken, 
  //     accessToken: _signInAuthentication.accessToken); 
  //   AuthResult result= await _auth.signInWithCredential(credential);
  //   FirebaseUser user =result.user;
  //   return user;
  // }

//////
Future<FirebaseUser> signIn() async {
    try {
      GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication _signInAuthentication =
          await _signInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: _signInAuthentication.accessToken,
          idToken: _signInAuthentication.idToken);
        AuthResult result= await _auth.signInWithCredential(credential);
    FirebaseUser user =result.user;
  //    FirebaseUser user = await _auth.signInWithCredential(credential);
      return user;
    } catch (e) {
      print("Auth methods error");
      print(e);
      return null;
    }
  }













Future<bool> signOut() async{
  try {
 // await _googleSignIn.disconnect();
  await _googleSignIn.signOut();
  await _auth.signOut();
  return true;
    
  } catch (e) {
    print(e.toString());
    return false;
  }

 
}


  Future<bool> authenticateUser(FirebaseUser user) async{

    QuerySnapshot result = await firestore
    .collection(Users_collections)
    .where(Email_Field,isEqualTo:  user.email).
    getDocuments();

    final List<DocumentSnapshot> docs = result.documents;
    // If user is registered length of list will be >0 else =0
    return docs.length == 0 ? true : false;
  }



  Future<void> addDataToDb(FirebaseUser currentuser) async{

      String username = Utils.getUserName(currentuser.email);
    user =User(
      uid: currentuser.uid,
      email: currentuser.email,
      name: currentuser.displayName,
      profilePhoto: currentuser.photoUrl,
      username: username,
    );

    firestore.collection(Users_collections).document(currentuser.uid).setData(user.toMap(user));
  }


Future<List<User>> fetchAllUsers(FirebaseUser currentUser) async {
    List<User> userList = List<User>();

    QuerySnapshot querySnapshot =
        await firestore.collection(Users_collections).getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != currentUser.uid) {
        userList.add(User.fromMap(querySnapshot.documents[i].data));
      }
    }
    return userList;
  }
Future<void> addMessageToDb(Message message, User sender, User reciever) async{

  var map = message.toMap();
  await _messageCollection.document(sender.uid).
      collection(reciever.uid).
      add(map);

      addToContact(senderId: message.senderId,receiverId: message.recieverId);

  return _messageCollection.
    document(reciever.uid).
    collection(sender.uid).
    add(map);
}


DocumentReference getContactDoctument({String of,String forContact}) =>
            _userCollection.document(of).collection(CONTACTS_COLLECTION).document(forContact);

addToContact({String senderId, String receiverId}) async{
  Timestamp currentTime = Timestamp.now();

  await addToSenderContact(senderId: senderId,receiverId: receiverId,currentTime: currentTime);
  await addToReceiverContact(senderId: senderId,receiverId: receiverId,currentTime: currentTime);
}

// add a contact document to sender
Future<void> addToSenderContact({String senderId
, String receiverId
,currentTime}) async{
  
 DocumentSnapshot senderSnapshot = await getContactDoctument(of: senderId, forContact: receiverId).get();

 if(!senderSnapshot.exists){
   // does not exist
   Contact receiverContact = Contact(
     uid: receiverId,
    addedOn: currentTime
   );

  Map receiverMap = receiverContact.toMap(receiverContact);
    await getContactDoctument(of: senderId, forContact: receiverId).setData(receiverMap);
 }


}



// add a contact document to receiver
Future<void> addToReceiverContact({String senderId
, String receiverId
,currentTime}) async{
  
 DocumentSnapshot receiverSnapshot = await getContactDoctument(of: receiverId, forContact: senderId).get();

 if(!receiverSnapshot.exists){
   // does not exist
   Contact senderContact = Contact(
     uid: senderId,
    addedOn: currentTime
   );

  Map senderMap = senderContact.toMap(senderContact);
    await getContactDoctument(of: receiverId, forContact: senderId).setData(senderMap);
 }


}

Future<String> uploadImageToStorage(File image) async {

 try {
    _storageReference = FirebaseStorage.instance
      .ref()
      .child('${DateTime.now().millisecondsSinceEpoch}');

  StorageUploadTask _storageUploadTask =  _storageReference.putFile(image);

  var url = await (await _storageUploadTask.onComplete).ref.getDownloadURL();

  return url;

 } catch (e) {
   print(e.toString());
   return null;
 }
}

void setImageMsg(String url, String recieverId, String senderId) async{

  Message message = Message.imageMessage(
    message: "Image",
    recieverId: recieverId,
    senderId: senderId,
    photoUrl: url,
    timeStamp: Timestamp.now(),
    type: 'image'
  );

  var map = message.toImageMap();

  // set the data to database

   await firestore.
      collection(Message_collections).
      document(message.senderId).
      collection(message.recieverId).
      add(map);

   await firestore.
    collection(Message_collections).
    document(message.recieverId).
    collection(message.senderId).
    add(map);

  
}



void uploadImage({@required File image, 
@required String senderId, 
@required String recieverId,
@required ImageUploadProvider imageUploadProvider}) async{

  imageUploadProvider.setToLoading();

  String url = await uploadImageToStorage(image);
  imageUploadProvider.setToIdle();
  setImageMsg(url,recieverId,senderId);
}


Stream<QuerySnapshot> fetchContact({String userId}) => _userCollection
.document(userId)
.collection(CONTACTS_COLLECTION)
.snapshots();


Stream<QuerySnapshot> fetchLastMessage({@required String senderId, @required String receiverId}) => 
_messageCollection
.document(senderId)
.collection(receiverId)
.orderBy(Timestamp_Field)
.snapshots();


void SetUserState({@required String userId, @required UserState userState}){

  int stateNum = Utils.StateToNum(userState);

  _userCollection.document(userId).updateData(
    {
      "state" : stateNum,
    }
  );

}

  Stream<DocumentSnapshot> getUserStream({@required String uid}) =>
        _userCollection.document(uid).snapshots();


}


