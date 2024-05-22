import 'package:cloud_firestore/cloud_firestore.dart';


class UserModel{

  String? email;
  String? password;
  String? name;
  DateTime? createdAt;
  int? status;
  String? uid;

  UserModel({this.email,this.uid,this.password,this.name,this.status,this.createdAt});
  factory  UserModel.fromJson(DocumentSnapshot data){
    return UserModel(
      email: data['email'],
      uid: data['uid'],
      name: data['name'],
      status: data['status'],
      createdAt: data['createdAt'],
    );
  }

  Map<String,dynamic>toJson(){
    return {
      'uid':uid,
      'name':name,
      'email':email,
      'status':status,
      'createdAt':createdAt,

    };
  }

}