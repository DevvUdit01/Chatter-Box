
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel{
  String? messageid;
  String? sender;
  String ?text;
  bool? seen;
  DateTime? createdon;

  MessageModel({this.messageid,this.sender,this.text,this.seen,this.createdon});
  // frome map constructor
  MessageModel.fromMap(Map<String,dynamic> map){
    sender = map["sender"];
    text = map["text"];
    seen = map["seen"];
    createdon = (map['createdon'] as Timestamp).toDate();
    messageid = map["messageid"];
  }

  // to map constructor
   Map<String,dynamic> toMap(){
    return {
      "sender" : sender,
      "text"  : text,
      "seen " : seen,
      "createdon" : createdon,
      "messageid" : messageid,
     };
   }
}