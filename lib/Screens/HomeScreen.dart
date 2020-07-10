import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:skype_3/Resources_/firebase_repository.dart';
import 'package:skype_3/Screens/Call_Screens/pickUp/pickup_layout.dart';
import 'package:skype_3/Screens/Page_Views/chat_list_screen.dart';
//import 'package:skype_3/Screens/Call%20Screens/pickUp/pickup_layout.dart';
//import 'package:skype/Page%20Views/chat_list_screen.dart';
//import 'package:skype/Page Views/chat_list_screen.dart';
//import 'package:skype_3/Screens/Page%20Views/chat_list_screen.dart';
import 'package:skype_3/enum/user_state.dart';
import 'package:skype_3/provider/user_provider.dart';
import 'package:skype_3/utils/universal_variables.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver{
  FirebaseRepository _repository = FirebaseRepository();
  PageController pageController ;
  int _page=0;
  UserProvider userProvider;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
    userProvider = Provider.of<UserProvider>(context,listen: false);
    await userProvider.refreshUser();

    _repository.SetUserState(userId: userProvider.getUser.uid, userState: UserState.OnLine);

    });
    
    WidgetsBinding.instance.addObserver(this);
    pageController = PageController();


  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    String currentUserId =
    (userProvider != null && userProvider.getUser != null) ?userProvider.getUser.uid :'';
    super.didChangeAppLifecycleState(state);
    switch (state) {
      
      case AppLifecycleState.resumed:
        currentUserId != null ? _repository.SetUserState(userId: currentUserId, userState: UserState.OnLine)
        :print('resumed state');
        break;
      case AppLifecycleState.inactive:
        currentUserId != null ? _repository.SetUserState(userId: currentUserId, userState: UserState.Offline)
        :print('inactive state');
        break;
      case AppLifecycleState.paused:
        currentUserId != null ? _repository.SetUserState(userId: currentUserId, userState: UserState.Waiting)
        :print('paused state');
        break;
      case AppLifecycleState.detached:
        currentUserId != null ? _repository.SetUserState(userId: currentUserId, userState: UserState.Offline)
        :print('detached state');
        break;
    }
  }

  void onPageChanged(int page){
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page){
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    double _lableFontSize = 10.0;
    return pickUpLayout(
          scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
            body: PageView(
              children: <Widget>[
                Container(child: ChatListScreen(),),
                Center( child: Text("Call Logs"),),
                Center( child: Text("Contact Screen"),),
              ],
              controller: pageController ,
              onPageChanged: onPageChanged,

            ),
            bottomNavigationBar: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CupertinoTabBar(
                  
                  backgroundColor: UniversalVariables.blackColor,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.chat,
                      color: (_page==0)?UniversalVariables.lightBlueColor:UniversalVariables.greyColor,),
                      title: Text("chats",
                      style: TextStyle(
                        color: (_page==0) ?UniversalVariables.lightBlueColor: UniversalVariables.greyColor,
                        fontSize: _lableFontSize
                      ),)  
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.call,
                      color: (_page==1)?UniversalVariables.lightBlueColor:UniversalVariables.greyColor,),
                      title: Text("calls",
                      style: TextStyle(
                        color: (_page==1) ?UniversalVariables.lightBlueColor: UniversalVariables.greyColor,
                        fontSize: _lableFontSize
                      ),)
                    
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.chat,
                      color: (_page==2)?UniversalVariables.lightBlueColor:UniversalVariables.greyColor,),
                      title: Text("contacts",
                      style: TextStyle(
                        color: (_page==2) ?UniversalVariables.lightBlueColor: UniversalVariables.greyColor,
                        fontSize: _lableFontSize
                      ),)
                    
                  )
                  ],
                  currentIndex: _page,
                  onTap: navigationTapped,

                  ),
              ),
            ),
      ),
    );
  }
}