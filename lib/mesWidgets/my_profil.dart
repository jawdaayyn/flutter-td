import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:isspi_bd3/controller/my_firebase_helper.dart';
import 'package:isspi_bd3/globale.dart';

class MyProfil extends StatefulWidget {
  const MyProfil({super.key});

  @override
  State<MyProfil> createState() => _MyProfilState();
}

class _MyProfilState extends State<MyProfil> {
  //variables
  String? namePhoto;
  Uint8List? bytesPhoto;
  String urlImage = "";
  //méthode
  popImage() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Souhaitez-vous enregistrer cette photo?"),
            content: Image.memory(bytesPhoto!),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Annulation")),
              TextButton(
                  onPressed: () {
                    //uploader l'image et l'enregistrer
                    MyFirebaseHelper()
                        .stockageImage(
                            bytes: bytesPhoto!,
                            nameImage: namePhoto!,
                            dossier: "AVATAR",
                            uid: moi.uid)
                        .then((value) {
                      setState(() {
                        urlImage = value;
                        moi.image = urlImage;
                      });
                      Map<String, dynamic> data = {"IMAGE": urlImage};
                      MyFirebaseHelper().updateUser(moi.uid, data);
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Enregistrement")),
            ],
          );
        });
  }

  pickFilesPhoto() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(withData: true, type: FileType.image);
    if (result != null) {
      setState(() {
        namePhoto = result.files.first.name;
        bytesPhoto = result.files.first.bytes;
        popImage();
      });
    }
  }

  popUp(String value) {
    TextEditingController valeurTapped = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Entrer votre $value"),
            content: TextField(
              controller: valeurTapped,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Annuler")),
              TextButton(
                  onPressed: () {
                    //enregistrer dans la base de donnée
                    String valeur = value.toUpperCase();
                    setState(() {
                      if (valeur == "NOM") {
                        moi.nom = valeurTapped.text;
                      }
                      if (valeur == "PRENOM") {
                        moi.prenom = valeurTapped.text;
                      }
                      if (valeur == "PSEUDO") {
                        moi.pseudo = valeurTapped.text;
                      }
                    });
                    Map<String, dynamic> data = {valeur: valeurTapped.text};
                    MyFirebaseHelper().updateUser(moi.uid, data);

                    //
                    Navigator.pop(context);
                  },
                  child: const Text("Enregistrer")),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              print("j'ai appuyé sur l'image");
              pickFilesPhoto();
            },
            child: CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(moi.image!),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.mail),
              const SizedBox(
                width: 20,
              ),
              Text(moi.mail),
            ],
          ),
          Row(
            children: [
              Text(
                moi.nom,
                style: TextStyle(fontSize: 30),
              ),
              IconButton(
                  onPressed: () {
                    popUp("nom");
                  },
                  icon: Icon(Icons.update))
            ],
          ),
          Row(
            children: [
              Text(moi.prenom),
              IconButton(
                  onPressed: () {
                    popUp("prenom");
                  },
                  icon: Icon(Icons.update))
            ],
          ),
          Row(
            children: [
              Text(moi.pseudo!),
              IconButton(
                  onPressed: () {
                    popUp("pseudo");
                  },
                  icon: Icon(Icons.update))
            ],
          ),
        ],
      ),
    );
  }
}
