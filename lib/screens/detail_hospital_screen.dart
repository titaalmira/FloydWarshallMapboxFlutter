import 'package:flutter/material.dart';

import '../model/hospital_model.dart';

class HospitalDetailScreen extends StatefulWidget {
  final Hospital hospital;

  HospitalDetailScreen({required this.hospital});

  @override
  State<HospitalDetailScreen> createState() => _HospitalDetailScreenState();
}

class _HospitalDetailScreenState extends State<HospitalDetailScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Rumah Sakit'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              widget.hospital.pictureUrl,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.hospital.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  ListTile(
                    leading: Icon(Icons.business),
                    title: Text(
                      widget.hospital.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text('Alamat'),
                    subtitle: Text(widget.hospital.address),
                  ),
                  ListTile(
                    leading: Icon(Icons.category),
                    title: Text('Kategori'),
                    subtitle: Text(widget.hospital.category),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text('No HP'),
                    subtitle: Text(widget.hospital.phoneNumber),
                  ),
                  ListTile(
                    leading: Icon(Icons.access_time),
                    title: Text('Jam Buka'),
                    subtitle: Text(widget.hospital.openingTime),
                  ),
                  ListTile(
                    leading: Icon(Icons.access_time),
                    title: Text('Jam Tutup'),
                    subtitle: Text(widget.hospital.openingTime),
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text('Hari Rumah Sakit Beroperasi'),
                    subtitle: Text(widget.hospital.openingDays),
                  ),
                  ListTile(
                    leading: Icon(Icons.map),
                    title: Text('Latitude'),
                    subtitle: Text(widget.hospital.latitude.toString()),
                  ),
                  ListTile(
                    leading: Icon(Icons.map),
                    title: Text('Longitude'),
                    subtitle: Text(widget.hospital.longitude.toString()),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Dafter Politeknik:',

                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.hospital.politeknik.length,
              itemBuilder: (context, index) {
                final String doctor = widget.hospital.politeknik[index];
                return ListTile(
                  title: Text(doctor),
                  leading: CircleAvatar(
                    foregroundImage: NetworkImage("https://lh3.googleusercontent.com/drive-viewer/AFGJ81qgac2l6pKMH1-UVlqPmWiCciD_hxujnKe3Hej3MWFnf9Zd6fQlTtkG6rvpPMun0wW-oJejm6D2vLrJrpGbZBx9X1E-=s2560"),
                    backgroundImage: NetworkImage("https://lh3.googleusercontent.com/drive-viewer/AFGJ81qgac2l6pKMH1-UVlqPmWiCciD_hxujnKe3Hej3MWFnf9Zd6fQlTtkG6rvpPMun0wW-oJejm6D2vLrJrpGbZBx9X1E-=s2560"),
                  ),
                );
              },
            ),

            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Dafter Dokter:',

                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.hospital.doctors.length,
              itemBuilder: (context, index) {
                final doctor = widget.hospital.doctors[index];
                return ListTile(
                  title: Text(doctor.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doctor.specialty),
                      Text(doctor.profilePictureUrl),
                      const SizedBox(height: 16,)
                    ],
                  ),
                  leading: CircleAvatar(
                    foregroundImage: NetworkImage("https://lh3.googleusercontent.com/drive-viewer/AFGJ81qgac2l6pKMH1-UVlqPmWiCciD_hxujnKe3Hej3MWFnf9Zd6fQlTtkG6rvpPMun0wW-oJejm6D2vLrJrpGbZBx9X1E-=s2560"),
                    backgroundImage: NetworkImage("https://lh3.googleusercontent.com/drive-viewer/AFGJ81qgac2l6pKMH1-UVlqPmWiCciD_hxujnKe3Hej3MWFnf9Zd6fQlTtkG6rvpPMun0wW-oJejm6D2vLrJrpGbZBx9X1E-=s2560"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}