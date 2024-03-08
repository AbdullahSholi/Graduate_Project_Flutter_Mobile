

class LoginPage {
  String token;
  String email;

  LoginPage(this.email,this.token);
  factory LoginPage.fromJson(Map<String,dynamic> json){
    return LoginPage(
      json["email"],
      json["token"]! ,
    );
  }

}