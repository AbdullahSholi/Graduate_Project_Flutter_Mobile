// import 'dart:ffi';

class MerchantStoreSliderImages {
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
  List<dynamic> specificStoreCategories;
  String storeDescription;


  MerchantStoreSliderImages(this.merchantname, this.email, this.phone, this.country, this.Avatar,
      this.storeName, this.storeAvatar, this.storeCategory, this.storeSliderImages, this.storeProductImages, this.specificStoreCategories, this.storeDescription);
  factory MerchantStoreSliderImages.fromJson(Map<String,dynamic> json){
    return MerchantStoreSliderImages(
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
      json["specificStoreCategories"],
      json["storeDescription"],
    );
  }

}

