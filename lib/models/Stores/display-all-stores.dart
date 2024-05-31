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
  String backgroundColor;
  String boxesColor;
  String primaryTextColor;
  String secondaryTextColor;
  String clippingColor;
  String smoothy;
  String design;



  SpecificStore(this.merchantname, this.email, this.phone, this.country, this.Avatar,
      this.storeName, this.storeAvatar, this.storeCategory, this.storeSliderImages, this.storeProductImages, this.storeDescription,
      this.storeSocialMediaAccounts, this.specificStoreCategories, this.activateSlider, this.activateCategory, this.activateCarts,
      this.backgroundColor, this.boxesColor, this.primaryTextColor, this.secondaryTextColor, this.clippingColor, this.smoothy, this.design);
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

      json["backgroundColor"]!,
      json["boxesColor"]!,
      json["primaryTextColor"]!,
      json["secondaryTextColor"]!,
      json["clippingColor"]!,
      json["smoothy"]!,
      json["design"]!,


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
