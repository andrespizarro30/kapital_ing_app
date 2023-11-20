import 'package:firebase_database/firebase_database.dart';

class CurrentUserInfo {

  String? id;
  String? FullName = "";
  String? modulePermissions = "";
  String? password = "";
  String? projectPermissions = "";
  String? userName = "";
  String? userType = "";

  CurrentUserInfo({this.FullName,this.modulePermissions,this.password,this.projectPermissions,this.userName,this.userType});

  CurrentUserInfo.fromSnapshot(DataSnapshot dataSnapshot){

    if(dataSnapshot != null){

      Map valueMap = dataSnapshot.value as Map;

      id = valueMap["-4"];
      FullName = valueMap["value"]["FullName"].toString();
      modulePermissions = valueMap["value"]["modulePermissions"].toString();
      password = valueMap["value"]["password"].toString();
      projectPermissions = valueMap["value"]["projectPermissions"].toString();
      userName = valueMap["value"]["userName"].toString();
      userType = valueMap["value"]["userType"].toString();

    }

  }

  Map<String,dynamic> toMap(){
    return{
      'id': id,
      'FullName': FullName,
      'modulePermissions':modulePermissions,
      'password':password,
      'projectPermissions':projectPermissions,
      'userName':userName,
      'userType':userType,
    };
  }

}