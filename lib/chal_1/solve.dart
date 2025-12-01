import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  File input = File(p.join("lib", "chal_1", "input.txt"));
  List<String> inputs = (await input.readAsLines());
  Iterable<Rotation> rotations = Rotation.fromInputs(inputs);

  int pos = 50;
  int p2Cnt = 0;
  int p1Cnt = 0;

  for (var r in rotations) {
    // pos = pos.applyRotation(r);
    var tmp = Rotation.countClicks(pos, r);
    pos = tmp.newPos;
    if (pos == 0) {
      p1Cnt++;
    }
    p2Cnt += tmp.clicks;
  }

  print("[$pos] P1: $p1Cnt | P2: $p2Cnt");
}

enum Direction { left, right }

class Rotation extends Equatable {
  final Direction direction;
  final int distance;

  const Rotation(this.direction, this.distance);

  static Iterable<Rotation> fromInputs(Iterable<String> inputs) =>
      inputs.map((i) => Rotation.fromString(i.trim()));

  factory Rotation.fromString(String input) {
    String dirRaw = input.substring(0, 1);
    String distRaw = input.substring(1);

    Direction direction;
    int distance;
    switch (dirRaw) {
      case "L":
        direction = Direction.left;
        break;
      case "R":
        direction = Direction.right;
        break;
      default:
        throw FormatException("Invalid directrion $dirRaw", input, 0);
    }

    distance = int.parse(distRaw);
    // Not needed
    // if (distance < 0) {
    //   throw FormatException(
    //     "Distance must be between 0 and 99, recieved $distance",
    //     input,
    //     1,
    //   );
    // }
    // if (distance > 99) {
    //   print("[$input] Distance is bigger than expected. Trimming...");
    //   distance = (distance ~/ 10);
    // }

    return Rotation(direction, distance);
  }

  @override
  String toString() {
    switch (direction) {
      case Direction.left:
        return "L${distance.toRadixString(10)}";
      case Direction.right:
        return "R${distance.toRadixString(10)}";
    }
  }

  @override
  List<Object?> get props => [direction, distance];

  static int getNewPosition(int pos, Rotation rotation) {
    int newPos;
    if (rotation.direction == Direction.left) {
      // To simply handling for negatives
      newPos = pos - rotation.distance;
    } else {
      newPos = pos + rotation.distance;
    }
    newPos = newPos % 100;
    return newPos;
  }

  static ({int newPos, int clicks}) countClicks(int oldPos, Rotation rotation) {
    int clicks = rotation.distance ~/ 100;
    int newPos = oldPos.applyRotation(rotation);
    if (rotation.direction == Direction.left && newPos > oldPos) {
      clicks++;
    }
    if (rotation.direction == Direction.right && newPos < oldPos) {
      clicks++;
    }

    return (newPos: newPos, clicks: clicks);
  }
}

extension SafeRotation on int {
  int applyRotation(Rotation rotation) =>
      Rotation.getNewPosition(this, rotation);
}
