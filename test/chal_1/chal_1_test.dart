import 'dart:io';

import 'package:aoc_2025/chal_1/solve.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group("Parse", () {
    test("R8", () {
      expect(Rotation.fromString("R8"), equals(Rotation(Direction.right, 8)));
    });
    test("L19", () {
      expect(Rotation.fromString("L19"), equals(Rotation(Direction.left, 19)));
    });
    test("L192", () {
      expect(
        Rotation.fromString("L192"),
        equals(Rotation(Direction.left, 192)),
      );
    });
  });
  group("Round Trip", () {
    test("R8", () {
      expect(Rotation.fromString("R8").toString(), equals("R8"));
    });
    test("L19", () {
      expect(Rotation.fromString("L19").toString(), equals("L19"));
    });
  });
  group('Clicks', () {
    test("50 -> R1000", () {
      expect(
        Rotation.countClicks(50, Rotation.fromString("R1000")).clicks,
        equals(10),
      );
    });
    test("50 -> L68", () {
      expect(
        Rotation.countClicks(50, Rotation.fromString("L68")).clicks,
        equals(1),
      );
    });
  });
  test("Sample Problem", () {
    Iterable<Rotation> inputs = File(
      p.join("test", "chal_1", "input.txt"),
    ).readAsLinesSync().map((i) => Rotation.fromString(i));
    int initPos = 50;

    for (var r in inputs) {
      initPos = initPos.applyRotation(r);
    }

    expect(initPos, 32);
  });
}
