import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../../model/locations_node.dart';

abstract class TemplateSimulationExecutor {
  final LocationNode locationNode;


  TemplateSimulationExecutor(this.locationNode, this.speedFactor);

  int speedFactor;

  void render(Canvas canvas, Size size);

  void update(double t, Size size);

  handleTap(Offset globalPosition, double offset);

  void setAppBarMessage(String message) {
	  if (locationNode.stateDescription != message) {
      locationNode.setState(() {
        locationNode.stateDescription = message;
		  });
	  }
  }
}
