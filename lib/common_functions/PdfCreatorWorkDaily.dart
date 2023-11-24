import 'dart:io';
import 'dart:ui';

import 'package:kapital_ing_app/common_functions/common_functions.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../models/daily_work_model.dart';

class PdfCreatorDailyWork{

  DailyWorkAct dailyWorkAct;

  PdfCreatorDailyWork({required this.dailyWorkAct});

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

    page.graphics.drawString("Seguimiento Diario de Labores", titleFont,bounds: Rect.fromLTWH(250, 10, 0, 0),format: format);
    page.graphics.drawString("Fecha de Generación: " + dailyWorkAct!.dateSelected!, titleFont2,bounds: Rect.fromLTWH(250, 40, 0, 0),format: format);

    page.graphics.drawString("Estado Clima Mañana:", subFont,bounds: Rect.fromLTWH(10, 70, 0, 0));
    page.graphics.drawString("${dailyWorkAct!.ClimaManana}", subFont2,bounds: Rect.fromLTWH(180, 70, 0, 0));

    page.graphics.drawString("Estado Clima Tarde:", subFont,bounds: Rect.fromLTWH(10, 90, 0, 0));
    page.graphics.drawString("${dailyWorkAct!.ClimaTarde}", subFont2,bounds: Rect.fromLTWH(180, 90, 0, 0));


    page.graphics.drawString("Registro Fotográfico", subFont,bounds: Rect.fromLTWH(10, 130, 0, 0));

    if(dailyWorkAct!.Image_1Kapital != null){
      page.graphics.drawImage(PdfBitmap(dailyWorkAct!.Image_1Kapital!), Rect.fromLTWH(10, 180, 150, 150));
    }

    if(dailyWorkAct!.Image_2Kapital != null){
      page.graphics.drawImage(PdfBitmap(dailyWorkAct!.Image_2Kapital!), Rect.fromLTWH(180, 180, 150, 150));
    }

    if(dailyWorkAct!.Image_3Kapital != null){
      page.graphics.drawImage(PdfBitmap(dailyWorkAct!.Image_3Kapital!), Rect.fromLTWH(350, 180, 150, 150));
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
    row1.cells[0].value = dailyWorkAct.DescImg1Kap;
    row1.cells[1].value = dailyWorkAct.DescImg2Kap;
    row1.cells[2].value = dailyWorkAct.DescImg3Kap;

    grid.draw(page: page,bounds: Rect.fromLTWH(0,350,0,0));

    final page2 = document.pages.add();

    if(dailyWorkAct!.Image_4Kapital != null){
      page2.graphics.drawImage(PdfBitmap(dailyWorkAct!.Image_4Kapital!), Rect.fromLTWH(10, 10, 150, 150));
    }

    if(dailyWorkAct!.Image_5Kapital != null){
      page2.graphics.drawImage(PdfBitmap(dailyWorkAct!.Image_5Kapital!), Rect.fromLTWH(180, 10, 150, 150));
    }

    if(dailyWorkAct!.Image_6Kapital != null){
      page2.graphics.drawImage(PdfBitmap(dailyWorkAct!.Image_6Kapital!), Rect.fromLTWH(350, 10, 150, 150));
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
    row2.cells[0].value = dailyWorkAct.DescImg4Kap;
    row2.cells[1].value = dailyWorkAct.DescImg5Kap;
    row2.cells[2].value = dailyWorkAct.DescImg6Kap;

    grid2.draw(page: page2,bounds: Rect.fromLTWH(0,180,0,0));

    PdfGrid grid2_2 = PdfGrid();
    grid2_2.style = PdfGridStyle(font: PdfStandardFont(PdfFontFamily.helvetica,10),cellPadding: PdfPaddings(left: 5,right: 2,top: 2,bottom: 2));
    grid2_2.columns.add(count: 1);
    grid2_2.headers.add(1);


    if(dailyWorkAct!.SignKapital != null){
      page2.graphics.drawImage(PdfBitmap(dailyWorkAct!.SignKapital!), Rect.fromLTWH(10, 580, 150, 150));
    }

    page2.graphics.drawString("__________________________________", subFont,bounds: Rect.fromLTWH(10, 720, 0, 0));

    page2.graphics.drawString(dailyWorkAct!.FullNameKapital!, subFont,bounds: Rect.fromLTWH(10, 740, 0, 0));

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

    String fileName = "Reporte_Trabajo_Diario_${fullNameG}_${dailyWorkAct.dateSelected}.pdf";

    final file = File("${folderDir.path}/${fileName}");

    await file.writeAsBytes(bytes!,flush: true);

    OpenFile.open(file.path);

  }

}