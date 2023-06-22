import 'dart:math';

import 'package:flutter/material.dart';

import '../model/locations_node.dart';
import 'templateGenerator/template_simulation_executor.dart';

final Random rnd = new Random();
enum States { drawNodes, drawConnections, algorithm }

class SimulationAlgorithm {
  late LocationNode locationNode;
  late TemplateSimulationExecutor abstractSimulationExecutor;
  late ScrollController controller;

  get widget => null;




  @override
  void render(Canvas canvas) {
    abstractSimulationExecutor.render(canvas, Size(90, 90));
  }

  @override
  void update(double t) {
    switch (locationNode.algorithmTemplate) {
      case AlgorithmTemplate.graph:
        abstractSimulationExecutor.update(t, Size(90, 90));
        break;
      case AlgorithmTemplate.maze:
        // TODO: Handle this case.
        break;
    }
  }
}

// https://mathematica.stackexchange.com/questions/11632/how-to-generate-a-random-tree
