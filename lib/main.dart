import 'package:flutter/material.dart';
import 'package:isspi_bd3/controller/my_firebase_helper.dart';
import 'package:isspi_bd3/controller/my_permission_photo.dart';
import 'package:isspi_bd3/mesWidgets/my_bacground.dart';
import 'package:isspi_bd3/view/my_dashboard.dart';
import 'package:isspi_bd3/view/my_loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:isspi_bd3/globale.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MyPermissionPhoto().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyLoading(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //variables
  TextEditingController mail = TextEditingController();
  TextEditingController password = TextEditingController();

  //méthode
  popError() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Erreur"),
            content: const Text("adresse mail/ou mot de passe erroné"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        body: Stack(
      children: [
        const MyBackground(),
        SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(children: [
                  //champs des mails

                  TextField(
                      controller: mail,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.amber,
                          prefixIcon: Icon(Icons.mail),
                          hintText: "Entrer un mail",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)))),

                  //champs du mot de passe
                  const SizedBox(height: 10),

                  TextField(
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.amber,
                          prefixIcon: Icon(Icons.lock),
                          hintText: "Entrer un password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)))),
                  const SizedBox(height: 10),

                  // bouton
                  ElevatedButton(
                      onPressed: () {
                        MyFirebaseHelper()
                            .connectFirebase(
                                email: mail.text, password: password.text)
                            .then((value) {
                          setState(() {
                            moi = value;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyDashBoard()));
                        }).catchError((onError) {
                          //afficher un pop
                          popError();
                        });
                      },
                      child: Text("Connexion")),

                  TextButton(
                      onPressed: () {
                        MyFirebaseHelper()
                            .createUserFirebase(
                                email: mail.text,
                                password: password.text,
                                nom: "",
                                prenom: "")
                            .then((value) {
                          setState(() {
                            moi = value;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyDashBoard()));
                        });
                      },
                      child: const Text("Inscription")),
                ]))),
      ],
    ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
