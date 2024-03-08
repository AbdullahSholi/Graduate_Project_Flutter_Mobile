

class User {
  String username;
  String email;
  String phone;
  String country;
  String street;
  String Avatar;

  User(this.username, this.email, this.phone, this.country, this.street, this.Avatar);
  factory User.fromJson(Map<String,dynamic> json){
    return User(
      json["username"]!,
      json["email"]!,
      json["phone"]!,
      json["country"]!,
      json["street"]!,
      json["Avatar"]!,
    );
  }

}