

class UpdatePage {
  String Message;

  UpdatePage(this.Message);
  factory UpdatePage.fromJson(Map<String,dynamic> json){
    return UpdatePage(
      json["Message"],
    );
  }

}