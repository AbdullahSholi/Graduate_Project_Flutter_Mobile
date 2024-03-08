import 'dart:ffi';

class UpdateStoreInformations {

  String storeName;
  String storeCategory;
  String storeDescription;
  String Message;

  UpdateStoreInformations(
      this.storeName, this.storeCategory, this.storeDescription, this.Message);
  factory UpdateStoreInformations.fromJson(Map<String,dynamic> json){
    return UpdateStoreInformations(

      json["storeName"],
      json["storeCategory"],
      json["storeDescription"],
      json["Message"],
    );
  }

}