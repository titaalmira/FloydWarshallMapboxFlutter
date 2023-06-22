import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rute_rumah_sakit_brebes/screens/detail_hospital_screen.dart';

import '../constants/hospitals.dart';

class RestaurantsTable extends StatefulWidget {
  const RestaurantsTable({Key? key}) : super(key: key);

  @override
  State<RestaurantsTable> createState() => _RestaurantsTableState();
}

class _RestaurantsTableState extends State<RestaurantsTable> {
  /// Add handlers to buttons later on
  /// For call and maps we can use url_launcher package.
  /// We can also create a turn-by-turn navigation for a particular restaurant.
  /// 🔥 Let's look at it in the next video!!

  Widget cardButtons(IconData iconData, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(5),
          minimumSize: Size.zero,
        ),
        child: Row(
          children: [
            Icon(iconData, size: 16),
            const SizedBox(width: 2),
            Text(label)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Rumah Sakit'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // const CupertinoTextField(
              //   prefix: Padding(
              //     padding: EdgeInsets.only(left: 15),
              //     child: Icon(Icons.search),
              //   ),
              //   padding: EdgeInsets.all(15),
              //   placeholder: 'Cari Rumah Sakit',
              //   style: TextStyle(color: Colors.white),
              //   decoration: BoxDecoration(
              //     color: Colors.black54,
              //     borderRadius: BorderRadius.all(Radius.circular(5)),
              //   ),
              // ),
              const SizedBox(height: 5),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: listHospitals.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          height: 400,
                          width: 160,
                          fit: BoxFit.cover,
                          imageUrl: listHospitals[index].pictureUrl,
                        ),
                        Expanded(
                          child: Container(
                            height: 400,
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  listHospitals[index].name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(listHospitals[index].address),
                                const Spacer(),
                                ListTile(
                                  leading: Icon(Icons.calendar_today),
                                  contentPadding: EdgeInsets.all(4.0),
                                  title: Text('Hari Buka'),
                                  subtitle:
                                      Text(listHospitals[index].openingDays),
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.all(4.0),
                                  leading: Icon(Icons.timelapse),
                                  subtitle: Text(
                                      "${listHospitals[index].openingTime} - ${listHospitals[index].closingTime}"),
                                  title: Text("Jam Buka"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => HospitalDetailScreen(hospital: listHospitals[index])),
                                    );
                                  },
                                  child: Text("Detail"),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      )),
    );
  }
}
