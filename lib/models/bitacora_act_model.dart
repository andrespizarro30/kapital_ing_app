import 'dart:typed_data';

class BitacoraActModel{

  String? dateSelected;
  String? ClimaManana;
  String? ClimaTarde;
  bool? ClosedInterv;
  bool? ClosedKapital;
  String? DescImg1Interv;
  String? DescImg1Kap;
  String? DescImg2Interv;
  String? DescImg2Kap;
  String? DescImg3Interv;
  String? DescImg3Kap;
  String? DescImg4Interv;
  String? DescImg4Kap;
  String? DescImg5Interv;
  String? DescImg5Kap;
  String? DescImg6Interv;
  String? DescImg6Kap;
  Uint8List? Image_1Interv;
  Uint8List? Image_1Kapital;
  Uint8List? Image_2Interv;
  Uint8List? Image_2Kapital;
  Uint8List? Image_3Interv;
  Uint8List? Image_3Kapital;
  Uint8List? Image_4Interv;
  Uint8List? Image_4Kapital;
  Uint8List? Image_5Interv;
  Uint8List? Image_5Kapital;
  Uint8List? Image_6Interv;
  Uint8List? Image_6Kapital;
  String? ObservInterv;
  String? ObservKapital;
  String? ObservacionGeneral;
  Uint8List? SignInterv;
  Uint8List? SignKapital;
  bool? VoBoInterv;
  bool? VoBoKapital;
  String? FullNameKapital;
  String? FullNameInterv;

  BitacoraActModel({
    this.dateSelected,
    this.ClimaManana,
    this.ClimaTarde,
    this.ClosedInterv,
    this.ClosedKapital,
    this.DescImg1Interv,
    this.DescImg1Kap,
    this.DescImg2Interv,
    this.DescImg2Kap,
    this.DescImg3Interv,
    this.DescImg3Kap,
    this.DescImg4Interv,
    this.DescImg4Kap,
    this.DescImg5Interv,
    this.DescImg5Kap,
    this.DescImg6Interv,
    this.DescImg6Kap,
    this.Image_1Interv,
    this.Image_1Kapital,
    this.Image_2Interv,
    this.Image_2Kapital,
    this.Image_3Interv,
    this.Image_3Kapital,
    this.Image_4Interv,
    this.Image_4Kapital,
    this.Image_5Interv,
    this.Image_5Kapital,
    this.Image_6Interv,
    this.Image_6Kapital,
    this.ObservInterv,
    this.ObservKapital,
    this.ObservacionGeneral,
    this.SignInterv,
    this.SignKapital,
    this.VoBoInterv,
    this.VoBoKapital,
    this.FullNameInterv,
    this.FullNameKapital
  });

  BitacoraActModel.fromMap(Map<String, dynamic> json){
    dateSelected = json['dateSelected'];
    ClimaManana = json['ClimaManana'];
    ClimaTarde = json['ClimaTarde'];
    ClosedInterv = json['ClosedInterv'];
    ClosedKapital = json['ClosedKapital'];
    DescImg1Interv = json['DescImg1Interv'];
    DescImg1Kap = json['DescImg1Kap'];
    DescImg2Interv = json['DescImg2Interv'];
    DescImg2Kap = json['DescImg2Kap'];
    DescImg3Interv = json['DescImg3Interv'];
    DescImg3Kap = json['DescImg3Kap'];
    DescImg4Interv = json['DescImg4Interv'];
    DescImg4Kap = json['DescImg4Kap'];
    DescImg5Interv = json['DescImg5Interv'];
    DescImg5Kap = json['DescImg5Kap'];
    DescImg6Interv = json['DescImg6Interv'];
    DescImg6Kap = json['DescImg6Kap'];
    Image_1Interv = json['Image_1_Interv'];
    Image_1Kapital = json['Image_1_Kapital'];
    Image_2Interv = json['Image_2_Interv'];
    Image_2Kapital = json['Image_2_Kapital'];
    Image_3Interv = json['Image_3_Interv'];
    Image_3Kapital = json['Image_3_Kapital'];
    Image_4Interv = json['Image_4_Interv'];
    Image_4Kapital = json['Image_4_Kapital'];
    Image_5Interv = json['Image_5_Interv'];
    Image_5Kapital = json['Image_5_Kapital'];
    Image_6Interv = json['Image_6_Interv'];
    Image_6Kapital = json['Image_6_Kapital'];
    ObservInterv = json['ObservInterv'];
    ObservKapital = json['ObservKapital'];
    ObservacionGeneral = json['ObservacionGeneral'];
    SignInterv = json['Sign_Interv'];
    SignKapital = json['Sign_Kapital'];
    VoBoInterv = json['VoBoInterv'];
    VoBoKapital = json['VoBoKapital'];
    FullNameInterv = json['FullNameInterv'];
    FullNameKapital = json['FullNameKapital'];
  }

  Map<String, dynamic> toMap() {
    final _data = <String, dynamic>{};
    _data['dateSelected'] = dateSelected;
    _data['ClimaManana'] = ClimaManana;
    _data['ClimaTarde'] = ClimaTarde;
    _data['ClosedInterv'] = ClosedInterv;
    _data['ClosedKapital'] = ClosedKapital;
    _data['DescImg1Interv'] = DescImg1Interv;
    _data['DescImg1Kap'] = DescImg1Kap;
    _data['DescImg2Interv'] = DescImg2Interv;
    _data['DescImg2Kap'] = DescImg2Kap;
    _data['DescImg3Interv'] = DescImg3Interv;
    _data['DescImg3Kap'] = DescImg3Kap;
    _data['DescImg4Interv'] = DescImg4Interv;
    _data['DescImg4Kap'] = DescImg4Kap;
    _data['DescImg5Interv'] = DescImg5Interv;
    _data['DescImg5Kap'] = DescImg5Kap;
    _data['DescImg6Interv'] = DescImg6Interv;
    _data['DescImg6Kap'] = DescImg6Kap;
    _data['Image_1_Interv'] = Image_1Interv;
    _data['Image_1_Kapital'] = Image_1Kapital;
    _data['Image_2_Interv'] = Image_2Interv;
    _data['Image_2_Kapital'] = Image_2Kapital;
    _data['Image_3_Interv'] = Image_3Interv;
    _data['Image_3_Kapital'] = Image_3Kapital;
    _data['Image_4_Interv'] = Image_4Interv;
    _data['Image_4_Kapital'] = Image_4Kapital;
    _data['Image_5_Interv'] = Image_5Interv;
    _data['Image_5_Kapital'] = Image_5Kapital;
    _data['Image_6_Interv'] = Image_6Interv;
    _data['Image_6_Kapital'] = Image_6Kapital;
    _data['ObservInterv'] = ObservInterv;
    _data['ObservKapital'] = ObservKapital;
    _data['ObservacionGeneral'] = ObservacionGeneral;
    _data['Sign_Interv'] = SignInterv;
    _data['Sign_Kapital'] = SignKapital;
    _data['VoBoInterv'] = VoBoInterv;
    _data['VoBoKapital'] = VoBoKapital;
    _data['FullNameInterv'] = FullNameInterv;
    _data['FullNameKapital'] = FullNameKapital;
    return _data;
  }

}