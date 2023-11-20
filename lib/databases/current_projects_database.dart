import 'dart:io';

import 'package:kapital_ing_app/models/current_projects_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class CurrentProjectsDatabase{

  Future<Database> CreateTable() async{

    var appDirectory = await getDownloadsDirectory();

    String appImagesPath = appDirectory!.path;

    Directory folderDir = Directory("${appImagesPath}/databases");

    if(await folderDir.exists() == false){
      await folderDir.create(recursive: true);
    }

    var database = openDatabase(
        join(folderDir.path, 'current_projects_database.db'),
        onCreate: (db, version){
          return db.execute(
              "CREATE TABLE current_projects("
                  "id INTEGER PRIMARY KEY,"
                  "projectName TEXT,"
                  "projectId TEXT)"
          );
        },
        version: 1
    );

    return database;

  }

  Future<void> saveNewProject(CurrentProject currentProject,Database database)async{

    final Database db = database;

    await db.insert('current_projects', currentProject.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);

  }

  Future<List<CurrentProject>> getAllCurrentprojects(Database database) async{

    final List<Map<String,dynamic>> maps = await database.query("current_projects");

    List<CurrentProject> currentProjectList = [];

    maps.forEach((element) {
      var cp = CurrentProject(
          id: element["id"].toString(),
          projectName: element["projectName"],
          projectId: element["projectId"]
      );
      currentProjectList.add(cp);
    });

    return currentProjectList;

    /*
    return List.generate(maps.length, (index){
      return CurrentProject(
        id: maps[index]["id"],
        projectName: maps[index]["projectName"]
      );
    });
    */

  }

}