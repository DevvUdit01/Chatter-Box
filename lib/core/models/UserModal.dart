
class UserModel{
  String? uid;
  String? fullname;
  String? email;
  String? profilepic;

    UserModel({
      this.uid,
      this.fullname,
      this.email,
      this.profilepic,
    });

    //from map constructor

    UserModel.fromMap(Map<String,dynamic> map){
      uid = map["uid"];
      fullname = map["fullname"];
      email = map["email"];
      profilepic = map["profilepic"];
    }

    //to map constructor
    Map<String,dynamic> toMap(){
      return{
        "uid" : uid,
        "fullname" : fullname,
        "email" : email,
        "profilepic" : profilepic,
      };
    }
}