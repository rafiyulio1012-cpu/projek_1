import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilPage(),
    );
  }
}

class ProfilPage extends StatelessWidget {

  Widget itemProfil(IconData icon, String text) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(
          text,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Profil Saya"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),

      backgroundColor: Colors.green.shade100,

      body: Column(
        children: [

          SizedBox(height: 20),

          itemProfil(Icons.person,
              "Nama: Ravi Yulio"),

          itemProfil(Icons.badge,
              "NIM: 240103116"),

          itemProfil(Icons.class_,
              "Kelas: TI24A3"),

          itemProfil(Icons.school,
              "Jurusan: Teknik Informatika"),

        ],
      ),
    );
  }
}