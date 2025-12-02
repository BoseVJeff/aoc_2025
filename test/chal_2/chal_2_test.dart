import 'package:aoc_2025/chal_2/solve.dart';
import 'package:test/test.dart';

void main() {
  group("Test Repeating digits", () {
    test('11-22', () {
      expect(bf(11, 22), orderedEquals([11, 22]));
    });
    test('95-115', () {
      expect(bf(95, 115), orderedEquals([99]));
    });
    test('998-1012', () {
      expect(bf(998, 1012), orderedEquals([1010]));
    });
    test('1188511880-1188511890', () {
      expect(bf(1188511880, 1188511890), orderedEquals([1188511885]));
    });
  });
  group("P2 Repeating digits", () {
    test('11-22', () {
      expect(bfAll(11, 22), orderedEquals([11, 22]));
    });
    test('95-115', () {
      expect(bfAll(95, 115), orderedEquals([99, 111]));
    });
    test('998-1012', () {
      expect(bfAll(998, 1012), orderedEquals([999, 1010]));
    });
    test('1188511880-1188511890', () {
      expect(bfAll(1188511880, 1188511890), orderedEquals([1188511885]));
    });
  });
  group("Test Facstorization", () {
    test("7", () {
      expect(getFactors(7), orderedEquals([1, 7]));
    });
    test("21", () {
      expect(getFactors(21), orderedEquals([1, 3, 7, 21]));
    });
  });
}
