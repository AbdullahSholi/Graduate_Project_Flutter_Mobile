

class UpdatePageMerchant {
  String Message;

  UpdatePageMerchant(this.Message);
  factory UpdatePageMerchant.fromJson(Map<String,dynamic> json){
    return UpdatePageMerchant(
      json["Message"],
    );
  }

}