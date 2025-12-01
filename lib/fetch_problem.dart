/// This library exists solely to be able to automatically fetch and download problems & input files for each day of AoC.
library;

import 'dart:io';

import 'package:html/dom.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import "package:path/path.dart" as p;

class Problem {
  final String title;
  final String question;
  final String? question2;
  final String input;

  const Problem({
    required this.title,
    required this.question,
    this.question2,
    required this.input,
  });

  /// Creates a folder named `lib/{prefix}_{day}` and writes problem to `problem.txt` and input to `input.txt`.
  Future<void> toDisk(int day, [String prefix = "chal_"]) async {
    String directoryName = "$prefix$day";
    Directory dir = Directory(p.joinAll(["lib", directoryName]));
    if (!(await dir.exists())) {
      dir = await dir.create();
    }

    File problemFile = File(p.joinAll(["lib", directoryName, "problem.md"]));
    if (!(await problemFile.exists())) {
      problemFile = await problemFile.create();
    }
    await problemFile.writeAsString("$title\n$question");

    if (question2 != null) {
      await problemFile.writeAsString(
        "\n-----\n$question2",
        mode: FileMode.append,
      );
    }

    File inputFile = File(p.joinAll(["lib", directoryName, "input.txt"]));
    if (!(await inputFile.exists())) {
      inputFile = await inputFile.create();
    }
    await inputFile.writeAsString(input);

    return;
  }
}

/// Gets the problem statement
Future<Problem> getProblem(int day, {int year = 2024}) async {
  String? token = await getTokenFromFile();
  if (token == null) {
    throw Exception("Login token missing!");
  }

  Map<String, String> headers = {
    "Cookie": "session=$token",
    "User-Agent":
        "[Personal Tool](https://github.com/BoseVJeff/aoc_2025/blob/main/lib/fetch_problem.dart) - BoseV Jefferson<jeffbvic003@gmail.com>",
  };

  Uri problemUri = Uri.parse("https://adventofcode.com/$year/day/$day");
  Uri inputUri = Uri.parse("https://adventofcode.com/$year/day/$day/input");

  //   Getting the problem statement
  Response problemRes = await get(problemUri, headers: headers);
  String body = problemRes.body;
  // String body = await File("day_1_ex.html").readAsString();

  Document rawHtml = parse(body);

  List<Element> problemElements = rawHtml.querySelectorAll(
    "body > main > article.day-desc",
  );

  String? title;
  String? question1;
  String? question2;

  if (problemElements.isEmpty) {
    throw Exception("Error getting problem statement!");
  }

  // At this point, atleast one question exists
  Element rawQues = problemElements[0];
  question1 = "";

  for (Element el in rawQues.children) {
    if (el.localName == "h2" && title == null) {
      title = elementToMarkdown(el);
    } else {
      question1 = "$question1${elementToMarkdown(el)}";
    }
  }

  // Checking if part 2 also exists
  if (problemElements.length > 1) {
    Element rawQues2 = problemElements[1];
    question2 = "";
    for (var el in rawQues2.children) {
      question2 = "$question2${elementToMarkdown(el)}";
    }
  }

  //   Getting the problem input
  Response inputRes = await get(inputUri, headers: headers);
  String input = inputRes.body;
  // String input = await File("day_1.txt").readAsString();

  return Problem(
    title: title ?? "",
    question: question1 ?? "",
    question2: question2,
    input: input,
  );
}

String elementToMarkdown(Element el, [Element? parent]) {
  String txt;
  if (el.nodes.isNotEmpty) {
    txt = el.nodes.map<String>((e) {
      if (e.nodeType == Node.TEXT_NODE) {
        return e.text ?? "";
      } else {
        return elementToMarkdown(e as Element, el);
      }
    }).join();
    // txt = el.children.map((e) => elementToMarkdown(e, el)).join();
  } else {
    txt = el.text;
  }
  switch (el.localName) {
    case "em":
      return "*$txt*";
    case "code":
      if (parent?.localName == "pre") {
        return "\n```\n$txt\n```\n\n";
      } else {
        return "`$txt`";
      }
    case "a":
      String link = el.attributes['href'] ?? "";
      Uri uri = Uri.https("adventofcode.com");
      uri = uri.resolve(link);
      return "[$txt]($uri)";
    case "pre":
      // TODO: Look into how exactly `pre` are generated from markdown outside of block code ticks
      return txt;
    case "li":
      if (parent?.localName == "ol") {
        // TODO: Implement this
        // Blocker: Get index of element in list
        throw UnimplementedError("Ordered lists unimplemented!");
      } else if (parent?.localName == "ul") {
        return "\n* $txt\n";
      } else {
        // return "\n* $txt\n";
        throw Exception("`li` has no direct `ol`/`ul` parent!");
      }
    case "ul":
      return txt;
    case "p":
      return "\n$txt\n";
    case "h1":
      return "\n# $txt\n";
    case "h2":
      return "\n## $txt\n";
    case "h3":
      return "\n### $txt\n";
    case "h4":
      return "\n#### $txt\n";
    case "h5":
      return "\n##### $txt\n";
    case "h6":
      return "\n###### $txt\n";
    default:
      return txt;
  }
}

/// Gets token from `token.env` in the project root
Future<String?> getTokenFromFile() async {
  File file = File("token.env");
  if (!(await file.exists())) {
    return null;
  }
  String txt = await file.readAsString();
  if (txt.isEmpty) {
    return null;
  }
  return txt;
}
