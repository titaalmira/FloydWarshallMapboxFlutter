import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:rute_rumah_sakit_brebes/helpers/commons.dart';

import '../constants/hospitals.dart';
import '../helpers/shared_prefs.dart';
import '../widgets/carousel_card.dart';
import 'detail_hospital_screen.dart';

class DirectionToHospitalScreen extends StatefulWidget {
  final double lat;
  final double long;
  final String nama;

  const DirectionToHospitalScreen(
      {super.key, required this.lat, required this.long, required this.nama});

  @override
  State<DirectionToHospitalScreen> createState() => _HospitalMapState();
}

class _HospitalMapState extends State<DirectionToHospitalScreen> {
  // Mapbox related
  LatLng latLng = getLatLngFromSharedPrefs();
  late CameraPosition _initialCameraPosition;
  late MapboxMapController controller;
  late List<CameraPosition> _kHospitalList;
  List<Map> carouselData = [];
  List<Map> filteredcarouselData = [];
  List<Map> hospitals2 = [];

  bool _loading = false;

  CarouselController _carouselController = CarouselController();

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

      carouselData.add({
        'index': index,
        'name': hospitals[index]["name"],
        'distance': distance,
        'duration': duration
      });
    }
    // carouselData.sort((a, b) => a['duration'] < b['duration'] ? 0 : 1);

    filteredcarouselData = carouselData.where((element) {
      return element['name'].toString().contains(widget.nama);
    }).toList();

    hospitals2 = hospitals
        .where((element) => element['name'].toString().contains(widget.nama))
        .toList();

    // Generate the list of carousel widgets
    carouselItems = List<Widget>.generate(
        carouselData.length,
        (index) => carouselCard(carouselData[index]['index'],
            carouselData[index]['distance'], carouselData[index]['duration']));

    // initialize map symbols in the same order as carousel widgets
    _kHospitalList = List<CameraPosition>.generate(
        hospitals.length,
        (index) => CameraPosition(
            target: getLatLngFromHospitalData(carouselData[index]['index']),
            zoom: 15));

    setState(() {
      _loading = true;
    });

    startDelayedCode();
  }

  void setCarouselPosition(int index) {
    _carouselController.animateToPage(index);
  }

  void startDelayedCode() {
    Timer(Duration(seconds: 5), () {
      // Code to run after the delay of 5 seconds
      // Put your desired code or function here
      setState(() {
        _loading = false;
      });
      setCarouselPosition(int.parse(hospitals2.first['id']));
      print('Delayed code run');
    });
  }

  _addSourceAndLineLayer(int index, bool removeLayer) async {
    // Can animate camera to focus on the item
    controller
        .animateCamera(CameraUpdate.newCameraPosition(_kHospitalList[index]));

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
    int i = 0;
    for (CameraPosition _kRestaurant in _kHospitalList) {
      await controller.addSymbol(
        SymbolOptions(
          geometry: _kRestaurant.target,
          iconSize: 0.2,
          textField: carouselData[i]['name'],
          iconImage: "assets/icon/hospital3.png",
        ),
      );
      i++;
    }
    _addSourceAndLineLayer(0, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Rumah Sakit'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 7,
              child: MapboxMap(
                accessToken:
                    "sk.eyJ1Ijoid2VsbHlhZGl0YW1hIiwiYSI6ImNsajR1dnJpNjA1bHYzcW81dmNtanRxcWgifQ.dk5MPF-PHkGBI5WIvUnZOA",
                initialCameraPosition: _initialCameraPosition,
                onMapCreated: _onMapCreated,
                onStyleLoadedCallback: _onStyleLoadedCallback,
                myLocationEnabled: false,
                myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
              ),
            ),
            // CarouselSlider(
            //   items: carouselItems,
            //   options: CarouselOptions(
            //     height: 100,
            //     viewportFraction: 0.6,
            //     initialPage: 0,
            //     enableInfiniteScroll: false,
            //     scrollDirection: Axis.horizontal,
            //     onPageChanged:
            //         (int index, CarouselPageChangedReason reason) async {
            //       setState(() {
            //         pageIndex = index;
            //       });
            //       _addSourceAndLineLayer(index, true);
            //     },
            //   ),
            // ),

            CarouselSlider.builder(
              carouselController: _carouselController,
              itemCount: hospitals.length,
              itemBuilder: (context, index, realIndex) {
                int id2 = carouselData[index]['index'];
                return GestureDetector(
                  onTap: () {
                    print(id2);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HospitalDetailScreen(
                              hospital: listHospitals[id2])),
                    );
                  },
                  child: carouselCard(
                      carouselData[index]['index'],
                      carouselData[index]['distance'],
                      carouselData[index]['duration']),
                );
              },
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
            if(_loading)
              Container(
                color: Colors.black54,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(filteredcarouselData.first['name']);
          print(hospitals2.first['id']);
          SnackBar snackBar = SnackBar(
            content: Text(filteredcarouselData.first['name'].toString()),
          );
          setCarouselPosition(int.parse(hospitals2.first['id']));

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
