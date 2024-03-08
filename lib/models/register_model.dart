

class RegisterPage {
  String token;
  String email;

  RegisterPage(this.email,this.token);
  factory RegisterPage.fromJson(Map<String,dynamic> json){
    return RegisterPage(
      json["email"],
      json["Token"]! ,
    );
  }

}