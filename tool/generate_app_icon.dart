import 'dart:io';

import 'package:image/image.dart';

/// Same partial grid as [HomePuzzlePreview].
const _givens =
    '530070000600195000098000060800060003409008001700020006000601008401905000803000079';

void main() {
  const size = 1024;
  const padding = 112;
  const gridSize = size - padding * 2;
  final cell = gridSize / 9;

  final image = Image(width: size, height: size);
  final background = ColorRgb8(244, 240, 230);
  final surface = ColorRgb8(232, 226, 212);
  final surfaceMuted = ColorRgb8(217, 210, 195);
  final gridLine = ColorRgb8(217, 210, 195);
  final blockLine = ColorRgb8(168, 152, 136);
  final ink = ColorRgb8(61, 58, 50);

  fill(image, color: background);

  final gridLeft = padding;
  final gridTop = padding;

  fillRect(
    image,
    x1: gridLeft,
    y1: gridTop,
    x2: gridLeft + gridSize,
    y2: gridTop + gridSize,
    color: surfaceMuted,
  );

  for (var row = 0; row < 9; row++) {
    for (var col = 0; col < 9; col++) {
      final x = (gridLeft + col * cell).round();
      final y = (gridTop + row * cell).round();
      final x2 = (gridLeft + (col + 1) * cell).round();
      final y2 = (gridTop + (row + 1) * cell).round();
      fillRect(image, x1: x, y1: y, x2: x2, y2: y2, color: surface);
    }
  }

  for (var i = 1; i < 9; i++) {
    final isBlock = i % 3 == 0;
    final thickness = isBlock ? 4 : 2;
    final color = isBlock ? blockLine : gridLine;
    final y = (gridTop + i * cell).round() - thickness ~/ 2;
    final x = (gridLeft + i * cell).round() - thickness ~/ 2;
    fillRect(
      image,
      x1: gridLeft,
      y1: y,
      x2: gridLeft + gridSize,
      y2: y + thickness,
      color: color,
    );
    fillRect(
      image,
      x1: x,
      y1: gridTop,
      x2: x + thickness,
      y2: gridTop + gridSize,
      color: color,
    );
  }

  drawRect(
    image,
    x1: gridLeft,
    y1: gridTop,
    x2: gridLeft + gridSize,
    y2: gridTop + gridSize,
    color: blockLine,
    thickness: 6,
  );

  final font = arial48;
  for (var row = 0; row < 9; row++) {
    for (var col = 0; col < 9; col++) {
      final digit = int.parse(_givens[row * 9 + col]);
      if (digit == 0) continue;

      final text = '$digit';
      final textWidth = _textWidth(font, text);
      final cx = gridLeft + col * cell + cell / 2;
      final cy = gridTop + row * cell + cell / 2;
      drawString(
        image,
        text,
        font: font,
        x: (cx - textWidth / 2).round(),
        y: (cy - font.lineHeight / 2).round(),
        color: ink,
      );
    }
  }

  final outDir = Directory('assets/icon');
  outDir.createSync(recursive: true);
  final outFile = File('assets/icon/app_icon.png');
  outFile.writeAsBytesSync(encodePng(image));
  stdout.writeln('Wrote ${outFile.path}');
  stdout.writeln('Run: dart run flutter_launcher_icons');
}

int _textWidth(BitmapFont font, String text) {
  var width = 0;
  for (final codeUnit in text.codeUnits) {
    final glyph = font.characters[codeUnit];
    if (glyph != null) width += glyph.xAdvance;
  }
  return width;
}
