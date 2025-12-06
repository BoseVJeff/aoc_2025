import 'dart:io';

import 'package:aoc_2025/chal_6/solve.dart';
import 'package:test/test.dart';

import 'package:path/path.dart' as p;

void main() {
  group("Parsing", () {
    test('Sample Input', () {
      List<String> lines = File(
        p.join("test", "chal_6", "input.txt"),
      ).readAsLinesSync();

      String opsRaw = lines.removeLast();

      List<List<int>> nums = lines
          .map((line) => parseLines(line).toList())
          .toList();
      List<Op> ops = parseOps(opsRaw).toList(growable: false);
      expect(
        nums,
        equals([
          [123, 328, 51, 64],
          [45, 64, 387, 23],
          [6, 98, 215, 314],
        ]),
      );
      expect(ops, equals([Op.mul, Op.add, Op.mul, Op.add]));
    });
    test('Sample Input P2', () {
      List<String> lines = File(
        p.join("test", "chal_6", "input.txt"),
      ).readAsLinesSync();

      List<List<int>> nums = parseLines2(lines);
      expect(
        nums,
        equals([
          [1, 24, 356],
          [369, 248, 8],
          [32, 581, 175],
          [623, 431, 4],
        ]),
      );
    });
  });
}
