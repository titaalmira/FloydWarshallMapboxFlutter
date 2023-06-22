import 'package:mapbox_gl/mapbox_gl.dart';

import '../constants/hospitals.dart';
import 'dart:math';

LatLng getLatLngFromHospitalData(int index) {
  return LatLng(double.parse(hospitals[index]['coordinates']['latitude']),
      double.parse(hospitals[index]['coordinates']['longitude']));
}



String generateRandomString(int length) {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  Random random = Random();
  String result = '';

  for (int i = 0; i < length; i++) {
    int randIndex = random.nextInt(chars.length);
    result += chars[randIndex];
  }

  return result;
}
