import 'dart:math';


import '../../templateGenerator/graph/node.dart';

abstract class PathFindingAlgorithmTemplate {
	late Node root;
	late Node destination;
  late final List<Node> nodes;
  late final List<Path> paths;
	late int i = 0;

  late List<List<int>> graph;
	late int V;
  bool done = false;
	bool preSolve = false;

  PathFindingAlgorithmTemplate(this.root, this.destination, this.nodes, this.paths) {
    V = nodes.length;
    for (Node source in nodes) {
      var temp = [i];
      for (Node dest in nodes) {
        Path path = getConnection(source, dest);
        if (path == null) {
          temp.add(i);
        } else {
          temp.add(path.weight + dest.weight);
        }
      }
      graph.add(temp);
    }
  }

  Object step();

  Object allInOne();

	void overRideNodeWeights();

  Path getConnection(Node root, Node destination) {


    for (Path path in paths) {
      if (path.rootNode == root && path.destinationNode == destination) {
        return path;
      }
    }
    return paths.first;
  }

  num maxInt() => pow(2, 20);
}
