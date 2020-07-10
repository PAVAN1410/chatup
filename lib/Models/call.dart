class Call{

  String callerId;
  String callerName;
  String callerPic;
  String recieverId;
  String recieverName;
  String recieverPic;
  String channelId;
  bool hasDailled;

  Call({
    this.callerId,
    this.recieverId,
    this.callerName,
    this.callerPic,
    this.channelId,
    this.hasDailled,
    this.recieverName,
    this.recieverPic
  });


  Map<String,dynamic> toMap(Call call){
    
    Map<String,dynamic> callMap = Map();
    
  this.callerId =  this.callerId;
  callMap['recieverId'] =  this.recieverId;
  callMap['callerName'] =  this.callerName;
  callMap['callerPic'] =  this.callerPic;
  callMap['channelId'] =  this.channelId;
  callMap['hasDailled'] =  this.hasDailled;
  callMap['recieverName'] =  this.recieverName;
  callMap['recieverpic'] =  this.recieverPic;
  callMap['callerId'] = this.callerId;

  return callMap;

  }
Call.fromMap(Map callMap){

  this.callerId =callMap['recieverId'];
  this.callerName = callMap['callerName'];
  this.callerPic = callMap['callerPic'];
  this.channelId = callMap['channelId'];
  this.hasDailled = callMap['hasDailled'];
  this.recieverName =  callMap['recieverName'];
  this.recieverPic = callMap['recieverpic'] ;
  this.callerId = callMap['callerId'];


}

  

  

}