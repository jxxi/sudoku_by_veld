import 'dart:io';

/// Downloads bundled font files (OFL-licensed Fraunces + DM Sans from Google Fonts).
Future<void> main() async {
  const fonts = <String, String>{
    'Fraunces-SemiBold.ttf':
        'https://fonts.gstatic.com/s/fraunces/v38/6NUh8FyLNQOQZAnv9bYEvDiIdE9Ea92uemAk_WBq8U_9v0c2Wa0K7iN7hzFUPJH58nib1603gg7S2nfgRYIcaRyjDg.ttf',
    'DMSans-Regular.ttf':
        'https://fonts.gstatic.com/s/dmsans/v17/rP2tp2ywxg089UriI5-g4vlH9VoD8CmcqZG40F9JadbnoEwAopxhTg.ttf',
    'DMSans-SemiBold.ttf':
        'https://fonts.gstatic.com/s/dmsans/v17/rP2tp2ywxg089UriI5-g4vlH9VoD8CmcqZG40F9JadbnoEwAfJthTg.ttf',
  };

  final dir = Directory('assets/fonts');
  await dir.create(recursive: true);

  final client = HttpClient();
  try {
    for (final entry in fonts.entries) {
      final file = File('${dir.path}/${entry.key}');
      stdout.writeln('Downloading ${entry.key}...');
      final request = await client.getUrl(Uri.parse(entry.value));
      final response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        stderr.writeln('Failed ${entry.key}: HTTP ${response.statusCode}');
        exitCode = 1;
        continue;
      }
      final bytes = await response.fold<List<int>>(
        <int>[],
        (previous, element) => previous..addAll(element),
      );
      await file.writeAsBytes(bytes);
      stdout.writeln('Wrote ${file.path} (${bytes.length} bytes)');
    }
  } finally {
    client.close();
  }
}
