class User{

  String uid;
  String name;
  String email;
  String username;
  String status;
  int state;
  String profilePhoto;

  User({
    this.uid,
    this.name,
    this.email,
    this.profilePhoto,
    this.state,
    this.status,
    this.username,
    
  });

  Map toMap(User user){
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['username'] = user.username; 
    data['name'] = user.name;
    data['email'] = user.email;
    data['state'] = user.state;
    data['profilePhoto'] = user.profilePhoto;
    data['status'] = user.status;
    return data;
  }

  User.fromMap(Map<String, dynamic> data){
    this.uid= data['uid'];
    this.name = data['name'];
    this.username =  data['username'];
    this.status =data['status'];
    this.state =data['state'];
    this.email = data['email'] ;
    this.profilePhoto =data['profilePhoto'];
  }
}