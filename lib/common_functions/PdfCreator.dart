
import 'dart:io';
import 'dart:ui';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../models/neighborhood_act_model.dart';

import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

class CreatePDFDocument{

  NeighborhoodActModel neighborhoodActModel;

  CreatePDFDocument({required this.neighborhoodActModel});

  List<int>? bytes = null;

  Future<void> createPDFDoc() async {

    PdfDocument document = PdfDocument();
    final page = document.pages.add();

    PdfStandardFont titleFont = PdfStandardFont(PdfFontFamily.helvetica,30);
    PdfStandardFont titleFont2 = PdfStandardFont(PdfFontFamily.helvetica,20);

    PdfStringFormat format = PdfStringFormat();
    format.alignment = PdfTextAlignment.center;

    page.graphics.drawString("ACTAS DE VECINDAD", titleFont,bounds: Rect.fromLTWH(250, 10, 0, 0),format: format);
    page.graphics.drawString(neighborhoodActModel!.project!, titleFont2,bounds: Rect.fromLTWH(250, 40, 0, 0),format: format);

    PdfStandardFont subFont = PdfStandardFont(PdfFontFamily.helvetica,15,style: PdfFontStyle.bold);
    PdfStandardFont subFont2 = PdfStandardFont(PdfFontFamily.helvetica,15,style: PdfFontStyle.underline);

    page.graphics.drawString("Casa No.", subFont,bounds: Rect.fromLTWH(10, 80, 0, 0));
    page.graphics.drawString("Local Comercial No.", subFont,bounds: Rect.fromLTWH(130, 80, 0, 0));
    page.graphics.drawString("Parqueadero No.", subFont,bounds: Rect.fromLTWH(320, 80, 0, 0));

    if(neighborhoodActModel.type_pro == "Casa"){
      page.graphics.drawString("${neighborhoodActModel.no_prop.toString()}", subFont2,bounds: Rect.fromLTWH(90, 80, 0, 0));
      page.graphics.drawString("NA", subFont2,bounds: Rect.fromLTWH(280, 80, 0, 0));
      page.graphics.drawString("NA", subFont2,bounds: Rect.fromLTWH(440, 80, 0, 0));
    }else
    if(neighborhoodActModel.type_pro == "Local Comercial"){
      page.graphics.drawString("NA", subFont2,bounds: Rect.fromLTWH(90, 80, 0, 0));
      page.graphics.drawString("${neighborhoodActModel.no_prop.toString()}", subFont2,bounds: Rect.fromLTWH(280, 80, 0, 0));
      page.graphics.drawString("NA", subFont2,bounds: Rect.fromLTWH(440, 80, 0, 0));
    }else
    if(neighborhoodActModel.type_pro == "Parqueadero"){
      page.graphics.drawString("NA", subFont2,bounds: Rect.fromLTWH(90, 80, 0, 0));
      page.graphics.drawString("NA", subFont2,bounds: Rect.fromLTWH(280, 80, 0, 0));
      page.graphics.drawString("${neighborhoodActModel.no_prop.toString()}", subFont2,bounds: Rect.fromLTWH(450, 80, 0, 0));
    }

    page.graphics.drawString("Nombre Propietario:", subFont,bounds: Rect.fromLTWH(10, 110, 0, 0));
    page.graphics.drawString("${neighborhoodActModel.owner_name}", subFont2,bounds: Rect.fromLTWH(180, 110, 0, 0));

    page.graphics.drawString("Cédula:", subFont,bounds: Rect.fromLTWH(10, 140, 0, 0));
    page.graphics.drawString("No. Teléfono:", subFont,bounds: Rect.fromLTWH(150, 140, 0, 0));
    page.graphics.drawString("Área Común:", subFont,bounds: Rect.fromLTWH(350, 140, 0, 0));

    page.graphics.drawString("${neighborhoodActModel.owner_id}", subFont2,bounds: Rect.fromLTWH(70, 140, 0, 0));
    page.graphics.drawString("${neighborhoodActModel.owner_phone}", subFont2,bounds: Rect.fromLTWH(250, 140, 0, 0));
    page.graphics.drawString("${neighborhoodActModel.area.toString()}", subFont2,bounds: Rect.fromLTWH(450, 140, 0, 0));

    PdfStandardFont middleTitleFont = PdfStandardFont(PdfFontFamily.helvetica,20);
    page.graphics.drawString("ESTADO DEL INMUEBLE", middleTitleFont,bounds: Rect.fromLTWH(250, 170, 0, 0),format: format);

    page.graphics.drawImage(PdfBitmap(
        await readImageData(neighborhoodActModel.photo_1!)), Rect.fromLTWH(10, 200, 150, 150));

    page.graphics.drawImage(PdfBitmap(
        await readImageData(neighborhoodActModel.photo_2!)), Rect.fromLTWH(180, 200, 150, 150));

    page.graphics.drawImage(PdfBitmap(
        await readImageData(neighborhoodActModel.photo_3!)), Rect.fromLTWH(350, 200, 150, 150));

    PdfGrid grid = PdfGrid();

    grid.style = PdfGridStyle(font: PdfStandardFont(PdfFontFamily.helvetica,10),cellPadding: PdfPaddings(left: 5,right: 2,top: 2,bottom: 2));

    grid.columns.add(count: 3);
    grid.headers.add(1);

    PdfGridRow header1 = grid.headers[0];
    header1.cells[0].value = "Imagen 1";
    header1.cells[1].value = "Imagen 2";
    header1.cells[2].value = "Imagen 3";

    PdfGridRow row1 = grid.rows.add();
    row1.cells[0].value = neighborhoodActModel.photo_1_description;
    row1.cells[1].value = neighborhoodActModel.photo_2_description;
    row1.cells[2].value = neighborhoodActModel.photo_3_description;

    grid.draw(page: page,bounds: Rect.fromLTWH(0,350,0,0));

    ///

    if(neighborhoodActModel.photo_4 != null || neighborhoodActModel.photo_5 != null || neighborhoodActModel.photo_6 != null){
      final page2 = document.pages.add();

      neighborhoodActModel.photo_4 != null ?
      page2.graphics.drawImage(PdfBitmap(
          await readImageData(neighborhoodActModel.photo_4!)), Rect.fromLTWH(10, 10, 150, 150)) :
      page2.graphics.drawImage(PdfBitmap(
          await readImageData2("sin_foto.png")), Rect.fromLTWH(10, 10, 150, 150));

      neighborhoodActModel.photo_5 != null ?
      page2.graphics.drawImage(PdfBitmap(
          await readImageData(neighborhoodActModel.photo_5!)), Rect.fromLTWH(180, 10, 150, 150)) :
      page2.graphics.drawImage(PdfBitmap(
          await readImageData2("sin_foto.png")), Rect.fromLTWH(180, 10, 150, 150));

      neighborhoodActModel.photo_6 != null ?
      page2.graphics.drawImage(PdfBitmap(
          await readImageData(neighborhoodActModel.photo_6!)), Rect.fromLTWH(350, 10, 150, 150)) :
      page2.graphics.drawImage(PdfBitmap(
          await readImageData2("sin_foto.png")), Rect.fromLTWH(350, 10, 150, 150));


      PdfGrid grid3 = PdfGrid();

      grid3.style = PdfGridStyle(font: PdfStandardFont(PdfFontFamily.helvetica,10),cellPadding: PdfPaddings(left: 5,right: 2,top: 2,bottom: 2));

      grid3.columns.add(count: 3);
      grid3.headers.add(1);

      PdfGridRow header3 = grid3.headers[0];
      header3.cells[0].value = "Imagen 4";
      header3.cells[1].value = "Imagen 5";
      header3.cells[2].value = "Imagen 6";

      PdfGridRow row3 = grid3.rows.add();

      neighborhoodActModel.photo_4_description != null ?
      row3.cells[0].value = neighborhoodActModel.photo_4_description :
      row3.cells[0].value = "Sin foto";

      neighborhoodActModel.photo_5_description != null ?
      row3.cells[1].value = neighborhoodActModel.photo_5_description :
      row3.cells[1].value = "Sin foto";

      neighborhoodActModel.photo_6_description != null ?
      row3.cells[2].value = neighborhoodActModel.photo_6_description :
      row3.cells[2].value = "Sin foto";

      grid3.draw(page: page2,bounds: Rect.fromLTWH(0,200,0,0));

      PdfGrid grid2 = PdfGrid();
      grid2.style = PdfGridStyle(font: PdfStandardFont(PdfFontFamily.helvetica,10),cellPadding: PdfPaddings(left: 5,right: 2,top: 2,bottom: 2));
      grid2.columns.add(count: 1);
      grid2.headers.add(1);

      PdfGridRow header2 = grid2.headers[0];
      header2.cells[0].value = "OBSERVACIONES PROPIETARIO Y/O ARRENDATARIO";

      PdfGridRow row2 = grid2.rows.add();
      row2.cells[0].value = neighborhoodActModel.person_observations;

      grid2.draw(page: page2,bounds: Rect.fromLTWH(0,450,0,0));

      page2.graphics.drawImage(PdfBitmap(
          await readImageData(neighborhoodActModel.owner_sign!)), Rect.fromLTWH(10, 660, 150, 50));
      page2.graphics.drawString("___________________", subFont2,bounds: Rect.fromLTWH(10, 700, 0, 0));
      page2.graphics.drawString(neighborhoodActModel.owner_name!, subFont2,bounds: Rect.fromLTWH(10, 720, 0, 0));
      page2.graphics.drawString("Propietario y/o Arrendatario", subFont2,bounds: Rect.fromLTWH(10, 740, 0, 0));

      page2.graphics.drawImage(PdfBitmap(
          await readImageData2(neighborhoodActModel.pao_sign!)), Rect.fromLTWH(300, 660, 150, 50));
      page2.graphics.drawString("___________________", subFont2,bounds: Rect.fromLTWH(300, 700, 0, 0));
      page2.graphics.drawString("Paola Andrea Bedoya", subFont2,bounds: Rect.fromLTWH(300, 720, 0, 0));
      page2.graphics.drawString("Ing. Civil / Patóloga", subFont2,bounds: Rect.fromLTWH(300, 740, 0, 0));
    }else{

      PdfGrid grid2 = PdfGrid();
      grid2.style = PdfGridStyle(font: PdfStandardFont(PdfFontFamily.helvetica,10),cellPadding: PdfPaddings(left: 5,right: 2,top: 2,bottom: 2));
      grid2.columns.add(count: 1);
      grid2.headers.add(1);

      PdfGridRow header2 = grid2.headers[0];
      header2.cells[0].value = "OBSERVACIONES PROPIETARIO Y/O ARRENDATARIO";

      PdfGridRow row2 = grid2.rows.add();
      row2.cells[0].value = neighborhoodActModel.person_observations;

      grid2.draw(page: page,bounds: Rect.fromLTWH(0,570,0,0));

      page.graphics.drawImage(PdfBitmap(
          await readImageData(neighborhoodActModel.owner_sign!)), Rect.fromLTWH(10, 660, 150, 50));
      page.graphics.drawString("___________________", subFont2,bounds: Rect.fromLTWH(10, 700, 0, 0));
      page.graphics.drawString(neighborhoodActModel.owner_name!, subFont2,bounds: Rect.fromLTWH(10, 720, 0, 0));
      page.graphics.drawString("Propietario y/o Arrendatario", subFont2,bounds: Rect.fromLTWH(10, 740, 0, 0));

      page.graphics.drawImage(PdfBitmap(
          await readImageData2(neighborhoodActModel.pao_sign!)), Rect.fromLTWH(300, 660, 150, 50));
      page.graphics.drawString("___________________", subFont2,bounds: Rect.fromLTWH(300, 700, 0, 0));
      page.graphics.drawString("Paola Andrea Bedoya", subFont2,bounds: Rect.fromLTWH(300, 720, 0, 0));
      page.graphics.drawString("Ing. Civil / Patóloga", subFont2,bounds: Rect.fromLTWH(300, 740, 0, 0));
    }

    bytes = await document.save();
    document.dispose();

  }

  Future<void> saveAndLaunchFile() async{

    var appDirectory = await getDownloadsDirectory();
    String appImagesPath = appDirectory!.path;
    Directory folderDir = Directory("${appImagesPath}/Actas_Generadas");

    if(await folderDir.exists() == false){
      await folderDir.create(recursive: true);
    }

    String fileName = "${neighborhoodActModel.project}_${neighborhoodActModel.no_prop}_${neighborhoodActModel.owner_name}.pdf";

    final file = File("${folderDir.path}/${fileName}");

    await file.writeAsBytes(bytes!,flush: true);

    OpenFile.open(file.path);


  }

  Future<Uint8List> readImageData(String pathImage) async{

    File file = File(pathImage);
    Uint8List bytes = file.readAsBytesSync();
    return bytes;

  }

  Future<Uint8List> readImageData2(String name) async{

    final data = await rootBundle.load("images/${name}");
    return data.buffer.asUint8List(data.offsetInBytes,data.lengthInBytes);

  }

}

