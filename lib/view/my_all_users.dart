import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isspi_bd3/controller/my_firebase_helper.dart';
import 'package:isspi_bd3/globale.dart';
import 'package:isspi_bd3/model/my_user.dart';
import 'package:isspi_bd3/view/messages.dart';

class MyAllUsers extends StatefulWidget {
  const MyAllUsers({super.key});

  @override
  State<MyAllUsers> createState() => _MyAllUsersState();
}

class _MyAllUsersState extends State<MyAllUsers> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: MyFirebaseHelper().cloudUsers.snapshots(),
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
              List documents =
                  snap.data!.docs.where((e) => e.id != moi.uid).toList();
              return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    MyUser lesAutres = MyUser(documents[index]);

                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: ListTile(
                          leading: CircleAvatar(
                            radius: 80,
                            backgroundImage: NetworkImage(lesAutres.image!),
                          ),
                          onTap: () => {
                                setState(() => moi.receiverId = lesAutres.uid),
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Messages(
                                            {"receiverId": lesAutres.uid})))
                              },
                          title: Text(lesAutres.nom),
                          subtitle: Text(lesAutres.mail),
                          trailing: IconButton(
                            icon: const Icon(Icons.heart_broken_outlined),
                            color: moi.favoris != null &&
                                    moi.favoris!.contains(lesAutres.uid)
                                ? Colors.pink
                                : Colors.grey,
                            onPressed: () {
                              if (moi.favoris != null &&
                                  moi.favoris!.contains(lesAutres.uid)) {
                                moi.favoris = moi.favoris!
                                    .where((e) => e != lesAutres.uid)
                                    .toList();

                                Map<String, dynamic> data = {
                                  "FAVORIS": moi.favoris
                                };
                                MyFirebaseHelper().updateUser(moi.uid, data);
                              } else {
                                Map<String, dynamic> data = {
                                  "FAVORIS": [...moi.favoris!, lesAutres.uid]
                                };
                                MyFirebaseHelper().updateUser(moi.uid, data);
                                moi.favoris!.add(lesAutres.uid);
                              }
                            },
                          )),
                    );
                  });
            }
          }
        });
  }
}
