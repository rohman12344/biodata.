import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:apps_biodata_ico/models/msiswa.dart';
import 'package:apps_biodata_ico/models/api.dart';
import 'package:apps_biodata_ico/form/form.dart';

class Edit extends StatefulWidget {
  final SiswaModel sw;

  Edit({required this.sw});

  @override
  EditState createState() => EditState();
}

class EditState extends State<Edit> {
  final formkey = GlobalKey<FormState>();

  late TextEditingController nisController,
      namaController,
      tpController,
      tgController,
      kelaminController,
      agamaController,
      alamatController;

  Future editSw() async {
    return await http.post(
      Uri.parse(Baseurl.edit),
      body: {
        "id": widget.sw.id.toString(),
        "nis": nisController.text,
        "nama": namaController.text,
        "tplahir": tpController.text,
        "tglahir": tgController.text,
        "kelamin": kelaminController.text,
        "agama": agamaController.text,
        "alamat": alamatController.text
      },
    );
  }

  pesan() {
    Fluttertoast.showToast(
        msg: "Perubahan data berhasil disimpan :v",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _onConfirm(context) async {
    http.Response response = await editSw();
    final data = json.decode(response.body);
    if (data['success']) {
      pesan();
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    nisController = TextEditingController(text: widget.sw.nis);
    namaController = TextEditingController(text: widget.sw.nama);
    tpController = TextEditingController(text: widget.sw.tplahir);
    tgController = TextEditingController(text: widget.sw.tglahir);
    kelaminController = TextEditingController(text: widget.sw.kelamin);
    agamaController = TextEditingController(text: widget.sw.agama);
    alamatController = TextEditingController(text: widget.sw.alamat);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Siswa"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          child: Text("Update"),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          onPressed: () {
            if (formkey.currentState!.validate()) {
              _onConfirm(context);
            }
          },
        ),
      ),
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: AppForm(
                formkey: formkey,
                nisController: nisController,
                namaController: namaController,
                tpController: tpController,
                tgController: tgController,
                kelaminController: kelaminController,
                agamaController: agamaController,
                alamatController: alamatController,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppForm extends StatelessWidget {
  final GlobalKey<FormState> formkey;
  final TextEditingController nisController;
  final TextEditingController namaController;
  final TextEditingController tpController;
  final TextEditingController tgController;
  final TextEditingController kelaminController;
  final TextEditingController agamaController;
  final TextEditingController alamatController;

  const AppForm({
    Key? key,
    required this.formkey,
    required this.nisController,
    required this.namaController,
    required this.tpController,
    required this.tgController,
    required this.kelaminController,
    required this.agamaController,
    required this.alamatController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formkey,
      child: Column(
        children: [
          _buildTextFormField(nisController, "NIS", Icons.badge),
          SizedBox(height: 16),
          _buildTextFormField(namaController, "Nama", Icons.person),
          SizedBox(height: 16),
          _buildTextFormField(
              tpController, "Tempat Lahir", Icons.location_city),
          SizedBox(height: 16),
          _buildDatePickerField(
              tgController, "Tanggal Lahir", Icons.calendar_today, context),
          SizedBox(height: 16),
          _buildTextFormField(kelaminController, "Jenis Kelamin", Icons.people),
          SizedBox(height: 16),
          _buildTextFormField(agamaController, "Agama", Icons.book),
          SizedBox(height: 16),
          _buildTextFormField(alamatController, "Alamat", Icons.home),
          SizedBox(height: 1),
        ],
      ),
    );
  }

  Widget _buildTextFormField(
      TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Masukkan $label';
        }
        return null;
      },
    );
  }

  Widget _buildDatePickerField(TextEditingController controller, String label,
      IconData icon, BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      readOnly: true,
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode()); // Hide keyboard
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          controller.text = "${pickedDate.toLocal()}".split(' ')[0];
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Masukkan $label';
        }
        return null;
      },
    );
  }
}
