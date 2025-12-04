import 'dart:io';

import 'package:aoc_2025/chal_4/solve.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  test("P1 Sample", () {
    List<List<String>> input = (File(
      p.join("test", "chal_4", "input.txt"),
    ).readAsLinesSync()).map((l) => l.split("")).toList();

    expect(getMovingPoints(input).length, equals(13));
  });
  test("P2 Sample", () {
    List<List<String>> input = (File(
      p.join("test", "chal_4", "input.txt"),
    ).readAsLinesSync()).map((l) => l.split("")).toList();

    expect(getMultiStepPoints(input).length, equals(9));
  });
}
