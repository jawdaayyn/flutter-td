import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isspi_bd3/controller/my_firebase_helper.dart';
import 'package:isspi_bd3/globale.dart';
import 'package:isspi_bd3/model/message.dart';
import 'package:isspi_bd3/model/my_user.dart';
import 'package:isspi_bd3/view/my_dashboard.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
 Future<List<Message>> messages = MyFirebaseHelper().getMessages(moi.uid);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: messages,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            //temps d'attente lors de la connexion à la base de donnée
            return const CircularProgressIndicator.adaptive();
          } else {
            if (!snap.hasData) {
              //il n'y a pas d'informations dans la base de donnée
              return const Center(
                child: Text("Aucune donnée"),
              );
            } else {
              List messages =
                  snap.data!.docs.where((e) => e.id != moi.uid).toList();
              return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    Message message = Message(messages[index]);

                      return Card(
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 80,
                                backgroundColor: Colors.blueGrey.shade600,
                              ),
                              Column(
                                children: [
                                  Text(message.content),
                                  Text(message.mail),
                                ],
                              ),
                            ],
                          )
                      )

                  });
            }
          }
        });
  }
}
