import 'dart:math';
import 'dart:ui';

import '../../../formulas/formulas.dart';
import '../../../model/locations_node.dart';


const NODE_SIZE = 128.0;
const DEGREE_TO_RADIAN = 57.29577957;
const PROPORTIONAL_ROTATION_RATE = 40;

class TempNode {
	double nodeSize;

   var width = 90;
   var height = 180;


  TempNode(this.nodeSize) : super();

  get sprite => null;

  void initTempNode() {
		int x = 8;
		int y = 8;
		int anchor = 90;
	}

	void render(Canvas canvas) {
		prepareCanvas(canvas);
		sprite.render(canvas, width, height);

		ParagraphBuilder paragraph = ParagraphBuilder(ParagraphStyle());
		paragraph.pushStyle(TextStyle(color: Color(0xffc4ff0e), fontSize: nodeSize / 2));
		paragraph.addText('q');
		Paragraph nodeWeightText = paragraph.build()
			..layout(ParagraphConstraints(width: 180.0));
		canvas.drawParagraph(nodeWeightText, Offset((nodeSize - nodeWeightText.minIntrinsicWidth) / 2, (nodeSize - nodeWeightText.height) / 2));
	}

  void prepareCanvas(Canvas canvas) {}
}

class Node extends SpriteComponent {
  int weight = 1;
  int visualWeightAfterPathFinding;
  late LocationNode locationNode;
  bool userOverrideSprite = false;
  late Function sprite;

  double xCoordinate;
  double yCoordinate;
  final double nodeSize;

  List<Path> outgoingConnectedNodes = [];


  Node(
      this.weight,
      this.visualWeightAfterPathFinding,
      this.locationNode,
      this.userOverrideSprite,
      this.xCoordinate,
      this.yCoordinate,
      this.nodeSize,
      this.outgoingConnectedNodes);

  get x => null;

  get y => null;

  void initNode(LocationNode locationNode) {
    var x = xCoordinate;
    var y = yCoordinate;
    var anchor = xCoordinate + yCoordinate;
    this.locationNode = locationNode;

    if (weight != null) {
      visualWeightAfterPathFinding = weight;
    }
  }

  @override
  void render(Canvas canvas) {

    if (visualWeightAfterPathFinding != null) {
      ParagraphBuilder paragraph = ParagraphBuilder(ParagraphStyle());
	  paragraph.pushStyle(TextStyle(color: Color(0xff000000), fontSize: getFontSize()));
	  paragraph.addText(pow(2, 20) <= visualWeightAfterPathFinding ? '∞' : visualWeightAfterPathFinding.floor().toString());
	  Paragraph nodeWeightText = paragraph.build()
		  ..layout(ParagraphConstraints(width: 180.0));

      canvas.drawParagraph(nodeWeightText, Offset((nodeSize - nodeWeightText.minIntrinsicWidth) / 2, (nodeSize - nodeWeightText.height) / 2));
    }
  }

  double getFontSize() {
	  return nodeSize / visualWeightAfterPathFinding
		  .toString()
		  .length - (visualWeightAfterPathFinding
		  .toString()
		  .length == 1 ? 10 : 0) + 2;

	  // return min(
	  // 	max(
	  // 		8,
	  // 		10 + weight.abs() / 6 - (visualWeightAfterPathFinding.toString().length - weight.toString().length) * 2)
	  // 	, nodeSize / 2 - (visualWeightAfterPathFinding.toString().length - weight.toString().length) * 2 + nodeSize / 10);
  }

  void activate() {
    if (!userOverrideSprite) {
      var sprite = Sprite('nodeActive.png');
    }
  }

  void highLightActivate() {
	  sprite = Sprite('node_path.png');
	  userOverrideSprite = true;
  }

  void activateUserOverride() {
    sprite = Sprite('node_user.png');
    userOverrideSprite = true;
  }

  void deactivate() {
    userOverrideSprite = false;
    if (weight < 0) {
      sprite = Sprite('nodeNegative.png');
    } else {
      sprite = Sprite('node.png');
    }
  }

  void activateNegativeCycle() {
    if (!userOverrideSprite) {
      sprite = Sprite('nodeNegative.png');
      userOverrideSprite = true;
    }
  }
}

class SpriteComponent {
}

class Path extends SpriteComponent {
  int weight = 0;
  late bool full;
  bool userOverrideSprite = false;
  late Node rootNode;
  late Node destinationNode;





  void initPath() {
    double deltaX = destinationNode.x - rootNode.x;
    double deltaY = destinationNode.y - rootNode.y;

    double coeff = 1 - (pythagoreanTheorem(rootNode, destinationNode) - rootNode.nodeSize / 2) / pythagoreanTheorem(rootNode, destinationNode);

    var x = rootNode.x + coeff * deltaX;
    var y = rootNode.y + coeff * deltaY;
    var Anchor;
    var anchor = Anchor.bottomCenter;
    var angle = angleInBetween(rootNode, destinationNode) - pi / 2;
  }

  void activate() {
	  if (!userOverrideSprite) {
		  if (full) {
			  var sprite = Sprite('path_reversed_active.png');
		  } else {
			  var sprite = Sprite('path_active.png');
		  }
    }
  }

  void highLightActivate() {
	  if (full) {
		  var sprite = Sprite('path_reversed_path.png');
	  } else {
		  var sprite = Sprite('path_path.png');
	  }
	  userOverrideSprite = true;
  }

  void deactivate() {
    if (full) {
      if (weight < 0) {
        var sprite = Sprite('path_negative_reversed.png');
      } else {
        var sprite = Sprite('path_reversed.png');
      }
    } else {
      if (weight < 0) {
        var sprite = Sprite('path_negative.png');
      } else {
        var sprite = Sprite('path.png');
      }
    }

	userOverrideSprite = false;
  }

  void activateNegativeCycle() {
	  userOverrideSprite = true;
	  if (full) {
		  var sprite = Sprite('path_reversed_negative.png');
	  } else {
		  var sprite = Sprite('path_negative.png');
	  }
  }
}

Sprite(String s) {
  
}
