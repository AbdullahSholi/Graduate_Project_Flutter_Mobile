import 'dart:ffi';

class Store {
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
  List<dynamic> socialMediaAccounts;
  String storeDescription;


  Store(this.merchantname, this.email, this.phone, this.country, this.Avatar,
      this.storeName, this.storeAvatar, this.storeCategory, this.storeSliderImages, this.storeProductImages, this.storeDescription,
      this.socialMediaAccounts);
  factory Store.fromJson(Map<String,dynamic> json){
    return Store(
      json["merchantname"]!,
      json["email"]!,
      json["phone"]!,
      json["country"]!,
      json["Avatar"]!,
      json["storeName"]!,
      json["storeAvatar"]!,
      json["storeCategory"]!,
      json["storeSliderImages"],
      json["storeProductImages"],
        json["storeDescription"],
        json["storeSocialMediaAccounts"],

    );
  }

}
