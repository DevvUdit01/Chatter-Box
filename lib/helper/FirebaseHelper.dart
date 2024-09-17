
import 'package:chatter_box/core/models/UserModal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {

  static Future<UserModel?> getUserModelById(String uid) async{
    UserModel? userMode;

   DocumentSnapshot docSnap =await FirebaseFirestore.instance.collection("users").doc(uid).get();
   
   if(docSnap.data() != null){
     userMode= UserModel.fromMap(docSnap.data() as Map<String,dynamic>);
   }

   return userMode;
    }
}