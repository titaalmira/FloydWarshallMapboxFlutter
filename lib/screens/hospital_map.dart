import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:rute_rumah_sakit_brebes/screens/add_hospital_screen.dart';
import 'package:rute_rumah_sakit_brebes/screens/hospital_table.dart';
import 'package:rute_rumah_sakit_brebes/screens/login_screen.dart';

import '../constants/hospitals.dart';
import '../helpers/commons.dart';
import '../helpers/shared_prefs.dart';
import '../widgets/carousel_card.dart';

class HospitalMap extends StatefulWidget {
  const HospitalMap({Key? key}) : super(key: key);

  @override
  State<HospitalMap> createState() => _HospitalMapState();
}

class _HospitalMapState extends State<HospitalMap> {
  // Mapbox related
  LatLng latLng = getLatLngFromSharedPrefs();
  late CameraPosition _initialCameraPosition;
  late MapboxMapController controller;
  late List<CameraPosition> _kHospitalList;
  List<Map> carouselData = [];

  // Carousel related
  int pageIndex = 0;
  bool accessed = false;
  late List<Widget> carouselItems;

  @override
  void initState() {
    super.initState();

    _initialCameraPosition = CameraPosition(target: latLng, zoom: 15);

    // Calculate the distance and time from data in SharedPreferences
    for (int index = 0; index < hospitals.length; index++) {
      num distance = getDistanceFromSharedPrefs(index) / 1000;
      num duration = getDurationFromSharedPrefs(index) / 60;
      carouselData
          .add({'index': index, 'distance': distance, 'duration': duration});
    }
    carouselData.sort((a, b) => a['duration'] < b['duration'] ? 0 : 1);

    // Generate the list of carousel widgets
    carouselItems = List<Widget>.generate(
        hospitals.length,
            (index) => carouselCard(carouselData[index]['index'],
            carouselData[index]['distance'], carouselData[index]['duration']));

    // initialize map symbols in the same order as carousel widgets
    _kHospitalList = List<CameraPosition>.generate(
        hospitals.length,
            (index) => CameraPosition(
            target: getLatLngFromHospitalData(carouselData[index]['index']),
            zoom: 15));
  }

  _addSourceAndLineLayer(int index, bool removeLayer) async {
    // Can animate camera to focus on the item
    controller.animateCamera(
        CameraUpdate.newCameraPosition(_kHospitalList[index]));

    // Add a polyLine between source and destination
    Map geometry = getGeometryFromSharedPrefs(carouselData[index]['index']);
    final _fills = {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "id": 0,
          "properties": <String, dynamic>{},
          "geometry": geometry,
        },
      ],
    };

    // Remove lineLayer and source if it exists
    if (removeLayer == true) {
      await controller.removeLayer("lines");
      await controller.removeSource("fills");
    }

    // Add new source and lineLayer
    await controller.addSource("fills", GeojsonSourceProperties(data: _fills));
    await controller.addLineLayer(
      "fills",
      "lines",
      LineLayerProperties(
        lineColor: Colors.green.toHexStringRGB(),
        lineCap: "round",
        lineJoin: "round",
        lineWidth: 2,
      ),
    );
  }

  _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
  }

  _onStyleLoadedCallback() async {
    for (CameraPosition _kRestaurant in _kHospitalList) {
      await controller.addSymbol(
        SymbolOptions(
          geometry: _kRestaurant.target,
          iconSize: 0.2,
          iconImage: "assets/icon/hospital3.png",
        ),
      );
    }
    _addSourceAndLineLayer(0, false);
  }

  @override
  void dispose(){
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Peta Rumah Sakit'),
      // ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: MapboxMap(
                    accessToken: "sk.eyJ1Ijoid2VsbHlhZGl0YW1hIiwiYSI6ImNsajR1dnJpNjA1bHYzcW81dmNtanRxcWgifQ.dk5MPF-PHkGBI5WIvUnZOA",
                    initialCameraPosition: _initialCameraPosition,
                    onMapCreated: _onMapCreated,
                    onStyleLoadedCallback: _onStyleLoadedCallback,
                    myLocationEnabled: true,
                    myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
                    minMaxZoomPreference: const MinMaxZoomPreference(14, 50),
                  ),
                ),
                CarouselSlider(
                  items: carouselItems,
                  options: CarouselOptions(
                    height: 100,
                    viewportFraction: 0.6,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                    scrollDirection: Axis.horizontal,
                    onPageChanged:
                        (int index, CarouselPageChangedReason reason) async {
                      setState(() {
                        pageIndex = index;
                      });
                      _addSourceAndLineLayer(index, true);
                    },
                  ),
                ),

              ],
            ),
            Column(
              children: [
                // Row(
                //   children: [
                //     Expanded(
                //       child: TextButton(
                //         style: ButtonStyle(
                //           foregroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent),
                //         ),
                //         onPressed: () {
                //           Navigator.of(context).push(
                //             MaterialPageRoute(
                //               builder: (context) => const RestaurantsTable(),
                //             ),
                //           );
                //         },
                //         child: Text('Daftar Rumah Sakit'),
                //       ),
                //     ),
                //     Expanded(
                //       child: TextButton(
                //         style: ButtonStyle(
                //           foregroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent),
                //         ),
                //         onPressed: () {
                //           Navigator.of(context).push(
                //             MaterialPageRoute(
                //               builder: (context) => const AddHospitalScreen(),
                //             ),
                //           );
                //         },
                //         child: Text('Tambah Data Rumah Sakit'),
                //       ),
                //     ),
                //   ],
                // ),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RestaurantsTable(),
                        ),
                      );
                    },
                    child: Text('Daftar Rumah Sakit'),
                  ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: Text('Logout'),
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.animateCamera(
              CameraUpdate.newCameraPosition(_initialCameraPosition));
        },
        child: const Icon(Icons.my_location),
      ),
    );

  // }
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Restaurants Map'),
  //     ),
  //     body: const SafeArea(
  //       child: Center(
  //         child: Text('Let\'s build something awesome 💪🏻'),
  //       ),
  //     ),
  //   );
  }
}
