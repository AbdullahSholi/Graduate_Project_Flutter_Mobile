
// import 'dart:ffi';

    class GetCartContentModel {

    late List<dynamic> type;


    GetCartContentModel(this.type);
    factory GetCartContentModel.fromJson(Map<String,dynamic> json){
    return GetCartContentModel(
    json["type"],
    );
    }

    }




