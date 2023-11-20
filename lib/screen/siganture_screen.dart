import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';

import '../data_handler/app_data.dart';
import '../models/neighborhood_act_model.dart';

class SignatureScreen extends StatelessWidget {

  NeighborhoodActModel? neighborhoodActModel;

  SignatureScreen({this.neighborhoodActModel});

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
        title: Text("Firma Propietario / Arrendatario"),
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

                    String signName = "${neighborhoodActModel!.owner_name}-${neighborhoodActModel!.project}-${neighborhoodActModel!.no_prop}.jpg";

                    Directory folderDir = Directory("${appImagesPath}/signatures");

                    if(await folderDir.exists() == false){
                      await folderDir.create(recursive: true);
                    }

                    await File("${folderDir.path}/${signName}").writeAsBytes(pngBytes!);

                    Provider.of<AppData>(context, listen: false).saveSignature(pngBytes!);
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
}
