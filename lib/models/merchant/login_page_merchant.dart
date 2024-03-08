
class LoginPageMerchant {
  String token;
  String email;

  LoginPageMerchant(this.email,this.token);
  factory LoginPageMerchant.fromJson(Map<String,dynamic> json){
    return LoginPageMerchant(
      json["email"],
      json["token"]! ,
    );
  }

}