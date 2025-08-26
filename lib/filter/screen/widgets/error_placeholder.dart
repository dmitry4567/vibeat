import 'package:flutter/material.dart';
import 'package:vibeat/utils/theme.dart';

class ErrorPlaceholder extends StatelessWidget {
  const ErrorPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.error_outline,
          color: Colors.grey,
          size: 50,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          "Ошибка получения данных",
          style: AppTextStyles.bodyAppbar.copyWith(
              color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
