import 'dart:io';

import 'package:collection/collection.dart';
import 'package:path/path.dart';

Future<void> main(List<String> args) async {
  List<String> lines = await File(
    join("lib", "chal_6", "input.txt"),
  ).readAsLines();

  String opsRaw = lines.removeLast();

  Iterable<Iterable<int>> nums = lines.map((line) => parseLines(line));
  List<Op> ops = parseOps(opsRaw).toList(growable: false);

  List<int> ans = [];
  for (var i = 0; i < ops.length; i++) {
    List<int> ques = nums
        .map((set) => set.elementAt(i))
        .toList(growable: false);
    ans.add(ops[i].evaluate(ques));
  }
  print(ans.reduce((v, e) => v + e));
  // print(ans);

  // --------
  // Part 2
  List<String> rawLines = await File(
    join("lib", "chal_6", "input.txt"),
  ).readAsLines();

  List<List<int>> numsP2 = parseLines2(rawLines);
  List<int> ansP2 = [];
  for (var i = 0; i < ops.length; i++) {
    List<int> ques = numsP2[i];
    ansP2.add(ops[i].evaluate(ques));
  }
  print(ansP2.reduce((v, e) => v + e));
  // print(ansP2);
}

Iterable<int> parseLines(String line) =>
    line.split(" ").map((n) => int.tryParse(n.trim())).nonNulls;

List<List<int>> parseLines2(List<String> l) {
  List<List<String>> lines = l.map((line) => line.split("")).toList();
  String opsLine = lines.removeLast().join("");

  int height = lines.length;
  int width = lines.first.length;

  List<String> parts = opsLine.split("");
  List<int> opsPos = parts.indexed
      .where((e) => e.$2 != " ")
      .map((e) => e.$1)
      .toList(growable: false);

  List<List<int>> sets = [];
  for (var i = 0; i < opsPos.length; i++) {
    int start = opsPos[i];
    int end =
        (opsPos.elementAtOrNull(i + 1) ?? width + 1) -
        1; // TODO: Check terminal case
    List<int> nums = [];

    for (int j = start; j < end; j++) {
      String num = lines.map((line) => line[j]).join("");
      if (num.isEmpty) {
        num = "0";
      }
      nums.add(int.parse(num));
    }
    sets.add(nums);
  }
  return sets;
}

Iterable<Op> parseOps(String line) =>
    line.split(" ").map((n) => Op.fromString(n.trim())).nonNulls;

enum Op {
  add("+"),
  mul("*");

  final String str;
  const Op(this.str);

  static Op? fromString(String s) =>
      Op.values.firstWhereOrNull((o) => o.str == s);

  int evaluate(List<int> nums) {
    int res;
    switch (this) {
      case Op.add:
        res = nums.reduce((v, e) => v + e);
      case Op.mul:
        res = nums.reduce((v, e) => v * e);
    }
    return res;
  }
}
