import 'dart:io';
import 'dart:math';

import 'package:path/path.dart';

Future<void> main(List<String> args) async {
  Iterable<Iterable<int>> input = (await File(
    join("lib", "chal_3", "input.txt"),
  ).readAsLines()).map((l) => l.split("").map((c) => int.parse(c)));

  Iterable<int> jolts = input.map((l) => getMaxJolt(l.toList(), 2));
  Iterable<int> extraJolts = input.map((l) => getMaxJolt(l.toList(), 12));

  int sum = jolts.reduce((v, e) => v + e);
  int exSum = extraJolts.reduce((v, e) => v + e);

  print("P1: $sum | P2: $exSum");
}

int getMaxJolt(List<int> jolts, int count) {
  // Get the largest number in the list and its position
  int maxDigit = jolts.take(jolts.length - count + 1).reduce(max);
  int maxDigitIdx = jolts.indexOf(maxDigit);

  // Get all digits after maxDigitIdx, with atleast count digits in total
  List<int> smallJolts = jolts.sublist(min(maxDigitIdx, jolts.length - count));

  // If exactly enough elements are present, no further work needed
  if (smallJolts.length == count) {
    return int.parse(smallJolts.map((n) => n.toRadixString(10)).join(""));
  }

  // Get length-count smallest jolts to remove
  List<int> bottomJolts = List.from(
    smallJolts,
    growable: false,
  ); // Ensuring copy
  bottomJolts.sort();
  bottomJolts = bottomJolts.take(bottomJolts.length - count).toList();

  // Remove the smallest jolts
  for (var jolt in bottomJolts) {
    smallJolts.remove(jolt);
  }

  return int.parse(smallJolts.map((n) => n.toRadixString(10)).join(""));
}

int getJoltage(Iterable<int> volts) {
  int tensDigit = 0;
  int? onesDigit;
  int prevNum = 0;
  int prevNumMutated = 0;

  for (int digit in volts) {
    if (digit >= tensDigit) {
      if (onesDigit != null) {
        prevNum = (tensDigit * 10) + onesDigit;
        prevNumMutated = (tensDigit * 10) + digit;
      } else {
        prevNumMutated = (tensDigit * 10) + digit;
      }
      tensDigit = digit;
      onesDigit = null;
    } else if (onesDigit != null) {
      if (digit >= onesDigit) {
        onesDigit = digit;
      }
    } else {
      onesDigit = digit;
    }
  }

  if (onesDigit == null) {
    return max(prevNum, prevNumMutated);
  } else {
    int num = (tensDigit * 10) + onesDigit;
    if (num > prevNum) {
      return max(num, prevNumMutated);
    } else {
      return max(prevNum, prevNumMutated);
    }
  }
}
