import 'package:firebase_database/firebase_database.dart';

class CurrentProject {

  String? id = "";
  String? projectName = "";
  String? projectId = "";

  CurrentProject({this.id,this.projectName,this.projectId});

  CurrentProject.fromSnapshot(DataSnapshot dataSnapshot){

    if(dataSnapshot != null){

      Map valueMap = dataSnapshot.value as Map;

      id = dataSnapshot.key.toString();
      projectName = valueMap["projectName"].toString();
      projectId = valueMap["projectId"].toString();

    }

  }

  Map<String,dynamic> toMap(){
    return{
      'id': id,
      'projectName':projectName,
      'projectId':projectId,
    };
  }

}