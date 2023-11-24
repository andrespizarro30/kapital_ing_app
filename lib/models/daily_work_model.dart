
import 'dart:typed_data';

class DailyWorkAct{

  String? dateSelected;
  String? ClimaManana;
  String? ClimaTarde;
  String? DescImg1Kap;
  String? DescImg2Kap;
  String? DescImg3Kap;
  String? DescImg4Kap;
  String? DescImg5Kap;
  String? DescImg6Kap;
  Uint8List? Image_1Kapital;
  Uint8List? Image_2Kapital;
  Uint8List? Image_3Kapital;
  Uint8List? Image_4Kapital;
  Uint8List? Image_5Kapital;
  Uint8List? Image_6Kapital;
  Uint8List? SignKapital;
  String? FullNameKapital;

  DailyWorkAct({
    this.dateSelected,
    this.ClimaManana,
    this.ClimaTarde,
    this.DescImg1Kap,
    this.DescImg2Kap,
    this.DescImg3Kap,
    this.DescImg4Kap,
    this.DescImg5Kap,
    this.DescImg6Kap,
    this.Image_1Kapital,
    this.Image_2Kapital,
    this.Image_3Kapital,
    this.Image_4Kapital,
    this.Image_5Kapital,
    this.Image_6Kapital,
    this.SignKapital,
    this.FullNameKapital
  });

  DailyWorkAct.fromMap(Map<String, dynamic> json){
    dateSelected = json['dateSelected'];
    ClimaManana = json['ClimaManana'];
    ClimaTarde = json['ClimaTarde'];
    DescImg1Kap = json['DescImg1Kap'];
    DescImg2Kap = json['DescImg2Kap'];
    DescImg3Kap = json['DescImg3Kap'];
    DescImg4Kap = json['DescImg4Kap'];
    DescImg5Kap = json['DescImg5Kap'];
    DescImg6Kap = json['DescImg6Kap'];
    Image_1Kapital = json['Image_1_Kapital'];
    Image_2Kapital = json['Image_2_Kapital'];
    Image_3Kapital = json['Image_3_Kapital'];
    Image_4Kapital = json['Image_4_Kapital'];
    Image_5Kapital = json['Image_5_Kapital'];
    Image_6Kapital = json['Image_6_Kapital'];
    SignKapital = json['Sign_Kapital'];
    FullNameKapital = json['FullNameKapital'];
  }

  Map<String, dynamic> toMap() {
    final _data = <String, dynamic>{};
    _data['dateSelected'] = dateSelected;
    _data['ClimaManana'] = ClimaManana;
    _data['ClimaTarde'] = ClimaTarde;
    _data['DescImg1Kap'] = DescImg1Kap;
    _data['DescImg2Kap'] = DescImg2Kap;
    _data['DescImg3Kap'] = DescImg3Kap;
    _data['DescImg4Kap'] = DescImg4Kap;
    _data['DescImg5Kap'] = DescImg5Kap;
    _data['DescImg6Kap'] = DescImg6Kap;
    _data['Image_1_Kapital'] = Image_1Kapital;
    _data['Image_2_Kapital'] = Image_2Kapital;
    _data['Image_3_Kapital'] = Image_3Kapital;
    _data['Image_4_Kapital'] = Image_4Kapital;
    _data['Image_5_Kapital'] = Image_5Kapital;
    _data['Image_6_Kapital'] = Image_6Kapital;
    _data['Sign_Kapital'] = SignKapital;
    _data['FullNameKapital'] = FullNameKapital;
    return _data;
  }

}