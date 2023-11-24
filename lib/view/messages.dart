import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isspi_bd3/controller/my_firebase_helper.dart';
import 'package:isspi_bd3/globale.dart';
import 'package:isspi_bd3/model/message.dart';
import 'package:isspi_bd3/model/my_user.dart';

class Messages extends StatefulWidget {
  const Messages(Map<String, String> map, {Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  TextEditingController message = TextEditingController();
  List<Message> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Stack(
        children: [
          // Your chat messages display goes here (using a ListView.builder)
          Positioned.fill(
            child: Container(
              padding: const EdgeInsets.only(bottom: 60), // Adjust as needed
              child: StreamBuilder(
                stream: MyFirebaseHelper().messages.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasData) {
                    messages = (snapshot.data as QuerySnapshot)
                        .docs
                        .map((doc) => Message.fromSnapshot(doc))
                        .toList();
                  }

                  // Your chat messages UI goes here
                  // Example:
                  // Inside your StreamBuilder
                  return ListView.builder(
                    reverse: true, // to scroll from bottom to top
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<MyUser>(
                        future:
                            MyFirebaseHelper().getUser(messages[index].sender),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          if (userSnapshot.hasData &&
                                  messages[index].receiver == moi.uid ||
                              messages[index].sender == moi.uid) {
                            MyUser user = userSnapshot.data!;

                            return ListTile(
                              title: Text(
                                user.mail,
                                textAlign: moi.uid == messages[index].sender
                                    ? TextAlign.right
                                    : TextAlign.left,
                              ),
                              subtitle: Text(
                                messages[index].content,
                                textAlign: moi.uid == messages[index].sender
                                    ? TextAlign.right
                                    : TextAlign.left,
                              ),
                            );
                          } else {
                            return const Text('Error loading user data');
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),

          // Input field and send button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(8),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: message,
                      decoration: const InputDecoration(
                        hintText: 'Envoyer un message...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      // Create a new Message object
                      MyFirebaseHelper().sendMessage({
                        "sender": moi.uid,
                        "receiver": moi.receiverId,
                        "content": message.text,
                      });

                      messages = [
                        ...messages,
                        {
                          "sender": moi.uid,
                          "receiver": moi.receiverId,
                          "content": message.text,
                        } as Message
                      ];
                      message.clear();
                      // Add your send message logic here
                      // e.g., send message to Firestore
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
