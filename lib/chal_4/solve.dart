import 'dart:io';
import 'dart:math';

import 'package:path/path.dart';

Future<void> main(List<String> args) async {
  List<List<String>> input = (await File(
    join("lib", "chal_4", "input.txt"),
  ).readAsLines()).map((l) => l.split("")).toList();

  List<Point> points = getMovingPoints(input);

  print(points.length);
  // StringBuffer buffer = StringBuffer();
  // for (var i = 0; i < input.length; i++) {
  //   for (var j = 0; j < input[i].length; j++) {
  //     if (points.contains(Point(j, i))) {
  //       buffer.write("x");
  //     } else {
  //       buffer.write(input[i][j]);
  //     }
  //   }
  //   buffer.writeln();
  // }
  // print(buffer.toString());

  List<List<Point<int>>> iters = getMultiStepPoints(input);
  Set<Point<int>> rollPos = {};
  for (var iter in iters) {
    rollPos.addAll(iter);
  }
  print(rollPos.length);
  // StringBuffer altBuffer = StringBuffer();
  // for (var i = 0; i < input.length; i++) {
  //   for (var j = 0; j < input[i].length; j++) {
  //     if (rollPos.contains(Point(j, i))) {
  //       altBuffer.write("x");
  //     } else {
  //       altBuffer.write(input[i][j]);
  //     }
  //   }
  //   buffer.writeln();
  // }
  // print(buffer.toString());
}

List<List<Point<int>>> getMultiStepPoints(
  List<List<String>> input, {
  String rollMarker = "@",
  int maxCount = 4,
}) {
  List<List<Point<int>>> iterations = [];

  List<List<String>> currState = List.from(input);
  List<Point<int>> currIter = [];
  do {
    currIter = getMovingPoints(
      currState,
      rollMarker: rollMarker,
      maxCount: maxCount,
    );

    // StringBuffer buffer = StringBuffer();
    for (var i = 0; i < input.length; i++) {
      for (var j = 0; j < input[i].length; j++) {
        if (currIter.contains(Point(j, i))) {
          // buffer.write("x");
          currState[i][j] = "x";
        } else {
          // buffer.write(input[i][j]);
        }
      }
      // buffer.writeln();
    }

    if (currIter.isNotEmpty) {
      iterations.add(currIter);
    }
  } while (currIter.isNotEmpty);

  return iterations;
}

List<Point<int>> getMovingPoints(
  List<List<String>> input, {
  String rollMarker = "@",
  int maxCount = 4,
}) {
  List<Point<int>> points = [];

  for (var i = 0; i < input.length; i++) {
    for (var j = 0; j < input[i].length; j++) {
      if (input[i][j] != rollMarker) {
        continue;
      }
      List<Point<int>> surroundPoints = [];
      Point<int> point = Point(j, i);
      Point<int> checkPoint;
      // Check in the following order (x is the element in question):
      // 1 2 3
      // 4 x 5
      // 6 7 8
      List<Point<int>> offsets = [
        Point(-1, -1),
        Point(-1, 0),
        Point(-1, 1),
        Point(0, -1),
        // Point(0, 0),
        Point(0, 1),
        Point(1, -1),
        Point(1, 0),
        Point(1, 1),
      ];
      for (var offset in offsets) {
        checkPoint = point + offset;
        if (checkPoint.isValid(input[j].length, input.length) &&
            input[checkPoint.y][checkPoint.x] == rollMarker) {
          surroundPoints.add(checkPoint);
        }
      }

      if (surroundPoints.length < maxCount) {
        points.add(point);
      }
    }
  }

  return points;
}

extension PointValidity on Point<int> {
  bool isValid(int xLen, int yLen) {
    return ((x >= 0) && (x < xLen)) && ((y >= 0) && (y < yLen));
  }
}
