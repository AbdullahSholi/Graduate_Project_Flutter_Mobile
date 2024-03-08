
class RegisterPageMerchant {
  String token;
  String email;

  RegisterPageMerchant(this.email,this.token);
  factory RegisterPageMerchant.fromJson(Map<String,dynamic> json){
    return RegisterPageMerchant(
      json["email"],
      json["Token"]! ,
    );
  }

}