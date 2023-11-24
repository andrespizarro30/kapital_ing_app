import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kapital_ing_app/permissions/permissions.dart';
import 'package:kapital_ing_app/routes/routes.dart';
import 'package:provider/provider.dart';

import 'data_handler/app_data.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MyApp(
      child: ChangeNotifierProvider(
        create: (context) => AppData(),
        child: MaterialApp(
          title: 'Kapital ING App',
          theme: ThemeData(
            primarySwatch: Colors.yellow,
            //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: 'splash',
          routes: getRoutes(),
          debugShowCheckedModeBanner: false,
        ),
      )
  ));
}

DatabaseReference currentProjectsRef = FirebaseDatabase.instance.ref().child("CURRENT_PROJECTS");
DatabaseReference vitacorasRef = FirebaseDatabase.instance.ref().child("Vitacora_Obra");
DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users");
Reference vitacoraPhotosRef = FirebaseStorage.instance.ref().child("Vitacora_Obra");

DatabaseReference dailyWorkRef = FirebaseDatabase.instance.ref().child("DailyWork");
Reference dailyWorkPhotosRef = FirebaseStorage.instance.ref().child("DailyWork");

class MyApp extends StatefulWidget {

  final Widget? child;

  MyApp({this.child});

  static void restartApp(BuildContext context){
    context.findAncestorStateOfType<_MyAppState>()!.restartApp();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Key key = UniqueKey();

  void restartApp(){
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {

    requestPermissions();

    return KeyedSubtree(
        key: key,
        child: widget.child!
    );
  }

  void requestPermissions(){
    requestPositionPermission();
    requestStoragePermission2();
  }

}