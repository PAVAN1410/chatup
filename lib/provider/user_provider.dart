import 'package:flutter/material.dart';
import 'package:skype_3/Models/user.dart';
import 'package:skype_3/Resources_/firebase_repository.dart';

class UserProvider with ChangeNotifier{

User _user;
FirebaseRepository _firebaseRepository = FirebaseRepository();

User get getUser => _user;

Future<void> refreshUser() async{
  
  User user = await _firebaseRepository.getUserDetails();
  _user = user;
  notifyListeners();
}
  
}