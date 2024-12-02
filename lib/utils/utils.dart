import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class ImageExtractor {
  Future<List<Color>> extractTopAndBottomCenterColors(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        Uint8List bytes = response.bodyBytes;

        // Получаем изображение и определяем его размер
        final decodedImage = img.decodeImage(bytes);
        if (decodedImage != null) {
          int width = decodedImage.width;
          int height = decodedImage.height;

          return _getTopAndBottomCenterColorsFromBytes(bytes, width, height);
        }
      }
    } catch (e) {
      print('Ошибка загрузки изображения: $e');
    }
    return [];
  }

  List<Color> _getTopAndBottomCenterColorsFromBytes(
      Uint8List bytes, int width, int height) {
    final byteData = ByteData.view(bytes.buffer);

    final image = _ColorExtractor(
      width: width,
      height: height,
      byteData: byteData,
    );

    final topCenter = image.pixelColorAtAlignment(Alignment.topCenter);
    final bottomCenter = image.pixelColorAtAlignment(Alignment.bottomCenter);

    return [topCenter, bottomCenter];
  }
}

class _ColorExtractor {
  const _ColorExtractor({
    required this.width,
    required this.height,
    required this.byteData,
  });

  final int width;
  final int height;
  final ByteData byteData;
  final Color defaultColor = Colors.black;

  Color pixelColorAtAlignment(Alignment alignment) {
    if (alignment.x < -1.0 ||
        alignment.x > 1.0 ||
        alignment.y < -1.0 ||
        alignment.y > 1.0) {
      return defaultColor;
    }

    // Находим координаты пикселя по alignment
    Offset offset = alignment
        .alongSize(Size(width.toDouble() - 1.0, height.toDouble() - 1.0));

    return _pixelColorAt(offset.dx.round(), offset.dy.round());
  }

  Color _pixelColorAt(int x, int y) {
    if (x < 0 || x >= width || y < 0 || y >= height) {
      return defaultColor;
    }

    int byteOffset = 4 * (x + (y * width));

    return _colorAtByteOffset(byteOffset);
  }

  Color _colorAtByteOffset(int byteOffset) {
    if (byteOffset < 0 || byteOffset + 4 > byteData.lengthInBytes) {
      return defaultColor;
    }
    
    int rgbaColor = byteData.getUint32(byteOffset, Endian.little);

    return Color(_rgbaToArgb(rgbaColor));
  }

  int _rgbaToArgb(int rgbaColor) {
    int a = rgbaColor & 0xFF;
    int rgb = rgbaColor >> 8;
    return rgb + (a << 24);
  }
}