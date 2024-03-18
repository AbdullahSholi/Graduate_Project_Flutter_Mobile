import 'dart:ffi';

class AllStore {
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
  List<dynamic> specificStoreCategories;
  bool activateSlider;
  bool activateCategory;
  bool activateCarts;
  List<dynamic> type;


  AllStore(this.merchantname, this.email, this.phone, this.country, this.Avatar,
      this.storeName, this.storeAvatar, this.storeCategory, this.storeSliderImages, this.storeProductImages, this.storeDescription,
      this.socialMediaAccounts, this.specificStoreCategories, this.activateSlider, this.activateCategory, this.activateCarts, this.type);
  factory AllStore.fromJson(Map<String,dynamic> json){
    return AllStore(
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
      json["specificStoreCategories"],
      json["activateSlider"],
      json["activateCategory"],
      json["activateCarts"],
      json["type"],

    );
  }

}
