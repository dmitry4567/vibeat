import 'package:flutter/material.dart';

SnackBar setupSnackBar(String text) {
  return SnackBar(
    content: Row(
      children: [
        const Icon(
          Icons.error_outline,
          color: Colors.white,
          size: 24,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 12,
              top: 6,
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: "Helvetica",
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
          ),
        )
      ],
    ),
    duration: const Duration(milliseconds: 4000),
    backgroundColor: Colors.red,
  );
}
