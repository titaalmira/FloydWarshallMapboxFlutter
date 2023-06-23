import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rute_rumah_sakit_brebes/model/hospital_model.dart';
import 'package:rute_rumah_sakit_brebes/screens/detail_hospital_screen.dart';
import 'package:rute_rumah_sakit_brebes/screens/direction_to_hospital_screen.dart';

import '../constants/hospitals.dart';

class FilterHospitalScreen extends StatefulWidget {
  final String value;

  const FilterHospitalScreen({Key? key, required this.value}) : super(key: key);

  @override
  State<FilterHospitalScreen> createState() => _RestaurantsTableState();
}

class _RestaurantsTableState extends State<FilterHospitalScreen> {
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

  late List<Hospital> filteredList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    filteredList = listHospitals.where(
      (element) {
        return element.politeknik
            .any((element) => element.contains(widget.value));
      },
    ).toList();

    print(filteredList.length);

    for (var i = 0; i < filteredList.length; i++) {
      print(filteredList[i].name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Rumah Sakit'),
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
              Text(
                "Daftar Rumah Sakit dengan Keperluan " + widget.value,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: filteredList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          height: 300,
                          width: 120,
                          fit: BoxFit.cover,
                          imageUrl: filteredList[index].pictureUrl,
                        ),
                        Expanded(
                          child: Container(
                            height: 300,
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  filteredList[index].name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(filteredList[index].address),
                                const Spacer(),
                                ListTile(
                                  leading: Icon(Icons.calendar_today),
                                  contentPadding: EdgeInsets.all(4.0),
                                  title: Column(
                                    children: [
                                      Text('Hari Buka'),
                                    ],
                                  ),
                                  subtitle: Column(
                                    children: [
                                      Text(filteredList[index].openingDays),
                                      Text(
                                          "${filteredList[index].openingTime} - ${filteredList[index].closingTime}")
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HospitalDetailScreen(
                                                      hospital:
                                                          filteredList[index])),
                                        );
                                      },
                                      child: Text("Detail"),
                                    ),
                                    Spacer(),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DirectionToHospitalScreen(nama: filteredList[index].name, lat: filteredList[index].latitude, long: filteredList[index].longitude, ),
                                          ),
                                        );
                                      },
                                      child: Text("Rute"),
                                    ),
                                  ],
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
