import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:isspi_bd3/model/my_user.dart';

class MyFirebaseHelper {
  final auth = FirebaseAuth.instance;
  final cloudUsers = FirebaseFirestore.instance.collection("UTILISATEURS");
  final storage = FirebaseStorage.instance;

  //creer un utilisateur
  Future<MyUser> createUserFirebase(
      {required String email,
      required String password,
      required String nom,
      required prenom}) async {
    UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    String uid = credential.user!.uid;
    Map<String, dynamic> data = {
      "NOM": nom,
      "PRENOM": prenom,
      "EMAIL": email,
    };
    addUser(uid, data);
    return getUser(uid);
  }

  //connecter un utilisateur
  Future<MyUser> connectFirebase(
      {required String email, required String password}) async {
    UserCredential credential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    String uid = credential.user!.uid;
    return getUser(uid);
  }

  //récupérer les infos de l'utilisateur
  Future<MyUser> getUser(String uid) async {
    DocumentSnapshot snapshot = await cloudUsers.doc(uid).get();
    return MyUser(snapshot);
  }

  //ajouter un utilisateur dans la base de donnée
  addUser(String uid, Map<String, dynamic> data) {
    cloudUsers.doc(uid).set(data);
  }

  //mettre à jour les infos d'un utilisateur
  updateUser(String uid, Map<String, dynamic> data) {
    cloudUsers.doc(uid).update(data);
  }

  //uploader l'image
  Future<String> stockageImage(
      {required Uint8List bytes,
      required nameImage,
      required String dossier,
      required uid}) async {
    TaskSnapshot snapshot =
        await storage.ref("$dossier/$uid/$nameImage").putData(bytes);
    String urlImage = await snapshot.ref.getDownloadURL();
    return urlImage;
  }
}
