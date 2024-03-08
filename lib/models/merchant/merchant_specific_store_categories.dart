import 'dart:ffi';

class MerchantSpecificStoreCategories {
  late String email;
  late List<String> specificStoreCategories;



  MerchantSpecificStoreCategories( this.email,  this.specificStoreCategories, );
  factory MerchantSpecificStoreCategories.fromJson(Map<String,dynamic> json){
    return MerchantSpecificStoreCategories(
      json["email"]!,
      json["specificStoreCategories"],

    );
  }

}

