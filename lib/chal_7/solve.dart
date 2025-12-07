import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:path/path.dart';

Future<void> main(List<String> args) async {
  File file = File(join("lib", "chal_7", "input.txt"));
  List<List<String>> lines = (await file.readAsLines())
      .map((l) => l.split(""))
      .toList();

  var beams = getBeams(lines);
  print(beams.splitsCnt);
  print(beams.beams.last.fold<int>(0, (v, e) => v + e.routes));
}

({List<List<Beam>> beams, int splitsCnt}) getBeams(
  List<List<String>> manifold, [
  int? limit,
]) {
  List<List<Beam>> beams = [];
  int splitsCount = 0;

  List<Beam>? beam;
  int maxLines = manifold.length;
  if (limit != null) {
    maxLines = min(limit, manifold.length);
  }
  for (var i = 0; i < maxLines; i++) {
    List<String> line = manifold[i];
    var trackBeam2 = trackBeam(line, beam ?? <Beam>[]);
    splitsCount += trackBeam2.splitsCnt;
    beam = trackBeam2.beam;
    beams.add(beam);
  }

  return (beams: beams, splitsCnt: splitsCount);
}

({List<Beam> beam, int splitsCnt}) trackBeam(
  List<String> line, [
  List<Beam> prevPos = const <Beam>[],
]) {
  List<Beam> nextPos = [];
  int splitCount = 0;

  if (prevPos.isEmpty) {
    // Next line ray is at source
    nextPos.add(Beam(line.indexOf("S"), 1));
  } else {
    // Check for splitters
    List<int> splitters = line
        .mapIndexed<int?>((i, e) {
          if (e == "^") {
            return i;
          } else {
            return null;
          }
        })
        .nonNulls
        .toList();

    if (splitters.isEmpty) {
      // Beams travel as is in case of no splitters
      nextPos.addAll(prevPos);
    } else {
      // Split beams
      for (Beam beam in prevPos) {
        // Check if beam should split
        if (splitters.contains(beam.pos)) {
          // Assuming that the negative case does not happen
          nextPos.addAll([
            Beam(beam.pos - 1, beam.routes),
            Beam(beam.pos + 1, beam.routes),
          ]);
          splitCount++;
        } else {
          // Pass through
          nextPos.add(beam);
        }
      }
      // Removing duplicates
      // nextPos = nextPos.toSet().toList(growable: false);
      // var deduped = getDupes(nextPos);
      // nextPos = deduped.uniques;
      nextPos = mergeBeams(nextPos);
    }
  }

  return (beam: nextPos, splitsCnt: splitCount);
}

List<Beam> mergeBeams(List<Beam> beams) {
  List<Beam> combinedBeams = [];

  for (Beam beam in beams) {
    Beam? existingBeam = combinedBeams.firstWhereOrNull(
      (b) => b.pos == beam.pos,
    );
    if (existingBeam == null) {
      // First beam in current position
      combinedBeams.add(beam);
    } else {
      // Beam already exists in this position
      // Combine probablities
      combinedBeams.remove(existingBeam);
      combinedBeams.add(Beam(beam.pos, beam.routes + existingBeam.routes));
    }
  }

  return combinedBeams;
}

({List<T> uniques, List<T> duplicates}) getDupes<T>(List<T> list) {
  List<T> uniques = [];
  List<T> duplicates = [];

  for (var n in list) {
    if (uniques.contains(n)) {
      duplicates.add(n);
    } else {
      uniques.add(n);
    }
  }

  return (uniques: uniques, duplicates: duplicates);
}

class Beam extends Equatable {
  final int pos;
  final int routes;

  const Beam(this.pos, this.routes);

  @override
  List<Object?> get props => [pos, routes];
}
