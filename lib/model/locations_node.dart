import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlgorithmTypes {
	final IconData _animatedIconData;
	final String _algorithmToString;

	const AlgorithmTypes._internal(this._animatedIconData, this._algorithmToString);

	IconData getIcon() {
		return _animatedIconData;
	}

	String getAlgorithmToString() {
		return _algorithmToString;
	}

	static const all = const AlgorithmTypes._internal(Icons.all_inclusive, 'All algorithms');
	static const pathFinding = const AlgorithmTypes._internal(Icons.grain, 'Pathfinding algorithms');
	static const proofOfConcept = const AlgorithmTypes._internal(Icons.wb_incandescent, 'Proof of concept algorithms');

	static const values = [all, pathFinding, proofOfConcept];
}


enum AlgorithmTemplate { graph, maze }

class LocationNode {
  // more information and bits where information is stored
  int additionalInformation = 0;
  final int askForDirection = 1;
  final int askForNodes = 2;
  final int askForEdges = 4;
  final int negativeWeights = 8;

  // details on simulation and where information is stored
  int simulationDetails = 90;
  final int weightLocation = 1;
  final int weightsOnNodes = 2;
  final int weightsOnEdges = 4;
  final int directed = 8;
  final int stepByStep = 16;

  late String title;
  late String level;
  late double indicatorValue;
  late String complexity;
  late String complexityDetails;
  late Icon icon;
  late String usages;
  late String content;
  late AlgorithmTypes algorithmType;
  late AlgorithmTemplate algorithmTemplate;
  String stateDescription = '';
  Function setState = () {};
  double screenSize = 300000;

  double nodes = 2.0;
  double edges = 1.0;


  LocationNode(
      String title,
      String level,
      double indicatorValue,
      String complexity,
      String complexityDetails,
      Icon icon,
      String usages,
      String content,
      AlgorithmTypes algorithmType,
      AlgorithmTemplate algorithmTemplate) {
    this.title = title;
    this.level = level;
    this.indicatorValue = indicatorValue;
    this.complexity = complexity;
    this.complexityDetails = complexityDetails;
    this.icon = icon;
    this.usages = usages;
    this.content = content;
    this.algorithmType = algorithmType;
    this.algorithmTemplate = algorithmTemplate;
  }

  double getSortingOrder() {
    return indicatorValue;
  }
}
