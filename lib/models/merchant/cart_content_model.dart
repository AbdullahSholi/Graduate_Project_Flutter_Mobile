class CartContentModel {
  String message;


  CartContentModel(this.message);
  factory CartContentModel.fromJson(Map<String,dynamic> json){
    return CartContentModel(
      json["message"],
    );
  }

}