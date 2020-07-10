import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype_3/Models/contacts.dart';
import 'package:skype_3/Resources_/firebase_repository.dart';
import 'package:skype_3/Screens/Call_Screens/pickUp/pickup_layout.dart';
import 'package:skype_3/Screens/Page_Views/widgets/contactview.dart';
import 'package:skype_3/Screens/Page_Views/widgets/new_chat_button.dart';
import 'package:skype_3/Screens/Page_Views/widgets/quiteBox.dart';
import 'package:skype_3/Screens/Page_Views/widgets/user_circle.dart';
import 'package:skype_3/Widgets/appBar.dart';
import 'package:skype_3/Widgets/customTile.dart';
import 'package:skype_3/provider/user_provider.dart';
import 'package:skype_3/utils/universal_variables.dart';
import 'package:skype_3/utils/utilites.dart';

final FirebaseRepository _repository = FirebaseRepository();

class ChatListScreen extends StatelessWidget {


 
  CustomAppBar customAppBar(BuildContext context){
    return CustomAppBar(
      leading: IconButton(
              icon: Icon(
          Icons.notifications,
          color: Colors.white,
        ),
      onPressed: (){
      },
      ),
      title: UserCircle(),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,), 
        onPressed:(){
        Navigator.pushNamed(context, '/SearchScreen');
        } ),
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,), 
        onPressed:(){

        } )
      ],
      
    );
  }
  @override
  Widget build(BuildContext context) {
    return pickUpLayout(
          scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: customAppBar(context),
        floatingActionButton: NewChatButton(),
        body: ChatListContainer(),
      ),
    );
  }
}

class ChatListContainer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
  final UserProvider userProvider = Provider.of<UserProvider>(context);
        
        return Container(
     child: StreamBuilder<QuerySnapshot>(
      stream: _repository.fetchContact(
        userId: userProvider.getUser.uid,
      ),
      builder: (context, snapshot) {
        
        if(snapshot.hasData){
            var docList = snapshot.data.documents;
            if(docList.isEmpty){
              return QuietBox();
            }
      
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: docList.length,
              itemBuilder: (context, index){
                Contact contact = Contact.fromMap(docList[index].data);

                return ContactView(contact);
              }
              );
        }
        else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}


