class CustomerRegisterPage {
  String token;
  String email;

  CustomerRegisterPage(this.email,this.token);
  factory CustomerRegisterPage.fromJson(Map<String,dynamic> json){
    return CustomerRegisterPage(
      json["email"],
      json["Token"]! ,
    );
  }

}