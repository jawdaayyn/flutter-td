import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isspi_bd3/controller/my_firebase_helper.dart';
import 'package:isspi_bd3/globale.dart';
//import 'package:isspi_bd3/model/message.dart';

class Messages extends StatefulWidget {
  const Messages(Map<String, String> map, {super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  TextEditingController message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: MyFirebaseHelper().messages.snapshots(),
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
              return Scaffold(
                  body: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(children: [
                        const Text("Messages"),
                        /*SingleChildScrollView(
                  child: ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        Message message = Message(messages[index]);
                        if (message.sender == moi.uid ||
                            message.receiver == moi.uid) {
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
                                ],
                              ),
                            ],
                          ));
                        } else {
                          return null;
                        }
                      }),
                ),
                */

                        TextField(
                            controller: message,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.amber,
                                icon: const Icon(Icons.send),
                                hintText: "Envoyer un message",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)))),
                        const SizedBox(height: 10),
                        IconButton(
                            onPressed: () => {
                                  MyFirebaseHelper().sendMessage({
                                    "receiver": moi.receiverId,
                                    "sender": moi.uid,
                                    "content": message.text
                                  }),
                                  messages.add({
                                    "receiver": moi.receiverId,
                                    "sender": moi.uid,
                                    "content": message.text
                                  }),
                                  message.clear()
                                },
                            icon: const Icon(Icons.send)),
                        const SizedBox(height: 10),
                      ])));
            }
          }
        });
  }
}
