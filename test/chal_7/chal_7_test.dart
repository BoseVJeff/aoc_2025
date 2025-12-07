import 'dart:io';

import 'package:aoc_2025/chal_7/solve.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group("Sample test", () {
    File file = File(p.join("test", "chal_7", "input.txt"));
    List<List<String>> lines = file
        .readAsLinesSync()
        .map((l) => l.split(""))
        .toList();
    test('Locate Source', () {
      List<Beam> beams = trackBeam(lines.first).beam;
      expect(beams, equals([Beam(7, 1)]));
    });
    test('First Propogation', () {
      List<Beam> beams = trackBeam(lines[0]).beam;
      beams = trackBeam(lines[1], beams).beam;
      expect(beams, equals([Beam(7, 1)]));
    });
    test('First Split', () {
      List<Beam> beams = trackBeam(lines[0]).beam;
      beams = trackBeam(lines[1], beams).beam;
      beams = trackBeam(lines[2], beams).beam;
      expect(beams, equals([Beam(6, 1), Beam(8, 1)]));
    });
    test('Second propogation', () {
      List<Beam> beams = trackBeam(lines[0]).beam;
      beams = trackBeam(lines[1], beams).beam;
      beams = trackBeam(lines[2], beams).beam;
      beams = trackBeam(lines[3], beams).beam;
      expect(beams, equals([Beam(6, 1), Beam(8, 1)]));
    });
    test('Second Split', () {
      List<Beam> beams = trackBeam(lines[0]).beam;
      beams = trackBeam(lines[1], beams).beam;
      beams = trackBeam(lines[2], beams).beam;
      beams = trackBeam(lines[3], beams).beam;
      beams = trackBeam(lines[4], beams).beam;
      expect(beams, equals([Beam(5, 1), Beam(7, 2), Beam(9, 1)]));
    });
  });
  group("Sample test neu", () {
    File file = File(p.join("test", "chal_7", "input.txt"));
    List<List<String>> lines = file
        .readAsLinesSync()
        .map((l) => l.split(""))
        .toList();
    test('Locate Source', () {
      List<List<Beam>> beams = getBeams(lines, 1).beams;
      expect(
        beams,
        equals([
          [Beam(7, 1)],
        ]),
      );
    });
    test('First Propogation', () {
      List<List<Beam>> beams = getBeams(lines, 2).beams;
      expect(
        beams,
        equals([
          [Beam(7, 1)],
          [Beam(7, 1)],
        ]),
      );
    });
    test('First Split', () {
      List<List<Beam>> beams = getBeams(lines, 3).beams;
      expect(
        beams,
        equals([
          [Beam(7, 1)],
          [Beam(7, 1)],
          [Beam(6, 1), Beam(8, 1)],
        ]),
      );
    });
    test('Second propogation', () {
      List<List<Beam>> beams = getBeams(lines, 4).beams;
      expect(
        beams,
        equals([
          [Beam(7, 1)],
          [Beam(7, 1)],
          [Beam(6, 1), Beam(8, 1)],
          [Beam(6, 1), Beam(8, 1)],
        ]),
      );
    });
    test('Second Split', () {
      List<List<Beam>> beams = getBeams(lines, 5).beams;
      expect(
        beams,
        equals([
          [Beam(7, 1)],
          [Beam(7, 1)],
          [Beam(6, 1), Beam(8, 1)],
          [Beam(6, 1), Beam(8, 1)],
          [Beam(5, 1), Beam(7, 2), Beam(9, 1)],
        ]),
      );
    });
    test('Full Traversal', () {
      var beams = getBeams(lines);
      expect(beams.beams.last.length, equals(9));
      expect(beams.splitsCnt, equals(21));
      expect(beams.beams.last.fold<int>(0, (v, e) => v + e.routes), equals(40));
    });
  });
  group('Beam Merge', () {
    test('(7,2),(6,9)', () {
      expect(
        mergeBeams([Beam(7, 2), Beam(6, 9)]),
        equals([Beam(7, 2), Beam(6, 9)]),
      );
    });
    test('(7,2),(7,9)', () {
      expect(mergeBeams([Beam(7, 2), Beam(7, 9)]), equals([Beam(7, 11)]));
    });
  });
}
