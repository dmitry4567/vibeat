import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vibeat/filter/screen/filter_genre/model/genre_model.dart';
import 'package:vibeat/utils/theme.dart';

class GenreCard extends StatelessWidget {
  const GenreCard({
    super.key,
    required this.index,
    required this.genre,
    required this.onToggle,
  });

  final int index;
  final GenreModel genre;
  final GestureTapCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        margin: EdgeInsets.only(
          right: (index + 1) % 2 != 0 ? 15 : 0,
          bottom: 20,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
              color: genre.isSelected
                  ? AppColors.primary
                  : Colors.white.withOpacity(0.1),
              width: 1),
          borderRadius: const BorderRadius.all(
            Radius.circular(6),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          child: Stack(
            children: [
              genre.photoUrl != ''
                  ? Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: genre.photoUrl,
                        fit: BoxFit.fitWidth,
                      ),
                    )
                  : Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ),
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
              Positioned(
                top: 9,
                left: 9,
                child: Text(
                  genre.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.41,
                    height: 0.81,
                  ),
                ),
              ),
              Positioned(
                bottom: 9,
                right: 9,
                child: Text(
                  "${genre.countOfBeats} битов",
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.41,
                    height: 0.54,
                  ),
                ),
              ),
              genre.isSelected
                  ? const Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(
                        Icons.check_circle,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
