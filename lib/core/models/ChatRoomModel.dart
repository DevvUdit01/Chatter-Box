
class ChatRoomModel{
  String? chatroomid;
  Map<String,dynamic>? participants;
  String? lastMessage;

  ChatRoomModel({this.chatroomid,this.participants,this.lastMessage});

  // frome map constructor
  ChatRoomModel.fromMap(Map<String,dynamic> map){
    chatroomid = map["chatroomid"];
    participants = map["participants"];
    lastMessage = map["lastmessage"];
  }

  // to map constructo
   Map<String,dynamic> toMap(){
    return {
      "chatroomid" : chatroomid,
      "participants" : participants,
      "lastmessage" :lastMessage,
    };
   }
}