import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  late String receiver;
  late String sender;
  late String content;
  late String messageId;

  Message.empty() {
    sender = "";
    receiver = "";
    content = "";
    messageId = "";
  }
  Message(DocumentSnapshot snapshot) {
    messageId = snapshot.id;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    sender = data["sender"];
    receiver = data["receiver"];
    content = data["content"];
  }
}
