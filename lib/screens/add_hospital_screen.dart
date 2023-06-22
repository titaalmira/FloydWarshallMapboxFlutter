import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rute_rumah_sakit_brebes/helpers/commons.dart';


class AddHospitalScreen extends StatefulWidget {
  const AddHospitalScreen({Key? key}) : super(key: key);

  @override
  State<AddHospitalScreen> createState() => _AddHospitalScreenState();
}

class _AddHospitalScreenState extends State<AddHospitalScreen> {

  final TextEditingController _namaRumahSakitController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  bool _loading = false;

  String? _validateNamaRumahSakit(String value) {
    if (value.isEmpty) {
      return 'Masukan Nama Rumah Sakit';
    }
    return null;
  }

  String? _validateAlamatRumahSakit(String value) {
    if (value.isEmpty) {
      return 'Masukan Alamat Rumah Sakit';
    }
    return null;
  }

  String? _valildateLatitudeRumahSakit(String value) {
    if (value.isEmpty) {
      return 'Masukan Latitude Rumah Sakit';
    }
    return null;
  }

  String? _valildateLongitudeRumahSakit(String value) {
    if (value.isEmpty) {
      return 'Masukan Longitude Rumah Sakit';
    }
    return null;
  }

  void _saveData() {
    String namaRumahSakit = _namaRumahSakitController.text;
    String alamat = _alamatController.text;
    double latitude = double.tryParse(_latitudeController.text) ?? 0.0;
    double longitude = double.tryParse(_longitudeController.text) ?? 0.0;

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    String id = generateRandomString(10);

    // Create a new document with the specified ID in the "rumahSakit" collection
    firestore.collection('rumahSakit').doc(id).set({
      'id' : id,
      'namaRumahSakit': namaRumahSakit,
      'alamat': alamat,
      'foto': "foto",
      'latitude': latitude,
      'longitude': longitude,
    }).then((value) {
      // Data saved successfully
      print('Data saved to Firestore');
      // Clear the text fields after saving
      _namaRumahSakitController.clear();
      _alamatController.clear();
      _latitudeController.clear();
      _longitudeController.clear();
    }).catchError((error) {
      // An error occurred while saving the data
      print('Error saving data: $error');
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Input Screen'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _namaRumahSakitController,
                  decoration: InputDecoration(labelText: 'Nama Rumah Sakit'),
                ),
                TextFormField(
                  controller: _alamatController,
                  decoration: InputDecoration(labelText: 'Alamat'),
                ),
                TextFormField(
                  controller: _latitudeController,
                  decoration: InputDecoration(labelText: 'Latitude'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _longitudeController,
                  decoration: InputDecoration(labelText: 'Longitude'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _saveData,
                  child: Text('SIMPAN'),
                ),
              ],
            ),
          ),
          if(_loading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

