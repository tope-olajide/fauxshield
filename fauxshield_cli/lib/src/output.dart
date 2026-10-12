import 'dart:convert';
import 'dart:io';

/// Writes a fixed width table to stdout.
void printTable(List<String> headers, List<List<String>> rows) {
  if (rows.isEmpty) {
    stdout.writeln('No results.');
    return;
  }

  final widths = List<int>.generate(
    headers.length,
    (index) => headers[index].length,
  );
  for (final row in rows) {
    for (var i = 0; i < headers.length && i < row.length; i++) {
      if (row[i].length > widths[i]) widths[i] = row[i].length;
    }
  }

  String line(List<String> cells) {
    final buffer = StringBuffer();
    for (var i = 0; i < headers.length; i++) {
      final cell = i < cells.length ? cells[i] : '';
      buffer.write(cell.padRight(widths[i]));
      if (i < headers.length - 1) buffer.write('  ');
    }
    return buffer.toString().trimRight();
  }

  stdout.writeln(line(headers));
  stdout.writeln(
    widths.map((width) => '-' * width).join('  ').trimRight(),
  );
  for (final row in rows) {
    stdout.writeln(line(row));
  }
}

/// Writes pretty printed JSON to stdout.
void printJson(Object? value) {
  stdout.writeln(const JsonEncoder.withIndent('  ').convert(value));
}

/// Asks before something that cannot be undone.
///
/// Scripts pass `--yes` instead of answering; when stdin is not a terminal the
/// prompt cannot be shown, so the answer is no rather than a hang.
bool confirmDestructive(bool skip, String prompt) {
  if (skip) return true;
  if (!stdin.hasTerminal) {
    stdout.writeln('$prompt\nRefusing without a terminal: pass --yes.');
    return false;
  }
  stdout.writeln(prompt);
  stdout.write('Type `yes` to continue: ');
  final answer = stdin.readLineSync()?.trim().toLowerCase();
  return answer == 'yes' || answer == 'y';
}

/// Trims a long value so a table row stays readable.
String shorten(String? value, {int max = 38}) {
  if (value == null || value.isEmpty) return '-';
  final flat = value.replaceAll('\n', ' ');
  if (flat.length <= max) return flat;
  return '${flat.substring(0, max - 1).trimRight()}…';
}

/// Formats a timestamp for a terminal.
String formatTime(DateTime? value) {
  if (value == null) return '-';
  final local = value.toLocal();
  String two(int number) => number.toString().padLeft(2, '0');
  return '${local.year}-${two(local.month)}-${two(local.day)} '
      '${two(local.hour)}:${two(local.minute)}';
}

/// Renders a yes/no pair for tables.
String yesNo(bool value) => value ? 'yes' : 'no';
