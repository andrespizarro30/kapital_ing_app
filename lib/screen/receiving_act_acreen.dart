
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kapital_ing_app/common_functions/PdfCreator.dart';
import 'package:kapital_ing_app/common_functions/common_functions.dart';
import 'package:kapital_ing_app/models/house_number_list_model.dart';
import 'package:kapital_ing_app/screen/siganture_screen.dart';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common/sqlite_api.dart';

import '../common_functions/PdfCreatorActReceive.dart';
import '../common_functions/progressDialog.dart';
import '../data_handler/app_data.dart';
import '../databases/neightborhood_acts_database.dart';
import '../models/neighborhood_act_model.dart';
import '../widgets/request_camera_gallery.dart';

class ReceivingAct extends StatefulWidget {
  const ReceivingAct({super.key});

  @override
  State<ReceivingAct> createState() => _ReceivingActState();
}

class _ReceivingActState extends State<ReceivingAct> {

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

  String? dropdownValue = 'Casa';
  List<String> spinnerItems = ['Parqueadero','Casa', 'Local Comercial', 'Duplex'];

  File? takenImage1 = null;
  File? takenImage2 = null;
  File? takenImage3 = null;
  File? takenImage4 = null;
  File? takenImage5 = null;
  File? takenImage6 = null;

  Uint8List? imageBytes;

  String? propNumberSelected = "";

  List<HouseNumberList> houseNumberList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    projectTEC.text = currentProjectG!;
    neighborhoodActModel = NeighborhoodActModel();
    neighborhoodActModel!.project = projectTEC.text;
    neighborhoodActModel!.type_pro = dropdownValue;
    neighborhoodActModel!.pao_sign = "firma_pao_bedoya.png";

    getHousesList();

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
          title: Text("Actas de Recibo"),
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
            ),
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Buscar Acta',
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (builder){
                      return AlertDialog(
                        title: const Text("Seleccionar propiedad Propiedad"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("No."),
                            SizedBox(height: 1.0,),
                            DropdownButton<String>(
                                value: propNumberSelected,
                                icon: Icon(Icons.arrow_drop_down),
                                items: houseNumberList.map<DropdownMenuItem<String>>((housesList) {
                                  return DropdownMenuItem<String>(
                                    value: housesList!.houseNumber!,
                                    child: Text(housesList!.houseNumber!),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    propNumberSelected = value;
                                    cleanForm();
                                    Navigator.pop(context);
                                    retrieveInformation(propNumberSelected!);
                                  });
                                },
                                isExpanded: true,
                            ),
                            SizedBox(height: 1.0,),
                          ],
                        ),
                        actions: [
                          TextButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: const Text("SALIR")
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
                      partialSaving();
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
                      partialSaving();
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
                      partialSaving();
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
                      partialSaving();
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
                      partialSaving();
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
                      partialSaving();
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
                      partialSaving();
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
                      partialSaving();
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
                      partialSaving();
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
                      partialSaving();
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
                      partialSaving();
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
                      partialSaving();
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
                      partialSaving();
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
                      partialSaving();
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
                      partialSaving();
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

                          CreatePDFActReceive pdfDoc = CreatePDFActReceive(neighborhoodActModel: neighborhoodActModel!);
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

    var response = await showDialog(
        context: context,
        builder: (BuildContext c) => RequestCameraOrGallery(

        ));

    XFile? returnedImage;

    if(response == "Camara"){
      returnedImage = await ImagePicker().pickImage(source: ImageSource.camera,imageQuality: 30);
    }else
    if(response == "Galeria"){
      returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 30);
    }

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

  void retrieveInformation(String propNumber) async {

    NeighborhoodActDatabase nadb = NeighborhoodActDatabase();
    Database database = await nadb.CreateTable();

    List<Map<String,dynamic>> maps = await nadb.getHouseNumberData(database, propNumber);

    setState(() {

      maps.forEach((element) {

        projectTEC.text = element["project"].toString();
        neighborhoodActModel!.project = element["project"].toString();

        noPropTEC.text = element["no_prop"].toString();
        neighborhoodActModel!.ID = element["no_prop"];
        neighborhoodActModel!.no_prop = element["no_prop"];

        areaTEC.text = element["area"].toString();
        neighborhoodActModel!.area = element["area"];

        ownerNameTEC.text = element["owner_name"].toString();
        neighborhoodActModel!.owner_name = element["owner_name"];

        ownerIdTEC.text = element["owner_id"].toString();
        neighborhoodActModel!.owner_id = element["owner_id"];

        ownerPhoneTEC.text = element["owner_phone"].toString();
        neighborhoodActModel!.owner_phone = element["owner_phone"];

        statePropDescTEC.text = element["state_property_description"].toString();
        neighborhoodActModel!.state_property_description = element["state_property_description"];

        photo1TEC.text = element["photo_1"].toString();
        neighborhoodActModel!.photo_1 = element["photo_1"];
        if(element["photo_1"] != null && element["photo_1"] != ""){
          takenImage1 = File(element["photo_1"].toString());
        }
        photo1DescTEC.text = element["photo_1_description"].toString();
        neighborhoodActModel!.photo_1_description = element["photo_1_description"];

        photo2TEC.text = element["photo_2"].toString();
        neighborhoodActModel!.photo_2 = element["photo_2"];
        if(element["photo_2"] != null && element["photo_2"] != ""){
          takenImage2 = File(element["photo_2"].toString());
        }
        photo2DescTEC.text = element["photo_2_description"].toString();
        neighborhoodActModel!.photo_2_description = element["photo_2_description"];

        photo3TEC.text = element["photo_3"].toString();
        neighborhoodActModel!.photo_3 = element["photo_3"];
        if(element["photo_3"] != null && element["photo_3"] != ""){
          takenImage3 = File(element["photo_3"].toString());
        }
        photo3DescTEC.text = element["photo_3_description"].toString();
        neighborhoodActModel!.photo_3_description = element["photo_3_description"];

        photo4TEC.text = element["photo_4"].toString();
        neighborhoodActModel!.photo_4 = element["photo_4"];
        if(element["photo_4"] != null && element["photo_4"] != ""){
          takenImage4 = File(element["photo_4"].toString());
        }
        photo4DescTEC.text = element["photo_4_description"].toString();
        neighborhoodActModel!.photo_4_description = element["photo_4_description"];

        photo5TEC.text = element["photo_5"].toString();
        neighborhoodActModel!.photo_5 = element["photo_5"];
        if(element["photo_5"] != null && element["photo_5"] != ""){
          takenImage5 = File(element["photo_5"].toString());
        }
        photo5DescTEC.text = element["photo_5_description"].toString();
        neighborhoodActModel!.photo_5_description = element["photo_5_description"];

        photo6TEC.text = element["photo_6"].toString();
        neighborhoodActModel!.photo_6 = element["photo_6"];
        if(element["photo_6"] != null && element["photo_6"] != ""){
          takenImage6 = File(element["photo_6"].toString());
        }
        photo6DescTEC.text = element["photo_6_description"].toString();
        neighborhoodActModel!.photo_6_description = element["photo_6_description"];

        personObservTEC.text = element["person_observations"].toString();
        neighborhoodActModel!.person_observations = element["person_observations"];

        ownerSignTEC.text = element["owner_sign"].toString();
        neighborhoodActModel!.owner_sign = element["owner_sign"];

        if(element["owner_sign"] != null && element["owner_sign"] != ""){
          File fileSign = File(element["owner_sign"].toString());
          Uint8List imageBytes = fileSign.readAsBytesSync();
          Provider.of<AppData>(context, listen: false).saveSignature(imageBytes!);
        }

        paoSignTEC.text = element["pao_sign"].toString();
        neighborhoodActModel!.pao_sign = element["pao_sign"];

      });

    });

  }

  void getHousesList() async {

    NeighborhoodActDatabase nadb = NeighborhoodActDatabase();
    Database database = await nadb.CreateTable();

    List<HouseNumberList> houseNumberList = await nadb.getHouseNumbersList(database);

    setState(() {
      this.houseNumberList = houseNumberList;
    });

  }

  void partialSaving() async{
    NeighborhoodActDatabase nadb = NeighborhoodActDatabase();
    Database database = await nadb.CreateTable();
    nadb.saveNewAct(neighborhoodActModel!, database);
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