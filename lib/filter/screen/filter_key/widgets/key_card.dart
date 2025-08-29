import 'package:flutter/material.dart';
import 'package:vibeat/utils/theme.dart';

class KeyCard extends StatelessWidget {
  const KeyCard({super.key, 
    required this.index,
    required this.keyData,
    required this.onToggle,
  });

  final int index;
  final dynamic keyData;
  final GestureTapCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            keyData.name,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
            ),
          ),
          IconButton(
            onPressed: onToggle,
            icon: keyData.isSelected
                ? const Icon(
                    Icons.check_box,
                    color: AppColors.primary,
                    size: 24,
                  )
                : Icon(
                    Icons.check_box_outline_blank,
                    color: const Color(0xffE8EAED).withOpacity(0.4),
                    size: 24,
                  ),
          )
        ],
      ),
    );
  }
}
