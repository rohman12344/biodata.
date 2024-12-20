import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:apps_biodata_ico/models/api.dart';
import 'package:apps_biodata_ico/models/msiswa.dart';
import 'package:apps_biodata_ico/edit.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

class Details extends StatefulWidget {
  final SiswaModel sw;
  Details({required this.sw});

  @override
  DetailsState createState() => DetailsState();
}

class DetailsState extends State<Details> {
  void deleteSiswa(context) async {
    http.Response response = await http.post(
      Uri.parse(Baseurl.hapus),
      body: {
        'id': widget.sw.id.toString(),
      },
    );
    final data = json.decode(response.body);
    if (data['success']) {
      pesan();
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    }
  }

  pesan() {
    Fluttertoast.showToast(
        msg: "Data berhasil dihapus :v",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void confirmDelete(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            content: Row(
              children: [
                Icon(Icons.warning, color: Colors.red, size: 40),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Yakin mau dihapus?',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton.icon(
                icon: Icon(Icons.cancel, color: Colors.white),
                label: Text("Batal"),
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.check_circle, color: Colors.white),
                label: Text("Hapus"),
                onPressed: () => deleteSiswa(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details Siswa'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            onPressed: () => confirmDelete(context),
            icon: Icon(Icons.delete, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ID : ${widget.sw.id}",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Divider(color: Colors.grey),
                      Text(
                        "NIS : ${widget.sw.nis}",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Nama : ${widget.sw.nama}",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Tempat Lahir : ${widget.sw.tplahir}",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Tanggal Lahir : ${widget.sw.tglahir}",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Jenis Kelamin : ${widget.sw.kelamin}",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Agama : ${widget.sw.agama}",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Alamat : ${widget.sw.alamat}",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit, size: 28),
        backgroundColor: Colors.indigo,
        hoverColor: Colors.greenAccent,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => Edit(sw: widget.sw),
          ),
        ),
      ),
    );
  }
}
