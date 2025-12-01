import 'package:aoc_2025/fetch_problem.dart';
import 'package:args/args.dart';

void main(List<String> arguments) async {
  ArgParser parser = ArgParser();

  parser.addOption(
    "day",
    abbr: "d",
    mandatory: true,
    valueHelp: "Day of Challenge",
  );

  parser.addOption(
    "year",
    abbr: "y",
    mandatory: false,
    defaultsTo: "2025",
    valueHelp: "Year of Challenge",
  );

  ArgResults res = parser.parse(arguments);

  int day = int.parse(res.option("day") ?? "");

  int year = int.parse(res.option("year") ?? "");

  print("Getting problem...");
  Problem problem = await getProblem(day, year: year);
  print("Writing problems to disk...");
  await problem.toDisk(day);

  print("Done! Problem: ${problem.title.replaceFirst("## ", "").trim()}");
  if (problem.question2 != null) {
    print("Part 2 available!");
  }
}
