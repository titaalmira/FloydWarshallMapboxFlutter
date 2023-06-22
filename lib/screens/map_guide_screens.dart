import 'package:flutter/material.dart';

class MapGuideScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Petunjuk Penggunaan'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          StepWidget(
            stepNumber: 'Step 1',
            title: 'Buka Aplikasi',
            description: 'Buka Aplikasi Rute Rumah Sakit Terdekat Kota Brebes',
            imagePath: 'assets/icon/hospitals3.png',
          ),
          SizedBox(height: 16.0),
          StepWidget(
            stepNumber: 'Step 2',
            title: 'Izinkan Akses Lokasi',
            description:
            'Pastikan anda mengizinkan aplikasi untuk bisa mengakses lokasi anda.',
            imagePath: 'assets/icon/hospitals3.png',

          ),
          SizedBox(height: 16.0),
          StepWidget(
            stepNumber: 'Step 3',
            title: 'Login / Daftar ke akun anda',
            description:
            'Login ke akun anda, jika belum punya akun daftar terlebih dahulu melalui menu daftar.',
            imagePath: 'assets/icon/hospitals3.png',
          ),
          SizedBox(height: 16.0),
          StepWidget(
            stepNumber: 'Step 4',
            title: 'Pilih Menu \"Cari Rumah Sakit Terdekat\"',
            description:
            'Gunakan Menu Cari Rumah Sakit Terdekat untuk mencari rumah sakit terdekat di wilayah anda',
            imagePath: 'assets/icon/hospitals3.png',
          ),
          SizedBox(height: 16.0),
          StepWidget(
            stepNumber: 'Step 5',
            title: 'Menampilkan Rute Rumah Sakit Terdekat',
            description:
            'Rute Rumah Sakit Terdekat akan ditampilkan beserta daftar rumah sakit lain yang tersedia',
            imagePath: 'assets/icon/hospitals3.png',

          ),
        ],
      ),
    );
  }
}

class StepWidget extends StatelessWidget {
  final String stepNumber;
  final String title;
  final String description;
  final String imagePath;

  StepWidget({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          stepNumber,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          title,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          description,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }
}