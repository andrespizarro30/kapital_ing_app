import 'dart:io';
import 'dart:ui';

import 'package:kapital_ing_app/models/bitacora_act_model.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfCreatorBitacora{

  BitacoraActModel bitacoraActModel;

  PdfCreatorBitacora({required this.bitacoraActModel});

  List<int>? bytes = null;

  Future<void> createPDFDoc() async {

    PdfDocument document = PdfDocument();
    final page = document.pages.add();

    PdfStandardFont titleFont = PdfStandardFont(PdfFontFamily.helvetica,30);
    PdfStandardFont titleFont2 = PdfStandardFont(PdfFontFamily.helvetica,20);

    PdfStandardFont subFont = PdfStandardFont(PdfFontFamily.helvetica,15,style: PdfFontStyle.bold);
    PdfStandardFont subFont2 = PdfStandardFont(PdfFontFamily.helvetica,15,style: PdfFontStyle.underline);
    PdfStandardFont subFont3 = PdfStandardFont(PdfFontFamily.helvetica,15,style: PdfFontStyle.regular);

    PdfStringFormat format = PdfStringFormat();
    format.alignment = PdfTextAlignment.center;

    page.graphics.drawString("Bitácora de Obra", titleFont,bounds: Rect.fromLTWH(250, 10, 0, 0),format: format);
    page.graphics.drawString("Fecha de Generación: " + bitacoraActModel!.dateSelected!, titleFont2,bounds: Rect.fromLTWH(250, 40, 0, 0),format: format);

    page.graphics.drawString("Estado Clima Mañana:", subFont,bounds: Rect.fromLTWH(10, 70, 0, 0));
    page.graphics.drawString("${bitacoraActModel!.ClimaManana}", subFont2,bounds: Rect.fromLTWH(180, 70, 0, 0));

    page.graphics.drawString("Estado Clima Tarde:", subFont,bounds: Rect.fromLTWH(10, 90, 0, 0));
    page.graphics.drawString("${bitacoraActModel!.ClimaTarde}", subFont2,bounds: Rect.fromLTWH(180, 90, 0, 0));

    PdfGrid grid1_2 = PdfGrid();
    grid1_2.style = PdfGridStyle(font: PdfStandardFont(PdfFontFamily.helvetica,10),cellPadding: PdfPaddings(left: 5,right: 2,top: 2,bottom: 2));
    grid1_2.columns.add(count: 1);
    grid1_2.headers.add(1);

    PdfGridRow header1_1 = grid1_2.headers[0];
    header1_1.cells[0].value = "Observación General";

    PdfGridRow row1_2 = grid1_2.rows.add();
    row1_2.cells[0].value = bitacoraActModel.ObservacionGeneral;

    grid1_2.draw(page: page,bounds: Rect.fromLTWH(0,110,0,0));

    page.graphics.drawString("Registro Fotográfico Kapital", subFont,bounds: Rect.fromLTWH(10, 250, 0, 0));

    if(bitacoraActModel!.Image_1Kapital != null){
      page.graphics.drawImage(PdfBitmap(bitacoraActModel!.Image_1Kapital!), Rect.fromLTWH(10, 270, 150, 150));
    }

    if(bitacoraActModel!.Image_2Kapital != null){
      page.graphics.drawImage(PdfBitmap(bitacoraActModel!.Image_2Kapital!), Rect.fromLTWH(180, 270, 150, 150));
    }

    if(bitacoraActModel!.Image_3Kapital != null){
      page.graphics.drawImage(PdfBitmap(bitacoraActModel!.Image_3Kapital!), Rect.fromLTWH(350, 270, 150, 150));
    }

    PdfGrid grid = PdfGrid();

    grid.style = PdfGridStyle(font: PdfStandardFont(PdfFontFamily.helvetica,10),cellPadding: PdfPaddings(left: 5,right: 2,top: 2,bottom: 2));

    grid.columns.add(count: 3);
    grid.headers.add(1);

    PdfGridRow header1 = grid.headers[0];
    header1.cells[0].value = "Imagen 1";
    header1.cells[1].value = "Imagen 2";
    header1.cells[2].value = "Imagen 3";

    PdfGridRow row1 = grid.rows.add();
    row1.cells[0].value = bitacoraActModel.DescImg1Kap;
    row1.cells[1].value = bitacoraActModel.DescImg2Kap;
    row1.cells[2].value = bitacoraActModel.DescImg3Kap;

    grid.draw(page: page,bounds: Rect.fromLTWH(0,440,0,0));

    final page2 = document.pages.add();

    if(bitacoraActModel!.Image_4Kapital != null){
      page2.graphics.drawImage(PdfBitmap(bitacoraActModel!.Image_4Kapital!), Rect.fromLTWH(10, 10, 150, 150));
    }

    if(bitacoraActModel!.Image_5Kapital != null){
      page2.graphics.drawImage(PdfBitmap(bitacoraActModel!.Image_5Kapital!), Rect.fromLTWH(180, 10, 150, 150));
    }

    if(bitacoraActModel!.Image_6Kapital != null){
      page2.graphics.drawImage(PdfBitmap(bitacoraActModel!.Image_6Kapital!), Rect.fromLTWH(350, 10, 150, 150));
    }

    PdfGrid grid2 = PdfGrid();

    grid2.style = PdfGridStyle(font: PdfStandardFont(PdfFontFamily.helvetica,10),cellPadding: PdfPaddings(left: 5,right: 2,top: 2,bottom: 2));

    grid2.columns.add(count: 3);
    grid2.headers.add(1);

    PdfGridRow header2 = grid2.headers[0];
    header2.cells[0].value = "Imagen 4";
    header2.cells[1].value = "Imagen 5";
    header2.cells[2].value = "Imagen 6";

    PdfGridRow row2 = grid2.rows.add();
    row2.cells[0].value = bitacoraActModel.DescImg4Kap;
    row2.cells[1].value = bitacoraActModel.DescImg5Kap;
    row2.cells[2].value = bitacoraActModel.DescImg6Kap;

    grid2.draw(page: page2,bounds: Rect.fromLTWH(0,180,0,0));

    PdfGrid grid2_2 = PdfGrid();
    grid2_2.style = PdfGridStyle(font: PdfStandardFont(PdfFontFamily.helvetica,10),cellPadding: PdfPaddings(left: 5,right: 2,top: 2,bottom: 2));
    grid2_2.columns.add(count: 1);
    grid2_2.headers.add(1);

    PdfGridRow header2_1 = grid2_2.headers[0];
    header2_1.cells[0].value = "Observaciónes Generales Kapital";

    PdfGridRow row2_2 = grid2_2.rows.add();
    row2_2.cells[0].value = bitacoraActModel.ObservKapital;

    grid2_2.draw(page: page2,bounds: Rect.fromLTWH(0,600,0,0));


    final page3 = document.pages.add();

    page3.graphics.drawString("Registro Fotográfico Interventoría", subFont,bounds: Rect.fromLTWH(10, 10, 0, 0));

    if(bitacoraActModel!.Image_1Interv != null){
      page3.graphics.drawImage(PdfBitmap(bitacoraActModel!.Image_1Interv!), Rect.fromLTWH(10, 50, 150, 150));
    }

    if(bitacoraActModel!.Image_2Interv != null){
      page3.graphics.drawImage(PdfBitmap(bitacoraActModel!.Image_2Interv!), Rect.fromLTWH(180, 50, 150, 150));
    }

    if(bitacoraActModel!.Image_3Interv != null){
      page3.graphics.drawImage(PdfBitmap(bitacoraActModel!.Image_3Interv!), Rect.fromLTWH(350, 50, 150, 150));
    }

    PdfGrid grid3 = PdfGrid();

    grid3.style = PdfGridStyle(font: PdfStandardFont(PdfFontFamily.helvetica,10),cellPadding: PdfPaddings(left: 5,right: 2,top: 2,bottom: 2));

    grid3.columns.add(count: 3);
    grid3.headers.add(1);

    PdfGridRow header3 = grid3.headers[0];
    header3.cells[0].value = "Imagen 1";
    header3.cells[1].value = "Imagen 2";
    header3.cells[2].value = "Imagen 3";

    PdfGridRow row3 = grid3.rows.add();
    row3.cells[0].value = bitacoraActModel.DescImg1Interv;
    row3.cells[1].value = bitacoraActModel.DescImg2Interv;
    row3.cells[2].value = bitacoraActModel.DescImg3Interv;

    grid3.draw(page: page3,bounds: Rect.fromLTWH(0,220,0,0));


    final page4 = document.pages.add();

    if(bitacoraActModel!.Image_4Interv != null){
      page4.graphics.drawImage(PdfBitmap(bitacoraActModel!.Image_4Interv!), Rect.fromLTWH(10, 10, 150, 150));
    }

    if(bitacoraActModel!.Image_5Interv != null){
      page4.graphics.drawImage(PdfBitmap(bitacoraActModel!.Image_5Interv!), Rect.fromLTWH(180, 10, 150, 150));
    }

    if(bitacoraActModel!.Image_6Interv != null){
      page4.graphics.drawImage(PdfBitmap(bitacoraActModel!.Image_6Interv!), Rect.fromLTWH(350, 10, 150, 150));
    }

    PdfGrid grid4 = PdfGrid();

    grid4.style = PdfGridStyle(font: PdfStandardFont(PdfFontFamily.helvetica,10),cellPadding: PdfPaddings(left: 5,right: 2,top: 2,bottom: 2));

    grid4.columns.add(count: 3);
    grid4.headers.add(1);

    PdfGridRow header4 = grid4.headers[0];
    header4.cells[0].value = "Imagen 4";
    header4.cells[1].value = "Imagen 5";
    header4.cells[2].value = "Imagen 6";

    PdfGridRow row4 = grid4.rows.add();
    row4.cells[0].value = bitacoraActModel.DescImg4Interv;
    row4.cells[1].value = bitacoraActModel.DescImg5Interv;
    row4.cells[2].value = bitacoraActModel.DescImg6Interv;

    grid4.draw(page: page4,bounds: Rect.fromLTWH(0,190,0,0));

    PdfGrid grid4_2 = PdfGrid();
    grid4_2.style = PdfGridStyle(font: PdfStandardFont(PdfFontFamily.helvetica,10),cellPadding: PdfPaddings(left: 5,right: 2,top: 2,bottom: 2));
    grid4_2.columns.add(count: 1);
    grid4_2.headers.add(1);

    PdfGridRow header4_1 = grid4_2.headers[0];
    header4_1.cells[0].value = "Observaciónes Generales Interventoría";

    PdfGridRow row4_2 = grid4_2.rows.add();
    row4_2.cells[0].value = bitacoraActModel.ObservInterv;

    grid4_2.draw(page: page4,bounds: Rect.fromLTWH(0,400,0,0));

    PdfGrid grid5 = PdfGrid();
    grid5.style = PdfGridStyle(font: PdfStandardFont(PdfFontFamily.helvetica,10),cellPadding: PdfPaddings(left: 5,right: 2,top: 2,bottom: 2));
    grid5.columns.add(count: 4);

    PdfGridRow row5 = grid5.rows.add();
    row5.cells[0].value = "VoBo Kapital";
    row5.cells[1].value = "Ok";
    row5.cells[2].value = "VoBo Interventoría";
    row5.cells[3].value = "Ok";

    grid5.draw(page: page4,bounds: Rect.fromLTWH(0,550,0,0));


    if(bitacoraActModel!.SignKapital != null){
      page4.graphics.drawImage(PdfBitmap(bitacoraActModel!.SignKapital!), Rect.fromLTWH(10, 590, 150, 150));
    }

    if(bitacoraActModel!.SignInterv != null){
      page4.graphics.drawImage(PdfBitmap(bitacoraActModel!.SignInterv!), Rect.fromLTWH(350, 590, 150, 150));
    }

    page4.graphics.drawString(bitacoraActModel!.FullNameKapital!, subFont,bounds: Rect.fromLTWH(10, 740, 0, 0));
    page4.graphics.drawString(bitacoraActModel!.FullNameInterv!, subFont,bounds: Rect.fromLTWH(350, 740, 0, 0));


    bytes = await document.save();
    document.dispose();

  }

  Future<void> saveAndLaunchFile() async{

    var appDirectory = await getDownloadsDirectory();
    String appImagesPath = appDirectory!.path;
    Directory folderDir = Directory("${appImagesPath}/Bitacoras_Generadas");

    if(await folderDir.exists() == false){
      await folderDir.create(recursive: true);
    }

    String fileName = "Bitacora_Obra_${bitacoraActModel.dateSelected}}.pdf";

    final file = File("${folderDir.path}/${fileName}");

    await file.writeAsBytes(bytes!,flush: true);

    OpenFile.open(file.path);

  }


}

