import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  late String receiver;
  late String sender;
  late String content;
  String? messageId;

  Message.empty({required}) {
    sender = "";
    receiver = "";
    content = "";
    messageId = "";
  }

  Message.fromSnapshot(DocumentSnapshot snapshot) {
    messageId = snapshot.id;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    sender = data["sender"];
    receiver = data["receiver"];
    content = data["content"];
  }
}
