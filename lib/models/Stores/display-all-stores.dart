import 'dart:convert'; // Import the convert package

class SpecificStore {
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
  List<dynamic> storeSocialMediaAccounts;
  String storeDescription;
  List<dynamic> specificStoreCategories;
  bool activateSlider;
  bool activateCategory;
  bool activateCarts;



  SpecificStore(this.merchantname, this.email, this.phone, this.country, this.Avatar,
      this.storeName, this.storeAvatar, this.storeCategory, this.storeSliderImages, this.storeProductImages, this.storeDescription,
      this.storeSocialMediaAccounts, this.specificStoreCategories, this.activateSlider, this.activateCategory, this.activateCarts,);
  factory SpecificStore.fromJson(Map<String,dynamic> json){
    return SpecificStore(
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


    );
  }

}
class StoreData {
  List<SpecificStore> stores;

  StoreData(this.stores);

  factory StoreData.fromJson(Map<String, dynamic> json) {
    print(json['stores']);

    print("WW");
    return StoreData(
      json['stores'],
    );
  }
}
