import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rute_rumah_sakit_brebes/screens/login_screen.dart';
import 'package:rute_rumah_sakit_brebes/screens/map_guide_screens.dart';

import 'hospital_map.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/icon/hospital3.png',
              width: 30,
              height: 30,
            ),
            SizedBox(width: 8),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(text: 'Home Daftar'),
                  TextSpan(
                    text: 'Rumah Sakit',
                    style: TextStyle(color: Colors.white),
                  ),
                  TextSpan(text: ' di Brebes'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(16),
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      children: [
                        DashboardCard(
                          name: 'Jumlah Rumah Sakit',
                          value: '13',
                          icon: Icons.local_hospital,
                        ),
                        DashboardCard(
                          name: 'Jumlah Doktor',
                          value: '86',
                          icon: Icons.people,
                        ),
                        DashboardCard(
                          name: 'Jumlah Pengguna',
                          value: '15',
                          icon: Icons.person,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Redirect to Search Nearest Hospital screen

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HospitalMap()),
                            );
                          },
                          child: Text('Cari Rumah Sakit Terdekat'),
                        ),
                        SizedBox(height: 8),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ListHospitalsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Hospitals'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Hospital 1'),
          ),
          ListTile(
            title: Text('Hospital 2'),
          ),
          // Add more hospitals here
        ],
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          UserCard(
            name: 'John Doe',
            email: FirebaseAuth.instance.currentUser!.email!,
            role: 'User',
            photoUrl:
                'https://via.placeholder.com/150', // Placeholder photo URL
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapGuideScreen()),
              );
            },
            child: ListTile(
              title: Text("Petunjuk Penggunaan"),
              leading: Icon(Icons.info_outline),
            ),
          ),

          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text("Logout")),
          )
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String name;
  final String value;
  final IconData icon;

  const DashboardCard({
    Key? key,
    required this.name,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Colors.blue,
              ),
              SizedBox(height: 16),
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final String name;
  final String email;
  final String role;
  final String photoUrl;

  const UserCard({
    Key? key,
    required this.name,
    required this.email,
    required this.role,
    required this.photoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/icon/profile.png"),
            ),
            SizedBox(height: 16),
            // Text(
            //   name,
            //   style: TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            SizedBox(height: 8),
            Text(
              email,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              role,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
