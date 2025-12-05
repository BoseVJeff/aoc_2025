import 'dart:io';
import 'dart:math';

import 'package:path/path.dart';

Future<void> main(List<String> args) async {
  List<String> lines = await File(
    join("lib", "chal_5", "input.txt"),
  ).readAsLines();

  ({List<Range> ranges, List<int> nums}) input = parseInput(lines);

  Map<int, Iterable<Range>> counts = Map.fromEntries(
    input.nums.asMap().entries.map(
      (e) => MapEntry(e.value, input.ranges.where((r) => r.has(e.value))),
    ),
  );

  Iterable<MapEntry<int, Iterable<Range>>> fresh = counts.entries.where(
    (i) => i.value.isNotEmpty,
  );

  print(fresh.length);
  print(fresh);

  List<Range> mergedRanges = fresh
      .map((e) => e.value)
      .fold<Iterable<Range>>(
        [],
        (previousValue, element) => previousValue.followedBy(element),
      )
      .toSet()
      .toList();
  mergedRanges.sort();
  print(mergedRanges.join("\n"));
  print("--------");
  mergedRanges = mergedRanges.merge();
  print(mergedRanges.join("\n"));
  int size = 0;
  for (var r in mergedRanges) {
    size += r.size;
  }
  print(size);
  // print(ids.toList()..sort());
}

({List<Range> ranges, List<int> nums}) parseInput(List<String> lines) {
  int splitIdx = lines.indexOf("");
  List<String> rangesRaw = lines.sublist(0, splitIdx);
  List<String> valuesRaw = lines.sublist(splitIdx + 1);

  List<Range> ranges = rangesRaw
      .map((s) => Range.fromString(s))
      .toList(growable: false);
  List<int> nums = valuesRaw
      .map((s) => int.parse(s.trim()))
      .toList(growable: false);

  return (ranges: ranges, nums: nums);
}

class Range implements Comparable<Range> {
  final int start;
  final int end;

  const Range(this.start, this.end);

  bool has(int n) => (n >= start) && (n <= end);

  Range? merge(Range r) {
    Range? range;
    if (r.has(start) || r.has(end) || has(r.start) || has(r.end)) {
      range = Range(min(start, r.start), max(end, r.end));
    }
    return range;
  }

  factory Range.fromString(String s) {
    String sep = "-";
    List<String> parts = s
        .split(sep)
        .map((p) => p.trim())
        .toList(growable: false);

    return Range(int.parse(parts[0]), int.parse(parts[1]));
  }

  @override
  String toString() {
    return "${start.toRadixString(10)}-${end.toRadixString(10)}";
  }

  Iterable<int> possibleIds() sync* {
    for (var i = start; i <= end; i++) {
      yield i;
    }
    return;
  }

  int get size => end - start + 1;

  @override
  int get hashCode => start.hashCode | end.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is! Range) {
      return false;
    }
    return (start == other.start) && (end == other.end);
  }

  @override
  int compareTo(Range other) {
    return start.compareTo(other.start);
  }
}

extension MergeRanges on List<Range> {
  List<Range> merge() {
    if (isEmpty) {
      return [];
    }
    List<Range> l = List.from(this);
    l.sort();
    int i = 0;
    while (i < l.length - 1) {
      Range cur = l[i];
      Range mergeTarget = l[i + 1];
      Range? res = cur.merge(mergeTarget);
      if (res != null) {
        l.removeWhere((r) => r == cur || r == mergeTarget);
        l.add(res);
        l.sort();
      } else {
        i++;
      }
    }

    return l;
  }
}
