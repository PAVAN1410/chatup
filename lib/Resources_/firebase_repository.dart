import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skype_3/Models/message.dart';
import 'package:skype_3/Models/user.dart';
import 'package:skype_3/Resources_/firebase_method.dart';
import 'package:skype_3/enum/user_state.dart';
import 'package:skype_3/provider/image_upload_provider.dart';

class FirebaseRepository{

  FirebaseMethods _firebaseMethods = FirebaseMethods();

  // to get current user
  Future<FirebaseUser> getCurrrentUser () => _firebaseMethods.getCurrentUser();
  
  // signin with google
  Future<FirebaseUser>  signIn() => _firebaseMethods.signIn();

  // authenticating user to home screen based on users connection to application i.e, new user or old
  Future<bool> authenticateUser(FirebaseUser user) => _firebaseMethods.authenticateUser(user);

  // adds data to database
  Future<void> addDataToDb(FirebaseUser user) => _firebaseMethods.addDataToDb(user);

  // resposnsible for signing out
  Future<bool> signOut() => _firebaseMethods.signOut();

  // get all documents from firebase
  Future<List<User>> fetchAllUsers(FirebaseUser user) => _firebaseMethods.fetchAllUsers(user);

  //add messages to database
  Future<void> addMessageToDb(Message message, User sender, User reciever) => 
  _firebaseMethods.addMessageToDb(message, sender, reciever) ;

  void uploadImage({@required File image, 
  @required String senderId, 
  @required String recieverId,
  @required ImageUploadProvider imageUploadProvider}) =>
        _firebaseMethods.uploadImage(image:image,
        senderId: senderId,
        recieverId: recieverId, 
        imageUploadProvider: imageUploadProvider);

  Future<User> getUserDetails() => _firebaseMethods.getUserDetails();

  addToContact({String senderId, String receiverId}) => _firebaseMethods.addToContact(senderId: senderId,receiverId: receiverId);



  Stream<QuerySnapshot> fetchContact({String userId}) => _firebaseMethods.fetchContact(userId: userId);

  Stream<QuerySnapshot> fetchLastMessage({@required String senderId, @required String receiverId}) => 
                    _firebaseMethods.fetchLastMessage(senderId: senderId, receiverId: receiverId);


  Future<User> getUserDetailsById(id) => _firebaseMethods.getUserDetailsById(id);

  void SetUserState({@required String userId, @required UserState userState}) =>
               _firebaseMethods.SetUserState(userId: userId, userState: userState);


    Stream<DocumentSnapshot> getUserStream({@required String uid}) =>
                  _firebaseMethods.getUserStream(uid: uid);
}