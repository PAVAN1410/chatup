import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:skype_3/Models/user.dart';
import 'package:skype_3/Resources_/firebase_repository.dart';
import 'package:skype_3/Screens/chat_Screen/chatScreen.dart';
import 'package:skype_3/Widgets/customTile.dart';
import 'package:skype_3/utils/universal_variables.dart';

class SearchScreen extends StatefulWidget {
  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  FirebaseRepository _repository = FirebaseRepository();
  List<User> userList;
  String query = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository.getCurrrentUser().then((FirebaseUser user){
      _repository.fetchAllUsers(user).then((List<User> list){
        userList = list;
        print(userList[0].username);

      });

    });
  }

  searchAppBar(BuildContext context){
    return GradientAppBar(
      
      gradient: LinearGradient(colors: [UniversalVariables.gradientColorStart,UniversalVariables.gradientColorEnd]) ,

      leading:  IconButton(
        icon:Icon(Icons.arrow_back,color: Colors.white,),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0.0,
      bottom: PreferredSize(
         preferredSize: const Size.fromHeight(kToolbarHeight+ 20),
         child: Padding(
           padding: const EdgeInsets.only(left:15.0),
           child: TextField(
             controller: searchController,
             onChanged: (val){
               
               setState(() {
               query = val;                 
               });

             },
             cursorColor: UniversalVariables.blackColor,
             autofocus: true,
             style: TextStyle(
               fontWeight: FontWeight.bold,
               color: Colors.white,
               fontSize: 35
             ),
           decoration: InputDecoration(
             suffixIcon: IconButton(icon: Icon(Icons.close,color: Colors.white,),
              onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) => searchController.clear());
                 })
           ,border: InputBorder.none,
            hintText: "search",
            hintStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35,
              color: Colors.white,
            )
           ),
           ),
           
         ),
    ));


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchAppBar(context),
      backgroundColor: UniversalVariables.blackColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: buildSuggestions(query),
      ),
    );
  }
  buildSuggestions(String query){
    final List<User> suggestionList = query.isEmpty? [] : userList != null ?
    userList.where((User user){
      String _getUserName = user.username.toLowerCase();
      String _query = query.toLowerCase();
      String _getName = user.name.toLowerCase();
      bool matchUserName = _getUserName.contains(_query);
      bool matchName = _getName.contains(_query);
      return (matchName || matchUserName);
    }
      // (User user) => (user.username.toLowerCase().contains(query.toLowerCase())) ||
      //             (user.name.toLowerCase().contains(query.toLowerCase())),
      ).toList(): [];

      return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: ((context,index){
          User searchedUser = User(
            uid: suggestionList[index].uid,
            profilePhoto: suggestionList[index].profilePhoto,
            name: suggestionList[index].name,
            username: suggestionList[index].username
          );
          return customeTile(
            mini: false,
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => chatScreen(
                    reciever: searchedUser
                  ) )
              );
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(searchedUser.profilePhoto),
              backgroundColor: Colors.grey,
            ),
            title: Text(
              searchedUser.username,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
              
            ),
            subtitle: Text(
              searchedUser.name,
              style: TextStyle(
                color: UniversalVariables.greyColor
              ),
            ),
          );
        }));
  }
}