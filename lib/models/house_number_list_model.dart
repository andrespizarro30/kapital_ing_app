
class HouseNumberList{

  String? id = "";
  String? type_pro = "";
  String? houseNumber = "";

  HouseNumberList({this.id,this.type_pro,this.houseNumber});

  Map<String,dynamic> toMap(){
    return{
      'id': id,
      'type_pro': type_pro,
      'houseNumber':houseNumber
    };
  }

}