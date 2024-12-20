import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:apps_biodata_ico/details.dart';
import 'package:apps_biodata_ico/models/msiswa.dart';
import 'package:apps_biodata_ico/models/api.dart';

import 'package:http/http.dart' as http;
import 'package:apps_biodata_ico/tambah_form.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  late Future<List<SiswaModel>> sw;
  final swListkey = GlobalKey<HomeState>();

  @override
  void initState() {
    super.initState();
    sw = getSwList();
  }

  Future<List<SiswaModel>> getSwList() async {
    final response = await http.get(Uri.parse(Baseurl.data));
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    List<SiswaModel> sw = items.map<SiswaModel>((json) {
      return SiswaModel.fromJson(json);
    }).toList();
    return sw;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Data Siswa"),
        centerTitle: true,
        backgroundColor: Colors.indigo, // Warna yang lebih segar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue[100]!,
              Colors.blue[300]!
            ], // Gradien untuk latar belakang
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FutureBuilder<List<SiswaModel>>(
            future: sw,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var data = snapshot.data[index];
                    return Card(
                      elevation: 6, // Penambahan bayangan
                      margin: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20), // Spasi antar card
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15), // Rounded corners
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigo,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                        title: Text(
                          "${data.nis} ${data.nama}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            "${data.tplahir}, ${data.alamat}, ${data.tglahir}"),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Details(sw: data)));
                        },
                      ),
                    );
                  });
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, size: 30),
        backgroundColor: Colors.indigo,
        hoverColor: Colors.greenAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              return TambahForm();
            }),
          );
        },
      ),
    );
  }
}
