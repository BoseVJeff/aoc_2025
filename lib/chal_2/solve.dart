import 'dart:io';

import 'package:path/path.dart';

Future<void> main(List<String> args) async {
  String input = await File(join("lib", "chal_2", "input.txt")).readAsString();
  Iterable<(int, int)> inputs = input
      .split(",")
      .map(
        (i) => (int.parse(i.split("-").first), int.parse(i.split("-").last)),
      );

  List<int> ids = [];
  List<int> id2 = [];
  for (var i in inputs) {
    ids.addAll(bf(i.$1, i.$2));
    id2.addAll(bfAll(i.$1, i.$2));
  }
  print("P1: ${ids.reduce((v, e) => v + e)}");
  print("P2: ${id2.reduce((v, e) => v + e)}");
}

Iterable<int> bf(int start, int end) =>
    List.generate(end - start + 1, (i) => start + i)
        .map((n) => n.toRadixString(10))
        .where(checkValidity2)
        .map((s) => int.parse(s));

Iterable<int> bfAll(int start, int end) =>
    List.generate(end - start + 1, (i) => start + i)
        .map((n) => n.toRadixString(10))
        .where(checkValidityAll)
        .map((s) => int.parse(s));

bool checkValidity2(String s) {
  return (s.length % 2 == 0) &&
      (s.substring(0, s.length ~/ 2) == s.substring(s.length ~/ 2));
}

bool checkValidityAll(String s) {
  int len = s.length;
  List<int> factors = getFactors(len);
  for (var n in factors) {
    if (n < len) {
      int cnt = len ~/ n;
      var other = (s.substring(0, n)) * cnt;
      if (s == other) {
        return true;
      }
    }
  }
  return false;
}

List<int> getFactors(int n) {
  List<int> factors = [];

  for (var i = 1; i <= n; i++) {
    if (n % i == 0) {
      factors.add(i);
    }
  }

  return factors;
}
