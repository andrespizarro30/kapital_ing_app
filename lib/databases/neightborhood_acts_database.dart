
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:kapital_ing_app/models/neighborhood_act_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class NeighborhoodActDatabase{

  Future<Database> CreateTable() async{

    var appDirectory = await getDownloadsDirectory();

    String appImagesPath = appDirectory!.path;

    Directory folderDir = Directory("${appImagesPath}/databases");

    if(await folderDir.exists() == false){
      await folderDir.create(recursive: true);
    }

    var database = openDatabase(

      join(folderDir.path, 'neighborhood_act_database.db'),
      onCreate: (db, version){
        return db.execute(
          "CREATE TABLE neighborhood_acts("
              "ID INTEGER PRIMARY KEY,"
              "project TEXT,"
              "type_pro TEXT,"
              "no_prop INTEGER,"
              "area INTEGER,"
              "owner_name TEXT,"
              "owner_id TEXT,"
              "owner_phone TEXT,"
              "state_property_description TEXT,"
              "photo_1 TEXT,"
              "photo_1_description TEXT,"
              "photo_2 TEXT,"
              "photo_2_description TEXT,"
              "photo_3 TEXT,"
              "photo_3_description TEXT,"
              "photo_4 TEXT,"
              "photo_4_description TEXT,"
              "photo_5 TEXT,"
              "photo_5_description TEXT,"
              "photo_6 TEXT,"
              "photo_6_description TEXT,"
              "person_observations TEXT,"
              "owner_sign TEXT,"
              "pao_sign TEXT)"
        );
      },
      version: 1
    );

    return database;

  }

  Future<void> saveNewAct(NeighborhoodActModel neighborhoodAct,Database database)async{

    final Database db = database;

    await db.insert('neighborhood_acts', neighborhoodAct.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);

  }


}

