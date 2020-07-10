
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:skype_3/Models/message.dart';
import 'package:skype_3/Models/user.dart';
import 'package:skype_3/Resources_/firebase_repository.dart';
import 'package:skype_3/Screens/chat_Screen/widgets/cashedImages.dart';
import 'package:skype_3/Widgets/appBar.dart';
import 'package:skype_3/Widgets/customTile.dart';
import 'package:skype_3/constants/Strings.dart';
import 'package:skype_3/enum/viewState.dart';
import 'package:skype_3/provider/image_upload_provider.dart';
import 'package:skype_3/utils/call_utils.dart';
import 'package:skype_3/utils/permissions.dart';
import 'package:skype_3/utils/universal_variables.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:skype_3/utils/utilites.dart';


class chatScreen extends StatefulWidget {
  final User reciever;
  chatScreen({this.reciever});
  @override
  _chatScreenState createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> {
    User sender;
    String _currentUserId;
    bool isWriting =false;
    bool showEmojiPicker = false;
    ImageUploadProvider _imageUploadProvider ;
    
    TextEditingController textEditingController = TextEditingController();
    FirebaseRepository _repository = FirebaseRepository();

    ScrollController _listScrollController = ScrollController();
    FocusNode textFieldFocus = FocusNode();

    showKeyboard() {
      textFieldFocus.requestFocus();
    }

    hideKeyboard() => textFieldFocus.unfocus();

    hideEmojiContainer(){
      setState(() {
        showEmojiPicker = false;
      });
    }
    showEmojiContainer(){
      setState(() {
        showEmojiPicker = true;
      });
    }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository.getCurrrentUser().then((user){
      _currentUserId = user.uid;
      setState(() {
        sender = User(
          uid: user.uid,
          name: user.displayName,
          profilePhoto: user.photoUrl
        );
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Flexible(
            child: messageList()
            ),
          _imageUploadProvider.getViewState == ViewState.LOADING 
                ? Container
                (
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(right:16),                  
                  child: CircularProgressIndicator()) 
                : Center(),
          chatControls(),
          showEmojiPicker ? Container(
            child: emojiContainer(),
          ): Center(),
        ],
      ),
    );
  }

  emojiContainer(){

   return EmojiPicker(
     bgColor: UniversalVariables.separatorColor,
     indicatorColor: UniversalVariables.blueColor,
     rows: 3,
     columns: 7,
     onEmojiSelected: ( emoji, categpry){
       setState(() {
         isWriting = true;
       });
       textEditingController.text = textEditingController.text + emoji.emoji;

     },
     recommendKeywords: ["face","happy",'party','sad','laugh'],
     numRecommended: 30,

   );
  }

  Widget messageList(){
    return StreamBuilder(
      stream: Firestore.instance
      .collection(Message_collections)
      .document(_currentUserId)
      .collection(widget.reciever.uid)
      .orderBy(Timestamp_Field,descending: true)
      .snapshots(),
      builder:(context,AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.data == null){
          return Center(child: CircularProgressIndicator(),);
          }

          // SchedulerBinding.instance.addPostFrameCallback((_) {
          //   _listScrollController.animateTo(
          //     _listScrollController.position.minScrollExtent,
          //     duration: Duration(milliseconds: (200)), curve: Curves.ease);
          // });

       return  ListView.builder(
      padding: EdgeInsets.all(10),
      reverse: true,
      controller: _listScrollController,
      itemCount: snapshot.data.documents.length,//1,//snapshot.data.documents.length,
      itemBuilder: (context,index){
        return chatMessageItem(snapshot.data.documents[index]);
      } );
      
      } 
      
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot){

    Message _message = Message.fromMap(snapshot.data);
    return Container(
      margin: EdgeInsets.symmetric( vertical: 15.0),
      child: Container(
        alignment: _message.senderId == _currentUserId 
              ? Alignment.centerRight 
              : Alignment.centerLeft,
        child: _message.senderId == _currentUserId 
              ? senderLayout(_message) 
              : recieverLayout(_message),
      ),
    );
  }

  Widget senderLayout(Message message){
    Radius messageRadius = Radius.circular(10);
    
    return Container(
      margin: EdgeInsets.only(top:12),
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.65),
      decoration: BoxDecoration(
        color: UniversalVariables.senderColor,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius
        )
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: getMessage(message)
      ),
    );
  }

  getMessage(Message message) {
    return message.type != Image_Message_Type ?
     Text(
     message.message ,
     
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0
      ),
    ) : message.photoUrl != null?  CachedImage(
      message.photoUrl,
      height: 250,
      width: 250,
      radius: 10,
    ) : Text('url was null');
  }



 Widget recieverLayout(Message message){
    Radius messageRadius = Radius.circular(10);
    
    return Container(
      margin: EdgeInsets.only(top:12),
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.65),
      decoration: BoxDecoration(
        color: UniversalVariables.receiverColor,
        borderRadius: BorderRadius.only(
          bottomRight: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius
        )
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: getMessage(message)
      ),
    );
  }

  Widget chatControls(){
    
    setWritingTo(bool val){
      setState(() {
        isWriting = val;
      });
    }

  addMediaModal(context){
    showModalBottomSheet(
      context: context,
      elevation: 0.0,
      backgroundColor: UniversalVariables.blackColor,
      builder: (context) {
        return Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: <Widget>[
                  FlatButton(
                    child: Icon(Icons.close),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft ,
                      child: Text(
                        'content and tools',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                        ),
                      ))
                ],
              ),
            ),
            Flexible(
              child: ListView(
                children: <Widget>[
                  ModelTile(
                    title: "Media",
                    subtitle: "share photos and videos",
                    icon: Icons.image,
                  ),
                  ModelTile(
                    title: "File",
                    subtitle: "share files",
                    icon: Icons.tab,
                    onTap:() => pickImage(source: ImageSource.gallery),
                  ),
                  ModelTile(
                    title: "contact",
                    subtitle: "share contact",
                    icon: Icons.contacts,
                  ),ModelTile(
                    title: "Location",
                    subtitle: "share a location",
                    icon: Icons.add_location,
                  ),ModelTile(
                    title: "Scheduled calls",
                    subtitle: "Arrange a skype call and get remainder",
                    icon: Icons.schedule,
                  ),
                  ModelTile(
                    title: "create poll",
                    subtitle: "share poll",
                    icon: Icons.poll,
                  ),
                ],
              ),
            )
          ],
        );
      }
    );
  }


    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              gradient: UniversalVariables.fabGradient,
              shape: BoxShape.circle,
            ),
            child: GestureDetector(
              child: 
              Icon(Icons.add),
              onTap: () => addMediaModal(context),
              ),
          ),
          SizedBox(width: 5,),
          Expanded(
            child: Stack(
              children: <Widget>[
                TextField(
                controller: textEditingController,
                focusNode: textFieldFocus,
                onTap: (){
                  showKeyboard();
                  hideEmojiContainer();
                },
                style: TextStyle(
                  color: Colors.white
                ),
                onChanged: (val) {
                  (val.length>0  &&  val.trim() != "") ? setWritingTo(true) : setWritingTo(false);
                },
                decoration: InputDecoration(
                  hintText: "Type a message",
                  hintStyle:  TextStyle(
                    color: UniversalVariables.greyColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(50.0),
                    ),
                    borderSide: BorderSide.none,
                  )
                  ,contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  fillColor: UniversalVariables.separatorColor,
                  filled: true,
                  
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                              child: IconButton(
                      onPressed: (){
                        if(!showEmojiPicker){
                          // we have to hide keyboard if it  is opened already
                          hideKeyboard();
                          showEmojiContainer();
                        }
                        else{
                          showKeyboard();
                          hideEmojiContainer();
                        }
                      },
                      icon: Icon(Icons.face),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,

                    ),
              )
              ]
            )
             ),
             (isWriting)? Container():Padding(
               padding: const EdgeInsets.symmetric(horizontal: 10),
               child: Icon(Icons.record_voice_over),
             ),
           (isWriting) ?  Container() 
           :GestureDetector(
             onTap: () => pickImage(source: ImageSource.camera),
             child: Icon(Icons.camera_alt)
             
             ),
           
           
           (isWriting) ?  Container(
             margin: EdgeInsets.only(left: 10),
             decoration: BoxDecoration(
               gradient: UniversalVariables.fabGradient,
               shape: BoxShape.circle,
             ),
             child: Center(
               child: IconButton(
                 icon: Icon(Icons.send,
                 size: 35,),
                 onPressed: (){
                   sendMessage();
                 },
               ),
             )
           ): Container()
        ],
      ),
    );
  }

  sendMessage(){
    
    var text = textEditingController.text;
    Message _message = Message(
      recieverId: widget.reciever.uid,
      senderId: sender.uid,
      message: text,
      timeStamp: Timestamp.now(),
      type: 'text',
    );

    setState(() {
      isWriting = false;
    });

    textEditingController.text = "";

    _repository.addMessageToDb(_message,sender,widget.reciever);
  }

// pick image function
    pickImage({@required ImageSource source}) async{
      File selectedImage = await Utils.pickImage(source: source);
      _repository.uploadImage(
        image: selectedImage, 
        senderId: _currentUserId, 
        recieverId: widget.reciever.uid,
        imageUploadProvider : _imageUploadProvider);

    }



  CustomAppBar customAppBar(context){
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
         onPressed: (){
           Navigator.pop(context);
         }),
         centerTitle: false,
         title: Text(
           widget.reciever.name,
         ),
         actions: <Widget>[

           IconButton(
             icon: Icon(Icons.video_call),
             onPressed: () async => await Permissions.cameraAndMicrophonePermissionsGranted() ? 
             CallUtils.dial(
               from: sender,
               to: widget.reciever,
               context: context
             ) : {},
           ),
           IconButton(
             icon: Icon(Icons.phone),
             onPressed: (){},
           )

         ],
         
         );
    
  }
}

class ModelTile extends StatelessWidget {
  
  final String title;
  final String subtitle;
  final IconData icon;
  final Function onTap;

  ModelTile({
    @required this.title,
    @required this.subtitle,
    @required this.icon,
    this.onTap
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: customeTile(
        onTap: onTap,
        mini: false,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: UniversalVariables.receiverColor,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: UniversalVariables.greyColor,
            size: 38,
          ),

        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: UniversalVariables.greyColor,
            fontSize: 12
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18
          ),
        ),
      ),
    );
  }
}