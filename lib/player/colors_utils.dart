import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class ProfessionalColorUtils {
  static Future<Color> extractPaletteColorNetwork(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        final image = img.decodeImage(response.bodyBytes);
        if (image != null) {
          return _quantizeColors(image);
        }
      }
    } catch (e) {
      print('Error extracting color: $e');
    }
    return Colors.grey[800]!;
  }

  static Future<Color> extractPaletteColorCached(File file) async {
    try {
      final image = img.decodeImage(file.readAsBytesSync());

      if (image != null) {
        return _quantizeColors(image);
      }
    } catch (e) {
      print('Error extracting color: $e');
    }
    return Colors.grey[800]!;
  }

  static Color _quantizeColors(img.Image image) {
    final colorBuckets = List.generate(8, (index) => <Color>[]);
    final brightnessBuckets = List.generate(8, (index) => <Color>[]);

    // Распределяем цвета по корзинам
    for (int y = 0; y < image.height; y += 15) {
      for (int x = 0; x < image.width; x += 15) {
        final pixel = image.getPixel(x, y);
        final color = Color.fromRGBO(
          pixel.r.toInt(),
          pixel.g.toInt(),
          pixel.b.toInt(),
          1,
        );

        final hsl = HSLColor.fromColor(color);

        // Игнорируем крайние значения
        if (hsl.lightness > 0.15 && hsl.lightness < 0.85) {
          final hueBucket = (hsl.hue / 45).floor() % 8;
          final brightnessBucket = (hsl.lightness * 7).floor();

          colorBuckets[hueBucket].add(color);
          if (brightnessBucket >= 0 && brightnessBucket < 8) {
            brightnessBuckets[brightnessBucket].add(color);
          }
        }
      }
    }

    // Ищем самую заполненную корзину по hue
    final maxHueLength = colorBuckets.map((b) => b.length).reduce(max);
    var dominantHueBucket =
        colorBuckets.indexWhere((bucket) => bucket.length == maxHueLength);

    if (dominantHueBucket == -1 || colorBuckets[dominantHueBucket].isEmpty) {
      return _calculateVibrantColor(image);
    }

    // Берем средний цвет из доминирующей корзины
    final dominantColors = colorBuckets[dominantHueBucket];
    return _calculateAverageFromList(dominantColors);
  }

  static Color _calculateVibrantColor(img.Image image) {
    int r = 0, g = 0, b = 0;
    int count = 0;

    for (int y = 0; y < image.height; y += 10) {
      for (int x = 0; x < image.width; x += 10) {
        final pixel = image.getPixel(x, y);
        final color = Color.fromRGBO(
          pixel.r.toInt(),
          pixel.g.toInt(),
          pixel.b.toInt(),
          1,
        );

        final hsl = HSLColor.fromColor(color);
        // Предпочитаем цвета с хорошей насыщенностью
        if (hsl.saturation > 0.3 &&
            hsl.lightness > 0.2 &&
            hsl.lightness < 0.8) {
          r += pixel.r.toInt();
          g += pixel.g.toInt();
          b += pixel.b.toInt();
          count++;
        }
      }
    }

    if (count > 0) {
      return Color.fromRGBO(
        (r / count).round(),
        (g / count).round(),
        (b / count).round(),
        1,
      );
    }

    return _calculateAverageColor(image);
  }

  static Color _calculateAverageColor(img.Image image) {
    int r = 0, g = 0, b = 0;
    int count = 0;

    for (int y = 0; y < image.height; y += 10) {
      for (int x = 0; x < image.width; x += 10) {
        final pixel = image.getPixel(x, y);
        r += pixel.r.toInt();
        g += pixel.g.toInt();
        b += pixel.b.toInt();
        count++;
      }
    }

    if (count > 0) {
      return Color.fromRGBO(
        (r / count).round(),
        (g / count).round(),
        (b / count).round(),
        1,
      );
    }

    return Colors.grey[800]!;
  }

  static Color _calculateAverageFromList(List<Color> colors) {
    if (colors.isEmpty) return Colors.grey[800]!;

    int r = 0, g = 0, b = 0;
    for (final color in colors) {
      r += color.red;
      g += color.green;
      b += color.blue;
    }

    return Color.fromRGBO(
      (r / colors.length).round(),
      (g / colors.length).round(),
      (b / colors.length).round(),
      1,
    );
  }
}
