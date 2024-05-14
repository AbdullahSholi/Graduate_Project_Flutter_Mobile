// import 'dart:ffi';

class Merchant {
  String merchantname;
  String email;
  String phone;
  String country;
  String Avatar;
  String storeName;
  String storeAvatar;
  String storeCategory;
  List<dynamic> storeSliderImages;
  List<dynamic> storeProductImages;
  String storeDescription;
  List<dynamic> type;
  bool activateSlider;
  bool activateCategory;
  bool activateCarts;


  Merchant(this.merchantname, this.email, this.phone, this.country, this.Avatar,
      this.storeName, this.storeAvatar, this.storeCategory, this.storeSliderImages, this.storeProductImages, this.storeDescription, this.type,
      this.activateSlider, this.activateCategory, this.activateCarts);
  factory Merchant.fromJson(Map<String,dynamic> json){
    return Merchant(
      json["merchantname"],
      json["email"],
      json["phone"],
      json["country"],
      json["Avatar"],
      json["storeName"],
      json["storeAvatar"],
      json["storeCategory"],
      json["storeSliderImages"]!,
      json["storeProductImages"],
      json["storeDescription"],
      json["type"],
      json["activateSlider"],
      json["activateCategory"],
      json["activateCarts"],
    );
  }

}

