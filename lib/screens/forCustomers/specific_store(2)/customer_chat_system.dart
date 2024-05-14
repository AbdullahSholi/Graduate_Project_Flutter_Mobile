import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import "package:socket_io_client/socket_io_client.dart" as IO;

class CustomerChatSystem extends StatefulWidget {
  String customerEmailVal;
  String customerTokenVal;
  String emailVal;
  String tokenVal;
  CustomerChatSystem(this.customerEmailVal, this.customerTokenVal, this.emailVal, this.tokenVal,  {super.key});

  @override
  State<CustomerChatSystem> createState() => _CustomerChatSystemState();
}

class _CustomerChatSystemState extends State<CustomerChatSystem> {
  TextEditingController msgInputController = TextEditingController();
  String customerEmailVal = "";
  String customerTokenVal = "";
  String emailVal = "";
  String tokenVal = "";

  late IO.Socket socket;
  int counter = 0;

  void initSocket() {
    socket = IO.io('http://10.0.2.2:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();

    counter++;
    if(counter<2) {
      socket.onConnect((_) {
        print('Connected');
        // Sending data
        socket.emit('storeEmail', {
          'email': widget.emailVal,
          "customerEmail": widget.customerEmailVal
        });

      });
    }

  }

  ChatController chatController = ChatController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // customerTokenVal = widget.customerTokenVal;
    // customerEmailVal = widget.customerEmailVal;
    // emailVal = widget.emailVal;
    // tokenVal = widget.tokenVal;

    initSocket();

    setUpSocketListener();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Column(
          children: [
            Expanded(child: Obx(
              ()=> Container(
                padding: EdgeInsets.all(20),
                child: Text("Connected User ${chatController.connectedUser}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
                ),),
              ),
            )),
            Expanded(
                flex: 9,
                child: Obx(
                  ()=> ListView.builder(
                      itemCount: chatController.chatMessages.length,
                      itemBuilder: (context, index) {
                        var currentItem = chatController.chatMessages[index];
                        return MessageItem(sentByMe: currentItem.sentByMe == socket.id, message: currentItem.message,);
                      }),
                )),
            Expanded(
                child: Container(
              // color: Colors.red,
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.purple,
                controller: msgInputController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10)),
                    suffixIcon: Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 5, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red,
                        ),
                        child: IconButton(
                          onPressed: () {
                            sendMessage(msgInputController.text);
                            msgInputController.text = "";
                          },
                          icon: Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                          ),
                        ))),
              ),
              padding: EdgeInsets.all(10),
            )),
          ],
        ),
      ),
    );
  }

  void sendMessage(String text) {
    var messageJson = {
      "message": text,
      "sentByMe": socket.id,
    };
    socket.emit("message", messageJson);
    chatController.chatMessages.add(Message.fromJson(messageJson));
  }

  void setUpSocketListener() {
    socket.on("message-recieve", (data){
      print(data);
      chatController.chatMessages.add(Message.fromJson(data));
    });

    socket.on("connected-user", (data){
      print(data);
      chatController.connectedUser.value = data;
    });


  }
}

class MessageItem extends StatelessWidget {
  MessageItem({super.key, required this.sentByMe, required this.message});
  final bool sentByMe;
  final String message;
  Color purple = Color(0xFF6c5ce7);
  Color black = Color(0xFF191919);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: sentByMe ? purple : Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              message,
              style: TextStyle(color: sentByMe ? Colors.white : purple, fontSize: 18, ),
            ),
            SizedBox(width: 5,),
            Text(
              "1:10 AM",
              style: TextStyle(color: (sentByMe ? Colors.white : purple).withOpacity(.7), fontSize: 10, ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatController extends GetxController{
  var chatMessages = <Message>[].obs;
  var connectedUser = 0.obs as RxInt;
}

class Message {
  String message;
  String sentByMe;

  Message({required this.message, required this.sentByMe});

  factory Message.fromJson(Map<String, dynamic> json){
    return Message(message: json["message"], sentByMe: json["sentByMe"]);
  }

}

////////////////////////////////////
////////////////////////////////////
////////////////////////////////////
////////////////////////////////////
