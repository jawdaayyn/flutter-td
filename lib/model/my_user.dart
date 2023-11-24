import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isspi_bd3/globale.dart';

class MyUser {
  late String uid;
  late String mail;
  String? image;
  late String nom;
  late String prenom;
  String? pseudo;
  List? favoris;
  String? receiverId;

  MyUser.empty() {
    uid = "";
    mail = "";
    nom = "";
    prenom = "";
  }
  MyUser(DocumentSnapshot snapshot) {
    uid = snapshot.id;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    mail = data["EMAIL"];
    nom = data["NOM"];
    prenom = data["PRENOM"];
    image = data["IMAGE"] ?? imafeDefault;
    favoris = data["FAVORIS"] ?? [];
    pseudo = data["PSEUDO"] ?? "";
  }
}
