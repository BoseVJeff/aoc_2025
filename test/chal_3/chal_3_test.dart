import 'package:aoc_2025/chal_3/solve.dart';
import 'package:test/test.dart';

void main() {
  group("Sample Tests", () {
    test('987654321111111', () {
      expect(
        getJoltage("987654321111111".split("").map((c) => int.parse(c))),
        equals(98),
      );
    });
    test('811111111111119', () {
      expect(
        getJoltage("811111111111119".split("").map((c) => int.parse(c))),
        equals(89),
      );
    });
    test('234234234234278', () {
      expect(
        getJoltage("234234234234278".split("").map((c) => int.parse(c))),
        equals(78),
      );
    });
    test('818181911112111', () {
      expect(
        getJoltage("818181911112111".split("").map((c) => int.parse(c))),
        equals(92),
      );
    });
  });
  group("New Sample Tests", () {
    test('987654321111111', () {
      expect(
        getMaxJolt(
          "987654321111111".split("").map((c) => int.parse(c)).toList(),
          2,
        ),
        equals(98),
      );
    });
    test('811111111111119', () {
      expect(
        getMaxJolt(
          "811111111111119".split("").map((c) => int.parse(c)).toList(),
          2,
        ),
        equals(89),
      );
    });
    test('234234234234278', () {
      expect(
        getMaxJolt(
          "234234234234278".split("").map((c) => int.parse(c)).toList(),
          2,
        ),
        equals(78),
      );
    });
    test('818181911112111', () {
      expect(
        getMaxJolt(
          "818181911112111".split("").map((c) => int.parse(c)).toList(),
          2,
        ),
        equals(92),
      );
    });
  });
  group('Alt Tests', () {
    test(
      '3242323333312323243333333353413314243333232242233323431332332353323333353333333332443515323433322274',
      () {
        expect(
          getMaxJolt(
            "3242323333312323243333333353413314243333232242233323431332332353323333353333333332443515323433322274"
                .split("")
                .map((c) => int.parse(c))
                .toList(),
            2,
          ),
          equals(74),
        );
      },
    );
    test(
      '1221223532146222222223126712218222123621122123217221212222322221232621162221122222222222122561122292',
      () {
        expect(
          getMaxJolt(
            "1221223532146222222223126712218222123621122123217221212222322221232621162221122222222222122561122292"
                .split("")
                .map((c) => int.parse(c))
                .toList(),
            2,
          ),
          equals(92),
        );
      },
    );
    test(
      '1368838843358743334345324211363655364233733332443334321243322336412538532344213423253222366323263695',
      () {
        expect(
          getMaxJolt(
            "1368838843358743334345324211363655364233733332443334321243322336412538532344213423253222366323263695"
                .split("")
                .map((c) => int.parse(c))
                .toList(),
            2,
          ),
          equals(95),
        );
      },
    );
  });
  group("P2 Sample Tests", () {
    test('987654321111111', () {
      expect(
        getMaxJolt(
          "987654321111111".split("").map((c) => int.parse(c)).toList(),
          12,
        ),
        equals(987654321111),
      );
    });
    test('811111111111119', () {
      expect(
        getMaxJolt(
          "811111111111119".split("").map((c) => int.parse(c)).toList(),
          12,
        ),
        equals(811111111119),
      );
    });
    test('234234234234278', () {
      expect(
        getMaxJolt(
          "234234234234278".split("").map((c) => int.parse(c)).toList(),
          12,
        ),
        equals(434234234278),
      );
    });
    test('818181911112111', () {
      expect(
        getMaxJolt(
          "818181911112111".split("").map((c) => int.parse(c)).toList(),
          12,
        ),
        equals(888911112111),
      );
    });
  });
}
