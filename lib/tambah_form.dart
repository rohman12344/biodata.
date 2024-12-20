import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:apps_biodata_ico/models/api.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class TambahForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TambahFormState();
  }
}

class TambahFormState extends State<TambahForm> {
  final formkey = GlobalKey<FormState>();

  TextEditingController nisController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController tpController = TextEditingController();
  TextEditingController tgController = TextEditingController();
  TextEditingController kelaminController = TextEditingController();
  TextEditingController agamaController = TextEditingController();
  TextEditingController alamatController = TextEditingController();

  String? selectedAgama;
  String? selectedKelamin;

  final List<String> agamaList = [
    'Islam',
    'Katolik',
    'Protestan',
    'Hindu',
    'Budha',
    'Khonghucu'
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        tgController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future createSw() async {
    return await http.post(
      Uri.parse(Baseurl.tambah),
      body: {
        "nis": nisController.text,
        "nama": namaController.text,
        "tplahir": tpController.text,
        "tglahir": tgController.text,
        "kelamin": selectedKelamin,
        "agama": selectedAgama,
        "alamat": alamatController.text,
      },
    );
  }

  void _onConfirm(context) async {
    http.Response response = await createSw();
    final data = json.decode(response.body);
    if (data['success']) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Siswa"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formkey,
          child: ListView(
            children: <Widget>[
              _buildTextFormField(
                controller: nisController,
                label: "NIS",
                icon: Icons.badge,
                validatorMsg: 'Masukkan NIS',
              ),
              SizedBox(height: 16),

              _buildTextFormField(
                controller: namaController,
                label: "Nama",
                icon: Icons.person,
                validatorMsg: 'Masukkan Nama',
              ),
              SizedBox(height: 16),

              _buildTextFormField(
                controller: tpController,
                label: "Tempat Lahir",
                icon: Icons.location_city,
                validatorMsg: 'Masukkan Tempat Lahir',
              ),
              SizedBox(height: 16),

              _buildDatePickerField(
                controller: tgController,
                label: "Tanggal Lahir",
                icon: Icons.calendar_today,
                context: context,
                validatorMsg: 'Masukkan Tanggal Lahir',
              ),
              SizedBox(height: 16),

              // Radio button for Kelamin
              Text(
                "Jenis Kelamin",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              _buildRadioButton(
                title: 'Laki-laki',
                value: 'Laki-laki',
                groupValue: selectedKelamin,
              ),
              _buildRadioButton(
                title: 'Perempuan',
                value: 'Perempuan',
                groupValue: selectedKelamin,
              ),
              if (selectedKelamin == null)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    'Pilih Jenis Kelamin',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 16),

              // Dropdown for Agama
              DropdownButtonFormField<String>(
                value: selectedAgama,
                decoration: InputDecoration(
                  labelText: 'Agama',
                  prefixIcon: Icon(Icons.book),
                  border: OutlineInputBorder(),
                ),
                items: agamaList.map((String agama) {
                  return DropdownMenuItem<String>(
                    value: agama,
                    child: Text(agama),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedAgama = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih Agama';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              _buildTextFormField(
                controller: alamatController,
                label: "Alamat",
                icon: Icons.home,
                validatorMsg: 'Masukkan Alamat',
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          child: Text("Simpan"),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blueAccent,
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          onPressed: () {
            if (formkey.currentState!.validate()) {
              _onConfirm(context);
            }
          },
        ),
      ),
    );
  }

  // Function to build a TextFormField with an icon
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String validatorMsg,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorMsg;
        }
        return null;
      },
    );
  }

  // Function to build a DatePicker TextFormField
  Widget _buildDatePickerField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required BuildContext context,
    required String validatorMsg,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
      readOnly: true,
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode()); // Hide the keyboard
        await _selectDate(context); // Show date picker
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorMsg;
        }
        return null;
      },
    );
  }

  // Function to build a Radio Button
  Widget _buildRadioButton({
    required String title,
    required String value,
    required String? groupValue,
  }) {
    return RadioListTile<String>(
      title: Text(title),
      value: value,
      groupValue: groupValue,
      onChanged: (String? value) {
        setState(() {
          selectedKelamin = value;
        });
      },
    );
  }
}
