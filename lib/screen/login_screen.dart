import 'package:flutter/material.dart';
import 'package:kapital_ing_app/databases/current_projects_database.dart';
import 'package:kapital_ing_app/main.dart';
import 'package:kapital_ing_app/models/current_projects_model.dart';
import 'package:sqflite/sqflite.dart';

import '../common_functions/common_functions.dart';
import '../models/current_user_data.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController userTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();

  String? dropdownValue = "";
  List<CurrentProject> currentProjects = [];

  CurrentUserInfo? currentUserInfo = CurrentUserInfo();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    retrieveCurrentProjects();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("CONSTRUCTORA KAPITAL"),
          backgroundColor: Colors.yellow,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage("images/kapital_logo.jpg"),
                  width: 250.0,
                  height: 250.0,
                  alignment: Alignment.bottomCenter,
                ),
                SizedBox(height: 15.0,),
                Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 24.0,
                      fontFamily: "Brand-Bold",
                      color: Colors.black
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text("Proyecto"),
                      SizedBox(height: 1.0,),
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: Icon(Icons.arrow_drop_down),
                        items: currentProjects.map<DropdownMenuItem<String>>((project) {
                          return DropdownMenuItem<String>(
                            value: project!.projectName!,
                            child: Text(project.projectName!),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            dropdownValue = value;
                            currentProjectG = value;

                            int index = currentProjects.indexWhere((project) => project.projectName == value);

                            currentProjectId = currentProjects[index].projectId!;

                          });
                        },
                        isExpanded: true,
                      ),
                      SizedBox(height: 1.0,),
                      TextField(
                        controller: userTEC,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            labelText: "Usuario",
                            labelStyle: TextStyle(
                                fontSize: 14.0,
                                fontFamily: "Brand-Bold",
                                color: Colors.black
                            ),
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 10.0,
                            )
                        ),
                        style: TextStyle(fontSize: 14.0,fontFamily: "Brand-Regular",color: Colors.black),
                        onChanged: (String? value){
                          userType = value;
                        }
                      ),
                      SizedBox(height: 1.0,),
                      TextField(
                        controller: passwordTEC,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(
                                fontSize: 14.0,
                                fontFamily: "Brand-Bold",
                                color: Colors.black
                            ),
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 10.0,
                            )
                        ),
                        style: TextStyle(fontSize: 14.0,fontFamily: "Brand-Regular",color: Colors.black),
                      ),
                      SizedBox(height: 10.0,),
                      ElevatedButton(
                        child: Container(
                          height: 50.0,
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(fontSize: 18.0,fontFamily: "Brand-Bold"),
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.yellow,
                            backgroundColor: Colors.black,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(12.0)
                            )
                        ),
                        onPressed: () async{

                          if(dropdownValue != ""){

                            verifyUserData();

                          }else{
                            displayToastMessages("Seleccione un proyecto", context);
                          }

                        },
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10.0,),
              ],
            ),
          ),
        )
    );
  }

  void verifyUserData() async{

    var isConnected = await testInternetConnection();

    if(isConnected){
        await usersRef
            .orderByChild("userName")
            .equalTo(userTEC.text)
            .once()
            .then((snapShot) {

              if(snapShot.snapshot.value != null){

                Map keysTrips = snapShot.snapshot.value as Map;

                keysTrips.forEach((key, value) {

                  currentUserInfo!.FullName = value["FullName"];
                  currentUserInfo!.modulePermissions = value["modulePermissions"];
                  currentUserInfo!.password = value["password"];
                  currentUserInfo!.projectPermissions = value["projectPermissions"];
                  currentUserInfo!.userName = value["userName"];
                  currentUserInfo!.userType = value["userType"];

                });

                List<String> projectPermissionsList =  currentUserInfo!.projectPermissions!.split(",");

                if(projectPermissionsList.contains(currentProjectId) || projectPermissionsList.contains("All")){
                  if(currentUserInfo!.userName! == userTEC.text && currentUserInfo!.password! == passwordTEC.text){

                    fullNameG = currentUserInfo!.FullName!;
                    userType = currentUserInfo!.userType!;
                    userCode = currentUserInfo!.userName;
                    modulePermissionsG = currentUserInfo!.modulePermissions!.split(",");
                    Navigator.pushNamedAndRemoveUntil(context, "main_menu", (route) => false);

                  }else{
                    displayToastMessages("Usuario y/o contraseña erroneo, verifique de nuevo", context);
                  }
                }else{
                  displayToastMessages("No tiene permisos para este proyecto", context);
                }

              }
        });

    }

  }

  void retrieveCurrentProjects() async{

    List<CurrentProject> currentProj = [CurrentProject(id: "",projectName: "", projectId: "")];

    CurrentProjectsDatabase cpdb = CurrentProjectsDatabase();
    Database database = await cpdb.CreateTable();

    var isConnected = await testInternetConnection();

    if(isConnected){
      await currentProjectsRef.once().then((snapShot){
        if(snapShot.snapshot.value != null){
          snapShot.snapshot.children.forEach((snapShot) {
            CurrentProject currentProject = CurrentProject.fromSnapshot(snapShot);
            currentProj.add(currentProject);
            cpdb.saveNewProject(currentProject!, database);
          });
        }else{
          displayToastMessages("No hay proyectos actualmente", context);
        }
      });
    }else{
      List<CurrentProject> currentProjectList = await cpdb.getAllCurrentprojects(database);
      currentProjectList.forEach((project) {
        currentProj.add(project);
      });
    }

    setState(() {
      currentProjects = currentProj;
    });

  }

}
