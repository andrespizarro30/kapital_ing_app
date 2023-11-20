
import 'dart:core';

class NeighborhoodActModel{

  int? ID;
  String? project;
  String? type_pro;
  int? no_prop;
  int? area;
  String? owner_name;
  String? owner_id;
  String? owner_phone;
  String? state_property_description;
  String? photo_1;
  String? photo_1_description;
  String? photo_2;
  String? photo_2_description;
  String? photo_3;
  String? photo_3_description;
  String? photo_4;
  String? photo_4_description;
  String? photo_5;
  String? photo_5_description;
  String? photo_6;
  String? photo_6_description;
  String? person_observations;
  String? owner_sign;
  String? pao_sign;

  NeighborhoodActModel({
    this.ID,
    this.project,
    this.type_pro,
    this.no_prop,
    this.area,
    this.owner_name,
    this.owner_id,
    this.owner_phone,
    this.state_property_description,
    this.photo_1,
    this.photo_1_description,
    this.photo_2,
    this.photo_2_description,
    this.photo_3,
    this.photo_3_description,
    this.photo_4,
    this.photo_4_description,
    this.photo_5,
    this.photo_5_description,
    this.photo_6,
    this.photo_6_description,
    this.person_observations,
    this.owner_sign,
    this.pao_sign
  });

  NeighborhoodActModel.fromMap(Map<String,dynamic> NeighborhoodActMap){
    this.ID = NeighborhoodActMap["no_prop"];
    this.project = NeighborhoodActMap["project"];
    this.type_pro = NeighborhoodActMap["type_pro"];
    this.no_prop = NeighborhoodActMap["no_prop"];
    this.area = NeighborhoodActMap["area"];
    this.owner_name = NeighborhoodActMap["owner_name"];
    this.owner_id = NeighborhoodActMap["owner_id"];
    this.owner_phone = NeighborhoodActMap["owner_phone"];
    this.state_property_description = NeighborhoodActMap["state_property_description"];
    this.photo_1 = NeighborhoodActMap["photo_1"];
    this.photo_1_description = NeighborhoodActMap["photo_1_description"];
    this.photo_2 = NeighborhoodActMap["photo_2"];
    this.photo_2_description = NeighborhoodActMap["photo_2_description"];
    this.photo_3 = NeighborhoodActMap["photo_3"];
    this.photo_3_description = NeighborhoodActMap["photo_3_description"];
    this.photo_4 = NeighborhoodActMap["photo_4"];
    this.photo_4_description = NeighborhoodActMap["photo_4_description"];
    this.photo_5 = NeighborhoodActMap["photo_5"];
    this.photo_5_description = NeighborhoodActMap["photo_5_description"];
    this.photo_6 = NeighborhoodActMap["photo_6"];
    this.photo_6_description = NeighborhoodActMap["photo_6_description"];
    this.person_observations = NeighborhoodActMap["person_observations"];
    this.owner_sign = NeighborhoodActMap["owner_sign"];
    this.pao_sign = NeighborhoodActMap["pao_sign"];
  }

  Map<String,dynamic> toMap(){
    return{
    'ID': ID,
    'project':project,
    'type_pro':type_pro,
    'no_prop':no_prop,
    'area':area,
    'owner_name':owner_name,
    'owner_id':owner_id,
    'owner_phone':owner_phone,
    'state_property_description':state_property_description,
    'photo_1':photo_1,
    'photo_1_description':photo_1_description,
    'photo_2':photo_2,
    'photo_2_description':photo_2_description,
    'photo_3':photo_3,
    'photo_3_description':photo_3_description,
    'photo_4':photo_4,
    'photo_4_description':photo_4_description,
    'photo_5':photo_5,
    'photo_5_description':photo_5_description,
    'photo_6':photo_6,
    'photo_6_description':photo_6_description,
    'person_observations':person_observations,
    'owner_sign':owner_sign,
    'pao_sign':pao_sign
    };
  }



}