class UserModel{
  String? uid;
  String? fullname;
  String? email;
  String? profilepic;

  UserModel({this.uid,this.fullname,this.email,this.profilepic});
  UserModel.fromMap(Map<String,dynamic> map){
    uid=map['uid'];
    email=map['email'];



  }

  Map<String,dynamic> toMap(){
    return {
      'uid':uid,
      'email':email,
    };
  }
}