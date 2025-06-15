import 'package:flutter/material.dart';
import 'package:vibeat/filter/screen/filter_tag/model/tag_model.dart';
import 'package:vibeat/utils/theme.dart';

class TagCard extends StatelessWidget {
  const TagCard({
    super.key,
    required this.index,
    required this.tag,
    required this.onToggle,
  });

  final int index;
  final TagModel tag;
  final GestureTapCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 11,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            width: 0.5,
            color: tag.isSelected
                ? AppColors.primary
                : Colors.white.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '#${tag.name}',
          style: TextStyle(
            fontSize: 14,
            fontFamily: "Poppins",
            color: tag.isSelected
                ? AppColors.primary
                : Colors.white.withOpacity(0.4),
          ),
        ),
      ),
    );
  }
}
