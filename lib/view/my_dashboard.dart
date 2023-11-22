import 'package:flutter/material.dart';
import 'package:isspi_bd3/mesWidgets/my_bacground.dart';
import 'package:isspi_bd3/mesWidgets/my_profil.dart';
import 'package:isspi_bd3/view/loading_map.dart';
import 'package:isspi_bd3/view/map.dart';
import 'package:isspi_bd3/view/my_all_users.dart';

class MyDashBoard extends StatefulWidget {
  const MyDashBoard({super.key});

  @override
  State<MyDashBoard> createState() => _MyDashBoardState();
}

class _MyDashBoardState extends State<MyDashBoard> {
  //variable
  int indexTapped = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width * 0.75,
        color: Colors.purple,
        child: const MyProfil(),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: indexTapped,
          onTap: (value) {
            setState(() {
              indexTapped = value;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.map), label: "Carte"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: "Personnes")
          ]),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [const MyBackground(), bodyPage()],
      ),
    );
  }

  Widget bodyPage() {
    switch (indexTapped) {
      case 0:
        return const MyLoadingMap();
      case 1:
        return const MyAllUsers();
      default:
        return const Text("erreur");
    }
  }
}
