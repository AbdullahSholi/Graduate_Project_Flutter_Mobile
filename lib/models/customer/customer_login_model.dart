class CustomerLoginPage {
  String token;
  String email;

  CustomerLoginPage(this.email,this.token);
  factory CustomerLoginPage.fromJson(Map<String,dynamic> json){
    return CustomerLoginPage(
      json["email"],
      json["token"]! ,
    );
  }

}