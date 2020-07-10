//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype_3/Models/contacts.dart';
import 'package:skype_3/Models/user.dart';
import 'package:skype_3/Resources_/firebase_repository.dart';
import 'package:skype_3/Screens/Page_Views/widgets/Last_message_container.dart';
import 'package:skype_3/Screens/Page_Views/widgets/onlineDotIndicator.dart';
import 'package:skype_3/Screens/chat_Screen/chatScreen.dart';
import 'package:skype_3/Screens/chat_Screen/widgets/cashedImages.dart';
import 'package:skype_3/Widgets/customTile.dart';
import 'package:skype_3/provider/user_provider.dart';
import 'package:skype_3/utils/universal_variables.dart';

final FirebaseRepository _repository = FirebaseRepository();

class ContactView extends StatelessWidget {
  final Contact contact;
  ContactView(this.contact);
  @override
  Widget build(BuildContext context) {
          return FutureBuilder<User>(
            future:  _repository.getUserDetailsById(contact.uid),
            builder: (context,snapshot){
              if(snapshot.hasData){
                User user = snapshot.data;

                return ViewLayout(contact: user);
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            });
}


}

class ViewLayout extends StatelessWidget {
  final User contact;
  final FirebaseRepository _repository = FirebaseRepository();

  ViewLayout({@required this.contact});
  @override
  Widget build(BuildContext context) {
  UserProvider userProvider = Provider.of<UserProvider>(context);
    return customeTile(
            mini: false,
            onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context,)=> chatScreen(reciever: contact,))),
            title: Text(
              contact ?. name ?? '...',
              //  i) contact ?.name => contact != null ?contact.name : null
              //  ii) contact.name ?? '...' => contact.name != null ? contact.name : '...'
              //  iii) contact ?. name ?? '...' => (contact != null ? contact.name: null) != null ? contact.name : null
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Arial",fontSize: 19
            ),),
            subtitle: LastMessageContainer(
            stream: _repository.fetchLastMessage(senderId: userProvider.getUser.uid, receiverId: contact.uid),
            ),
            leading: Container(
              constraints: BoxConstraints(maxHeight: 60,maxWidth: 60),
              child: Stack(
                children: <Widget>[
                  // CachedImage(
                  //   contact.profilePhoto,
                  //   radius: 80,
                  //   isRound: true,
                  // ),
                  Center(child: Text('...')),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: onlimeDotIndicator(uid: contact.uid)
                  )

                ],
              ),
            ),
          );  }
  }