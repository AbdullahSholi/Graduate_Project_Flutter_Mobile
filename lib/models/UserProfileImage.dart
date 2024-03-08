

class UserProfileImage {
  String? url;

  UserProfileImage(url);
  factory UserProfileImage.fromJson(Map<String,dynamic> json){
    return UserProfileImage(
      json["url"],
    );
  }

}