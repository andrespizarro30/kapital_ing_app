
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kapital_ing_app/common_functions/PdfCreator.dart';
import 'package:kapital_ing_app/common_functions/common_functions.dart';
import 'package:kapital_ing_app/screen/siganture_screen.dart';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common/sqlite_api.dart';

import '../common_functions/progressDialog.dart';
import '../data_handler/app_data.dart';
import '../databases/neightborhood_acts_database.dart';
import '../models/neighborhood_act_model.dart';

class NeighborhoodAct extends StatefulWidget {
  const NeighborhoodAct({super.key});

  @override
  State<NeighborhoodAct> createState() => _NeighborhoodActState();
}

class _NeighborhoodActState extends State<NeighborhoodAct> {

  TextEditingController projectTEC = TextEditingController();
  TextEditingController noPropTEC = TextEditingController();
  TextEditingController areaTEC = TextEditingController();
  TextEditingController ownerNameTEC = TextEditingController();
  TextEditingController ownerIdTEC = TextEditingController();
  TextEditingController ownerPhoneTEC = TextEditingController();
  TextEditingController statePropDescTEC = TextEditingController();
  TextEditingController photo1TEC = TextEditingController();
  TextEditingController photo1DescTEC = TextEditingController();
  TextEditingController photo2TEC = TextEditingController();
  TextEditingController photo2DescTEC = TextEditingController();
  TextEditingController photo3TEC = TextEditingController();
  TextEditingController photo3DescTEC = TextEditingController();
  TextEditingController photo4TEC = TextEditingController();
  TextEditingController photo4DescTEC = TextEditingController();
  TextEditingController photo5TEC = TextEditingController();
  TextEditingController photo5DescTEC = TextEditingController();
  TextEditingController photo6TEC = TextEditingController();
  TextEditingController photo6DescTEC = TextEditingController();
  TextEditingController personObservTEC = TextEditingController();
  TextEditingController ownerSignTEC = TextEditingController();
  TextEditingController paoSignTEC = TextEditingController();

  NeighborhoodActModel? neighborhoodActModel = null;

  String? dropdownValue = 'Parqueadero';
  List<String> spinnerItems = ['Parqueadero','Casa', 'Local Comercial', 'Duplex'];

  File? takenImage1 = null;
  File? takenImage2 = null;
  File? takenImage3 = null;
  File? takenImage4 = null;
  File? takenImage5 = null;
  File? takenImage6 = null;

  Uint8List? imageBytes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    projectTEC.text = currentProjectG!;
    neighborhoodActModel = NeighborhoodActModel();
    neighborhoodActModel!.project = projectTEC.text;
    neighborhoodActModel!.type_pro = dropdownValue;
    neighborhoodActModel!.pao_sign = "firma_pao_bedoya.png";
  }

  int touchedTimes = 0;

  Future<bool> _onWillPop() async {
    if(touchedTimes==2){
      return true;
    }else{
      touchedTimes = touchedTimes + 1;
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {

    imageBytes = Provider.of<AppData>(context).imageBytes != null
        ? Provider.of<AppData>(context).imageBytes!
        : null;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Actas de Vecindad"),
          backgroundColor: Colors.yellow,
          actions: [
            IconButton(
              icon: const Icon(Icons.recycling),
              tooltip: 'Acta Nueva',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (builder){
                    return AlertDialog(
                      title: const Text("Nuevo Registro"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Divider(
                            height: 1.0,
                            thickness: 3.0,
                            color: Colors.grey,
                          ),
                          Text("¿Desea eliminar los datos actuales?"),
                          Divider(
                            height: 1.0,
                            thickness: 3.0,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                            onPressed: (){
                              cleanForm();
                              Navigator.pop(context);
                            },
                            child: const Text("Si")
                        ),
                        TextButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: const Text("No")
                        )
                      ],
                    );
                  });
              },
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.0,vertical: 1.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: projectTEC,
                  keyboardType: TextInputType.name,
                  enabled: false,
                  decoration: InputDecoration(
                      labelText: "Copropiedad",
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
                    neighborhoodActModel!.project = projectTEC.text;
                  }
                ),
                SizedBox(height: 1.0,),
                Column(children: <Widget>[
                  Text(
                    "Tipo de Propiedad",
                    style: TextStyle(fontSize: 14.0,color: Colors.black),
                  ),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_drop_down),
                    items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        dropdownValue = value;
                      });
                      neighborhoodActModel!.type_pro = dropdownValue;
                    },
                    isExpanded: true,
                  )
                ]),
                SizedBox(height: 1.0,),
                TextField(
                    controller: noPropTEC,
                    keyboardType: TextInputType.number,
                    enabled: true,
                    decoration: InputDecoration(
                        labelText: "No. Propiedad",
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
                      neighborhoodActModel!.ID = int.parse(noPropTEC.text);
                      neighborhoodActModel!.no_prop = int.parse(noPropTEC.text);
                    }
                ),
                SizedBox(height: 1.0,),
                TextField(
                    controller: areaTEC,
                    keyboardType: TextInputType.number,
                    enabled: true,
                    decoration: InputDecoration(
                        labelText: "Area",
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
                      neighborhoodActModel!.area = int.parse(areaTEC.text);
                    }
                ),
                SizedBox(height: 1.0,),
                TextField(
                    controller: ownerNameTEC,
                    keyboardType: TextInputType.name,
                    enabled: true,
                    decoration: InputDecoration(
                        labelText: "Nombre Propietario",
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
                      neighborhoodActModel!.owner_name = ownerNameTEC.text;
                    }
                ),
                SizedBox(height: 1.0,),
                TextField(
                    controller: ownerIdTEC,
                    keyboardType: TextInputType.name,
                    enabled: true,
                    decoration: InputDecoration(
                        labelText: "No. Cédula",
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
                      neighborhoodActModel!.owner_id = ownerIdTEC.text;
                    }
                ),
                SizedBox(height: 1.0,),
                TextField(
                    controller: ownerPhoneTEC,
                    keyboardType: TextInputType.number,
                    enabled: true,
                    decoration: InputDecoration(
                        labelText: "No. Teléfono",
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
                      neighborhoodActModel!.owner_phone = ownerPhoneTEC.text;
                    }
                ),
                SizedBox(height: 1.0,),
                TextField(
                    controller: statePropDescTEC,
                    keyboardType: TextInputType.multiline,
                    enabled: true,
                    maxLines: null,
                    decoration: InputDecoration(
                        labelText: "Estado General Propiedad",
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
                      neighborhoodActModel!.state_property_description = statePropDescTEC.text;
                    }
                ),
                SizedBox(height: 1.0,),

                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                        onPressed: () {
                          takenImage1 = null;
                          pickImageFromCamera(1);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreen
                        ),
                        icon: Icon(
                          Icons.camera,
                          color: Colors.orange,
                          size: 25,
                        ),
                        label: Text(
                          "Foto 1",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold
                          ),
                        )
                    ),
                    SizedBox(width: 1.0,),
                    ElevatedButton.icon(
                        onPressed: () {
                          takenImage2 = null;
                          pickImageFromCamera(2);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreen
                        ),
                        icon: Icon(
                          Icons.camera,
                          color: Colors.red,
                          size: 25,
                        ),
                        label: Text(
                          "Foto 2",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold
                          ),
                        )
                    ),

                  ],
                ),

                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 200,
                      child: takenImage1 != null ?
                      Image.file(takenImage1!,
                        fit: BoxFit.fill,
                      ) :
                      const Text("Tome la imagen 1"),
                    ),
                    Container(
                        height: 200,
                        child: takenImage2 != null ?
                        Image.file(takenImage2!,
                          fit: BoxFit.fill,
                        ) :
                        const Text("Tome la imagen 2"),
                    )
                  ],
                ),

                SizedBox(height: 1.0,),
                TextField(
                    controller: photo1DescTEC,
                    keyboardType: TextInputType.multiline,
                    enabled: true,
                    maxLines: null,
                    decoration: InputDecoration(
                        labelText: "Descripción Imagen 1",
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
                      neighborhoodActModel!.photo_1_description = photo1DescTEC.text;
                    }
                ),

                SizedBox(height: 1.0,),

                TextField(
                    controller: photo2DescTEC,
                    keyboardType: TextInputType.multiline,
                    enabled: true,
                    maxLines: null,
                    decoration: InputDecoration(
                        labelText: "Descripción Imagen 2",
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
                      neighborhoodActModel!.photo_2_description = photo2DescTEC.text;
                    }
                ),

                SizedBox(height: 1.0,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ElevatedButton.icon(
                        onPressed: () {
                          takenImage3 = null;
                          pickImageFromCamera(3);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreen
                        ),
                        icon: Icon(
                          Icons.camera,
                          color: Colors.blue,
                          size: 25,
                        ),
                        label: Text(
                          "Foto 3",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold
                          ),
                        )
                    ),
                    ElevatedButton.icon(
                        onPressed: () {
                          takenImage4 = null;
                          pickImageFromCamera(4);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreen
                        ),
                        icon: Icon(
                          Icons.camera,
                          color: Colors.cyan,
                          size: 25,
                        ),
                        label: Text(
                          "Foto 4",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold
                          ),
                        )
                    ),
                  ],
                ),

                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 200,
                      child: takenImage3 != null ?
                      Image.file(takenImage3!,
                        fit: BoxFit.fill,
                      ) :
                      const Text("Tome la imagen 3"),
                    ),
                    Container(
                      height: 200,
                      child: takenImage4 != null ?
                      Image.file(takenImage4!,
                        fit: BoxFit.fill
                      ) :
                      const Text("Tome la imagen 4 (opcional)"),
                    )
                  ],
                ),

                SizedBox(height: 1.0,),

                TextField(
                    controller: photo3DescTEC,
                    keyboardType: TextInputType.multiline,
                    enabled: true,
                    maxLines: null,
                    decoration: InputDecoration(
                        labelText: "Descripción Imagen 3",
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
                      neighborhoodActModel!.photo_3_description = photo3DescTEC.text;
                    }
                ),
                SizedBox(height: 1.0,),

                TextField(
                    controller: photo4DescTEC,
                    keyboardType: TextInputType.multiline,
                    enabled: true,
                    maxLines: null,
                    decoration: InputDecoration(
                        labelText: "Descripción Imagen 4",
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
                      neighborhoodActModel!.photo_4_description = photo4DescTEC.text;
                    }
                ),
                SizedBox(height: 1.0,),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                        onPressed: () {
                          takenImage5 = null;
                          pickImageFromCamera(5);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreen
                        ),
                        icon: Icon(
                          Icons.camera,
                          color: Colors.cyan,
                          size: 25,
                        ),
                        label: Text(
                          "Foto 5",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold
                          ),
                        )
                    ),
                    ElevatedButton.icon(
                        onPressed: () {
                          takenImage6 = null;
                          pickImageFromCamera(6);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreen
                        ),
                        icon: Icon(
                          Icons.camera,
                          color: Colors.cyan,
                          size: 25,
                        ),
                        label: Text(
                          "Foto 6",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold
                          ),
                        )
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: 200,
                      child: takenImage5 != null ?
                      Image.file(takenImage5!,
                        fit: BoxFit.fill,
                      ) :
                      const Text("Tome la imagen 5 (opc.)"),
                    ),
                    Container(
                      height: 200,
                      child: takenImage6 != null ?
                      Image.file(takenImage6!,
                        fit: BoxFit.fill
                      ) :
                      const Text("Tome la imagen 6 (opc.)"),
                    )
                  ],
                ),

                SizedBox(height: 1.0,),

                TextField(
                    controller: photo5DescTEC,
                    keyboardType: TextInputType.multiline,
                    enabled: true,
                    maxLines: null,
                    decoration: InputDecoration(
                        labelText: "Descripción Imagen 5",
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
                      neighborhoodActModel!.photo_5_description = photo5DescTEC.text;
                    }
                ),
                SizedBox(height: 1.0,),

                TextField(
                    controller: photo6DescTEC,
                    keyboardType: TextInputType.multiline,
                    enabled: true,
                    maxLines: null,
                    decoration: InputDecoration(
                        labelText: "Descripción Imagen 6",
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
                      neighborhoodActModel!.photo_6_description = photo6DescTEC.text;
                    }
                ),
                SizedBox(height: 1.0,),

                TextField(
                    controller: personObservTEC,
                    keyboardType: TextInputType.multiline,
                    enabled: true,
                    maxLines: null,
                    decoration: InputDecoration(
                        labelText: "Observaciones Propietario / Arrendatario",
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
                      neighborhoodActModel!.person_observations = personObservTEC.text;
                    }
                ),
                SizedBox(height: 1.0,),
                ElevatedButton.icon(
                    onPressed: () async{
                      var ownerSignPath = await Navigator.push(context, MaterialPageRoute(builder: (c)=>SignatureScreen(
                          neighborhoodActModel: neighborhoodActModel,
                      )));

                      neighborhoodActModel!.owner_sign = ownerSignPath;
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.lightGreen
                    ),
                    icon: Icon(
                      Icons.draw_rounded,
                      color: Colors.blue,
                      size: 25,
                    ),
                    label: Text(
                      "Firmar",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold
                      ),
                    )
                ),
                SizedBox(height: 1.0,),
                (imageBytes != null ? Image.memory(imageBytes!) : Text("Solicitar Firma")),
                ElevatedButton.icon(
                    onPressed: () async {

                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext c) => ProgressDialog(
                              message: "Generando Acta..."
                          )
                      );

                      for(int i = 0; i < neighborhoodActModel!.toMap().length; i++){
                        if(neighborhoodActModel!.toMap().values.elementAt(i) == null){
                          String key = neighborhoodActModel!.toMap().keys.elementAt(i);
                          if(key != "photo_4" && key != "photo_5" && key != "photo_6" &&
                              key != "photo_4_description" && key != "photo_5_description" && key != "photo_6_description"){
                            displayToastMessages("Campo ${key} Vacio, verifique por favor!!!", context);

                            Navigator.pop(context);

                            break;
                          }
                        }

                        if(i == neighborhoodActModel!.toMap().length - 1){
                          NeighborhoodActDatabase nadb = NeighborhoodActDatabase();

                          Database database = await nadb.CreateTable();

                          nadb.saveNewAct(neighborhoodActModel!, database);

                          CreatePDFDocument pdfDoc = CreatePDFDocument(neighborhoodActModel: neighborhoodActModel!);
                          await pdfDoc.createPDFDoc();
                          pdfDoc.saveAndLaunchFile();

                          displayToastMessages("Acta Generada",context);

                          Navigator.pop(context);

                        }

                      }

                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.yellow
                    ),
                    icon: Icon(
                      Icons.save,
                      color: Colors.green,
                      size: 25,
                    ),
                    label: Text(
                      "Generar Acta",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold
                      ),
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future pickImageFromCamera(int imageNumber) async{

    final returnedImage = await ImagePicker().pickImage(source: ImageSource.camera);

    if(returnedImage == null) return;

    String dir = path.dirname(returnedImage.path);
    String newFilename = "${projectTEC.text}-${noPropTEC.text}-${imageNumber.toString()}.jpg";
    String newPathName = path.join(dir,"${newFilename}.jpg");
    File imageFile = File(returnedImage.path).renameSync(newPathName);

    var appDirectory = await getDownloadsDirectory();

    Directory folderDir = Directory("${appDirectory!.path}/Fotos");

    if(await folderDir.exists() == false){
      await folderDir.create(recursive: true);
    }

    File newImageFile = await imageFile.copy("${folderDir.path}/${newFilename}");

    setState(() {
      if(imageNumber==1){
        neighborhoodActModel!.photo_1 = newImageFile.path;
        takenImage1 = newImageFile;
      }else
      if(imageNumber==2){
        neighborhoodActModel!.photo_2 = newImageFile.path;
        takenImage2 = newImageFile;
      }else
      if(imageNumber==3){
        neighborhoodActModel!.photo_3 = newImageFile.path;
        takenImage3 = newImageFile;
      }else
      if(imageNumber==4){
        neighborhoodActModel!.photo_4 = newImageFile.path;
        takenImage4 = newImageFile;
      }else
      if(imageNumber==5){
        neighborhoodActModel!.photo_5 = newImageFile.path;
        takenImage5 = newImageFile;
      }else
      if(imageNumber==6){
        neighborhoodActModel!.photo_6 = newImageFile.path;
        takenImage6 = newImageFile;
      }
    });

  }

  void cleanForm() {

    setState(() {
      projectTEC = TextEditingController();
      noPropTEC = TextEditingController();
      areaTEC = TextEditingController();
      ownerNameTEC = TextEditingController();
      ownerIdTEC = TextEditingController();
      ownerPhoneTEC = TextEditingController();
      statePropDescTEC = TextEditingController();
      photo1TEC = TextEditingController();
      photo1DescTEC = TextEditingController();
      photo2TEC = TextEditingController();
      photo2DescTEC = TextEditingController();
      photo3TEC = TextEditingController();
      photo3DescTEC = TextEditingController();
      photo4TEC = TextEditingController();
      photo4DescTEC = TextEditingController();
      photo5TEC = TextEditingController();
      photo5DescTEC = TextEditingController();
      photo6TEC = TextEditingController();
      photo6DescTEC = TextEditingController();
      personObservTEC = TextEditingController();
      ownerSignTEC = TextEditingController();
      paoSignTEC = TextEditingController();

      projectTEC.text = currentProjectG!;
      neighborhoodActModel = NeighborhoodActModel();
      neighborhoodActModel!.project = projectTEC.text;
      neighborhoodActModel!.type_pro = dropdownValue;
      neighborhoodActModel!.pao_sign = "firma_pao_bedoya.png";

      takenImage1 = null;
      takenImage2 = null;
      takenImage3 = null;
      takenImage4 = null;
      takenImage5 = null;
      takenImage6 = null;

      Provider.of<AppData>(context, listen: false).cleanSignature();
    });

  }

}
