import 'dart:io';

import 'package:aoc_2025/chal_5/solve.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  test("Input parsing", () {
    List<String> input = File(
      p.join("test", "chal_5", "input.txt"),
    ).readAsLinesSync();
    var parsed = parseInput(input);
    expect(
      parsed.ranges,
      equals([Range(3, 5), Range(10, 14), Range(16, 20), Range(12, 18)]),
    );
    expect(parsed.nums, equals([1, 5, 8, 11, 17, 32]));
  });
  group('Range Merges', () {
    test("12-18 | 16-20", () {
      Range r1 = Range(12, 18);
      Range r2 = Range(16, 20);
      Range? merge = r1.merge(r2);
      expect(merge, isNotNull);
      expect(merge, equals(Range(12, 20)));
    });
    test("12-18 | 16-20 - Reversed", () {
      Range r1 = Range(12, 18);
      Range r2 = Range(16, 20);
      Range? merge = r2.merge(r1);
      expect(merge, isNotNull);
      expect(merge, equals(Range(12, 20)));
    });
    test("12-21 | 16-20", () {
      Range r1 = Range(12, 21);
      Range r2 = Range(16, 20);
      Range? merge = r1.merge(r2);
      expect(merge, isNotNull);
      expect(merge, equals(Range(12, 21)));
    });
    test("12-20 | 11-24", () {
      Range r1 = Range(11, 18);
      Range r2 = Range(16, 24);
      Range? merge = r1.merge(r2);
      expect(merge, isNotNull);
      expect(merge, equals(Range(11, 24)));
    });
    test("[12-18, 16-20]", () {
      Range r1 = Range(12, 18);
      Range r2 = Range(16, 20);
      List<Range> merge = [r1, r2].merge();
      expect(merge, equals([Range(12, 20)]));
    });
    test("[3-5, 10-14, 12-18, 16-20]", () {
      Range r1 = Range(3, 5);
      Range r2 = Range(10, 14);
      Range r3 = Range(12, 18);
      Range r4 = Range(16, 20);
      List<Range> merge = [r1, r2, r3, r4].merge();
      expect(merge, equals([Range(3, 5), Range(10, 20)]));
    });
    test("[1-3, 3-5, 6-7]", () {
      Range r1 = Range(1, 3);
      Range r2 = Range(3, 5);
      Range r3 = Range(6, 7);
      List<Range> merge = [r1, r2, r3];
      merge.sort();
      merge = merge.merge();
      expect(merge, equals([Range(1, 5), Range(6, 7)]));
    });
    test("[1-10, 1-10]", () {
      Range r1 = Range(1, 10);
      Range r2 = Range(1, 10);
      List<Range> merge = [r1, r2];
      merge.sort();
      merge = merge.merge();
      expect(merge, equals([Range(1, 10)]));
    });
    test("[32657821999605-38449441060726,32657821999605-34947413077130]", () {
      Range r1 = Range(32657821999605, 38449441060726);
      Range r2 = Range(32657821999605, 34947413077130);
      List<Range> merge = [r1, r2];
      merge.sort();
      merge = merge.merge();
      expect(merge, equals([Range(32657821999605, 38449441060726)]));
    });
    group('Leetcode', () {
      test('[1,3],[2,6],[8,10],[15,18]', () {
        List<Range> ranges = [
          Range(1, 3),
          Range(2, 6),
          Range(8, 10),
          Range(15, 18),
        ];
        ranges = ranges.merge();
        expect(ranges, equals([Range(1, 6), Range(8, 10), Range(15, 18)]));
      });
      test('[4,7],[1,4]', () {
        List<Range> ranges = [Range(4, 7), Range(1, 4)];
        ranges = ranges.merge();
        expect(ranges, equals([Range(1, 7)]));
      });
    });
    test('1-20, 5-9, 8-30', () {
      List<Range> ranges = [Range(1, 20), Range(5, 9), Range(8, 30)];
      ranges = ranges.merge();
      expect(ranges, equals([Range(1, 30)]));
    });
    test('3-5, 10-14, 16-20, 9-21', () {
      List<Range> ranges = [
        Range(3, 5),
        Range(10, 14),
        Range(16, 20),
        Range(9, 21),
      ];
      ranges = ranges.merge();
      expect(ranges, equals([Range(3, 5), Range(9, 21)]));

      int size = 0;
      for (var r in ranges) {
        size += r.size;
      }

      expect(size, 16);
    });
    test('External Test Case', () {
      String input =
          """
200-300
100-101
1-1
2-2
3-3
1-3
1-3
2-2
50-70
10-10
98-99
99-99
99-99
99-100
1-1
2-1
100-100
100-100
100-101
200-300
201-300
202-300
250-251
98-99
100-100
100-101
1-101"""
              .trim();

      List<Range> ranges = input
          .split("\n")
          .map((l) => Range.fromString(l.trim()))
          .toList();
      ranges.sort();
      ranges = ranges.merge();

      int size = 0;
      for (var r in ranges) {
        size += r.size;
      }

      expect(size, 202);
    });
  });
}
