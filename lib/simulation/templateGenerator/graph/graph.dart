import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../formulas/formulas.dart';
import '../../../model/locations_node.dart';
import '../../algorithms/pathfinding/floyd_warshall.dart';
import '../../algorithms/pathfinding/pathfinding_algorithm_template.dart';
import '../../simulation_algorithm.dart';
import 'node.dart';

class Graph {
  late LocationNode locationNode;
  late PathFindingAlgorithmTemplate executiveAlgorithm;
  bool isHandleInput = true;

  // constants that are calculated from locationNode
  late double minWeight;
  late double maxWeight;
  late double minNodeSize;
  late double maxNodeSize;
  late double proportionalMultiplier;

  // variables used in all states
  int speedFactor = 1; // variable used in the slider and game loop
  States state = States.drawNodes;
  List nodes = [];
  List paths = [];

  // temp variables
  List<Node> usedNodes = [];
  List<Node> notUsedNodes = [];
  late List<int> incomingPathsPerNode;
  late List<int> outgoingPathsPerNode;

  var preCalculatedEdges = new EqualityMap.from(const ListEquality(), {});

  bool hardReset = false;
  late Node root;
  late Node destination;
  late int weight;
  double elapsedTime = 0;

  // Graph(this.locationNode) : super(locationNode) {
  //   this.maxWeight = 99;
  //   if (askForInformation(locationNode.additionalInformation, locationNode.negativeWeights)) {
  //     this.minWeight = -this.maxWeight;
  //   } else {
  //     this.minWeight = 0;
  //   }
	// this.minNodeSize = max((38 - locationNode.nodes / 5) * min(pow(locationNode.screenSize / 300000, 0.5), 2), 28 - locationNode.nodes / 5);
	// this.maxNodeSize = max((48 - locationNode.nodes / 5) * min(pow(locationNode.screenSize / 300000, 0.5), 2), 38 - locationNode.nodes / 5);
  //   this.proportionalMultiplier = 120 - locationNode.nodes; // time to finish loading
  //   this.outgoingPathsPerNode = new List<int>.filled(locationNode.nodes.ceil() + 1, 0, growable: false);
  //   this.incomingPathsPerNode = new List<int>.filled(locationNode.nodes.ceil() + 1, 0, growable: false);
  // }

  @override
  void render(Canvas canvas, size) {
    canvas.save();
    paths.forEach((x) {
      x.render(canvas);
      canvas.restore();
      canvas.save();
    });

    nodes.forEach((x) {
      x.render(canvas);
      canvas.restore();
      canvas.save();
    });
  }

  void update(double t, Size size) {
    for (int i = 0; i < speedFactor; i++) {
      switch (state) {
        case States.drawNodes:
			setAppBarMessage('Drawing nodes');
			break;
        case States.drawConnections:
			setAppBarMessage('Drawing paths');
			pathInitialization(t);
			break;
        case States.algorithm:
          switch (locationNode.algorithmType) {
			  case AlgorithmTypes.pathFinding:
              pathFindingSimulationStates();
              break;
			  case AlgorithmTypes.proofOfConcept:
              switch (locationNode.title) {
                case "Four color theorem":
                  break;
              }
              break;
			  case AlgorithmTypes.all:
              //it should never get here
              break;
          }
          break;
      }
    }

    nodes.forEach((x) {
      x.update(t);
    });
    paths.forEach((x) {
      x.update(t);
    });
  }

  void pathFindingSimulationStates() {
    if (executiveAlgorithm == null) {
      pathFindingAlgorithmSelector();
	  if (executiveAlgorithm == null) {
		  if (root == null) {
			  setAppBarMessage('Select root');
		  } else if (destination == null) {
			  setAppBarMessage('Select destination');
		  }
	  }
    } else {
      if (executiveAlgorithm.done) {
		  if (executiveAlgorithm.preSolve) {
			  if (root == null) {
				  setAppBarMessage('Select root');
			  } else if (destination == null) {
				  setAppBarMessage('Select destination');
			  } else {
				  hardReset = true;
				  setAppBarMessage('Press on screen to reset root and destination');
			  }
			  executiveAlgorithm.root = root;
			  executiveAlgorithm.destination = destination;
		  } else {
			  //reset simulation
			  setAppBarMessage('Press on screen to reset the simulation');
			  hardReset = true;
		  }
		  isHandleInput = true;
      } else {
        // run simulation
		  setAppBarMessage('Running simulation');
		  if (!executiveAlgorithm.done) {
			  if (askForInformation(locationNode.simulationDetails, locationNode.stepByStep)) {
				  executiveAlgorithm.step();
			  } else {
				  executiveAlgorithm.allInOne();
			  }
		  }
      }
      executiveAlgorithm.overRideNodeWeights();
    }
  }

  void pathFindingAlgorithmSelector() {
    switch (locationNode.title) {
      case "Floyd-Warshall algorithm":
		  if (checkRequirements()) {
			  executiveAlgorithm = FloydWarshallAlgorithm(root, destination, [], []);
		  }
		  break;
    }
	isHandleInput = executiveAlgorithm == null;
  }

  bool checkRequirementsFull() => root != null && destination != null && nodes != null && paths != null;

  bool checkRequirementsToAllNodes() => root != null && nodes != null && paths != null;

  bool checkRequirements() => nodes != null && paths != null;

  @override
  handleTap(Offset globalPosition, double offset) {
    if (state == States.algorithm && isHandleInput) {
      double paddingLeft = 30.0;
      double paddingTop = 90.0;
      if (hardReset) {
		  if (executiveAlgorithm != null && executiveAlgorithm.preSolve) {
			  for (Node node in nodes) {
				  node.visualWeightAfterPathFinding = node.weight;
				  node.userOverrideSprite = false;
				  if (node.weight < 0) {
					  node.activateNegativeCycle();
				  } else {
					  node.activate();
				  }
			  }
			  for (Path path in paths) {
				  path.userOverrideSprite = false;
				  path.activate();
			  }
		  } else {
			  for (Node node in nodes) {
				  node.visualWeightAfterPathFinding = node.weight;
				  node.userOverrideSprite = false;
				  node.deactivate();
			  }
			  for (Path path in paths) {
				  path.deactivate();
			  }
			  executiveAlgorithm;
		  }

        root;
        destination;
        hardReset = false;
      } else if (root == null) {
        for (Node node in nodes) {
          if (pythagoreanTheoremAll(node.x, node.y, globalPosition.dx - paddingLeft, globalPosition.dy + offset - paddingTop) < minNodeSize) {
            root = node;
            root.activateUserOverride();
          }
        }
      } else if (destination == null) {
        for (Node node in nodes) {
          if (pythagoreanTheoremAll(node.x, node.y, globalPosition.dx - paddingLeft, globalPosition.dy + offset - paddingTop) < minNodeSize) {
            destination = node;
            destination.activateUserOverride();
          }
        }
      } else if (destination != null && pythagoreanTheoremAll(destination.x, destination.y, globalPosition.dx - paddingLeft, globalPosition.dy + offset - paddingTop) < minNodeSize) {
        destination.deactivate();
        destination;
      } else if (pythagoreanTheoremAll(root.x, root.y, globalPosition.dx - paddingLeft, globalPosition.dy + offset - paddingTop) < minNodeSize) {
        root.deactivate();
        root;
      }
    }
  }

  ///////////////////////// NODE INITIALIZATION CODE ///////////////////////////


  void newNode(double t, creationMethod, Size size) {
    // creates a new node with no overlap
    elapsedTime += t;
	if (elapsedTime > 1) {
		int counter = 10;
		while (counter > 0) {
			Node node = creationMethod(size);
			bool overlapping = false;
			// check that it is not overlapping with any existing circle
			// another brute force approach
			for (var i = 0; i < nodes.length; i++) {
				var existing = nodes[i];
				double d = pythagoreanTheorem(node, existing);
				if (d < (existing.nodeSize + maxNodeSize) / 1.6) {
					overlapping = true;
					break;
				}
			}
			// add valid circles to array
			if (!overlapping) {
				node.initNode(locationNode);
				nodes.add(node);
				break;
			}
			counter--;
		}
    }
  }


  Node weightedNodeCreation(Size size) {
    double weight = (rnd.nextInt(maxWeight.floor()).ceilToDouble());
    if (askForInformation(locationNode.additionalInformation, locationNode.negativeWeights)) {
      if (rnd.nextDouble() > 0.9) {
        weight *= -0.1;
      } else {
        weight *= 0.9;
        weight += 10;
      }
    }
    return Node(90, 90, locationNode, true, 9.0, 9.0, 9.0, []);
  }

  double generateYCoordinate(nodeSize, size) => min(size.height, ((elapsedTime - 0.5) / locationNode.nodes * proportionalMultiplier) * rnd.nextDouble() * size.height);

  double generateXCoordinate(nodeSize, size) => rnd.nextDouble() * size.width;

  ///////////////////////// PATH INITIALIZATION CODE ///////////////////////////

  void pathInitialization(double t) {
	  int negativeNodes = nodes
		  .where((f) => f.weight < 0)
		  .toList()
		  .length;
	  if (paths.length < min(locationNode.edges.floor(), ((nodes.length * (nodes.length - 1)) / 2 - (negativeNodes * (negativeNodes - 1)) / 2)) * (askForInformation(locationNode.simulationDetails, locationNode.directed) ? 1 : 2)) {
      //every undirected path counts as 2
		  try {
			  newPath(t, askForInformation(locationNode.additionalInformation, locationNode.weightsOnEdges) ? weightedPathCreation : pathCreation, (paths.length < (locationNode.nodes.floor() - 1) * 2) ? treeGeneration : graphGeneration);
		  } catch (Exception) {
			  state = States.algorithm;
      }
    } else {
      state = States.algorithm;
	  destination = root;
      elapsedTime = 0;
    }
  }

  Path newPath(double t, creationMethod, generationFunction) {
    generationFunction(creationMethod);
    Path outgoing = creationMethod(root, destination);
    outgoing.initPath();
    paths.add(outgoing);
    outgoingPathsPerNode[nodes.indexOf(root)]++;
    incomingPathsPerNode[nodes.indexOf(destination)]++;

    if (paths.length < (locationNode.nodes.floor() - 1) * 2 || !askForInformation(locationNode.simulationDetails, locationNode.directed)) {
      Path incoming = creationMethod(destination, root);
      incoming.initPath();
      paths.add(incoming);
      outgoingPathsPerNode[nodes.indexOf(destination)]++;
      incomingPathsPerNode[nodes.indexOf(root)]++;
    }

    return outgoing;
  }

  void treeGeneration(creationMethod) {
    if (usedNodes.isEmpty) {
      notUsedNodes = new List.from(nodes);
	  root = notUsedNodes.where((f) => f.weight > 0).toList()[0];
	  notUsedNodes.remove(root);
      usedNodes.add(root);
    } else {
		List temp = usedNodes.where((f) => f.weight > 0).toList();
		temp = temp.sublist(max(0, temp.length - 10));
      root = temp[rnd.nextInt(temp.length)];
    }

    destination = notUsedNodes[rnd.nextInt(notUsedNodes.length)];
    double closestDistance = pythagoreanTheorem(destination, root).abs();

    for (Node potentiallyClosest in notUsedNodes) {
      double tempAbs;
      tempAbs = pythagoreanTheorem(potentiallyClosest, root).abs();

      if (tempAbs < closestDistance) {
        destination = potentiallyClosest;
        closestDistance = tempAbs;
      }
    }

    if (closestDistance > 250) {
      for (Node potentiallyClosest in usedNodes) {
        double tempAbs;
        tempAbs = pythagoreanTheorem(potentiallyClosest, destination).abs();

		if (tempAbs < closestDistance && potentiallyClosest.weight > 0) {
          root = potentiallyClosest;
          closestDistance = tempAbs;
        }
      }
    }

    notUsedNodes.remove(destination);
    usedNodes.add(destination);
  }

  void graphGeneration(creationMethod) {
    List<Node> potentialSources = [];
    List<Node> potentialDestinations = [];

    for (int i = 0; i < nodes.length; i++) {
		if (outgoingPathsPerNode[i] < nodes.length - 1 && nodes[i].weight > 0) {
        potentialSources.add(nodes[i]);
      }
      if (incomingPathsPerNode[i] < nodes.length - 1) {
        potentialDestinations.add(nodes[i]);
      }
    }
    root = potentialSources[rnd.nextInt(potentialSources.length)];

    for (Path path in paths) {
      if (path.rootNode == root) {
        if (potentialDestinations.contains(path.destinationNode)) {
          potentialDestinations.remove(path.destinationNode);
        }
      }
    }

    if (potentialDestinations.contains(root)) {
      potentialDestinations.remove(root);
    }

	destination = potentialDestinations[rnd.nextInt(potentialDestinations.length)];
    double closestDistance = pythagoreanTheorem(destination, root).abs();

    for (Node potentiallyClosest in potentialDestinations) {
      double tempAbs;
      if (preCalculatedEdges.containsKey([root, potentialDestinations])) {
        tempAbs = preCalculatedEdges[[root, potentialDestinations]];
      } else {
        tempAbs = pythagoreanTheorem(potentiallyClosest, root).abs();
        preCalculatedEdges[[root, potentialDestinations]] = tempAbs;
      }
      if (tempAbs < closestDistance) {
        destination = potentiallyClosest;
        closestDistance = tempAbs;
      }
    }
  }

  Path pathCreation(Node root, Node destination) {
    for (Path path in paths) {
      if (path.destinationNode == root && path.rootNode == destination) {
        return path;
      }
    }
    return paths.first;
  }

  Path weightedPathCreation(Node root, Node destination) {
    if (askForInformation(locationNode.simulationDetails, locationNode.directed) || paths.length % 2 == 0) {
      weight = (rnd.nextInt(maxNodeSize.floor() - minNodeSize.floor()) + minNodeSize).floor();
    }

    for (Path path in paths) {
      if (path.destinationNode == root && path.rootNode == destination) {
        return path;
      }
    }
    return paths.first;
  }

  void setAppBarMessage(String s) {

  }
}
