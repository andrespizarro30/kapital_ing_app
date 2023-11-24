import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';

import '../common_functions/common_functions.dart';
import '../data_handler/app_data.dart';
import '../main.dart';


class SignatureDailyWorkScreen extends StatelessWidget {

  String? selectedDate;

  SignatureDailyWorkScreen({this.selectedDate});


  final SignatureController signatureController = SignatureController(
      penColor: Colors.red,
      exportPenColor: Colors.black,
      exportBackgroundColor: Colors.white,
      penStrokeWidth: 6
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (userType == "Kapital" ? Text("Firma Kapital") : Text("Firma Interventoría")),
        backgroundColor: Colors.yellow,
        elevation: 10.0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2)
                  ),
                  child: Signature(
                    controller: signatureController,
                  ),
                )
            ),
            SizedBox(height: 24,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: (){
                    signatureController.clear();
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text("Borrar"),
                ),
                MaterialButton(
                  onPressed: () async{
                    var pngBytes = await signatureController.toPngBytes();

                    var appDirectory = await getDownloadsDirectory();

                    String appImagesPath = appDirectory!.path;

                    String signName = "Firma_${userType}_${userCode!}_${selectedDate}.jpg";

                    Directory folderDir = Directory("${appImagesPath}/DailyWork/signatures/${selectedDate}/${userCode!}");

                    if(await folderDir.exists() == false){
                      await folderDir.create(recursive: true);
                    }

                    File currentSign = await File("${folderDir.path}/${signName}").writeAsBytes(pngBytes!);

                    uploadSignToServer(signName,currentSign,context);

                    if(userType=="Kapital"){
                      Provider.of<AppData>(context, listen: false).saveKapitalSignature(pngBytes!);
                    }

                    Navigator.pop(context,"${folderDir.path}/${signName}");
                  },
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text("Guardar"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<bool> uploadSignToServer(String newFilename, File newImageFile,context) async{

    final Reference refStorage = dailyWorkPhotosRef.child("Firmas").child(selectedDate!).child(userCode!).child(newFilename);

    final UploadTask uploadTask = refStorage.putFile(newImageFile);

    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => true);

    if(taskSnapshot.state == TaskState.success){
      final String url = await taskSnapshot.ref.getDownloadURL();

      dailyWorkRef
          .child(currentProjectId)
          .child(selectedDate!)
          .child(userCode!)
          .child("Sign_${userType}")
          .set(url);

      displayToastMessages("Imagen cargada correctamente", context);

      return true;
    }else{
      return false;
    }

  }

}

