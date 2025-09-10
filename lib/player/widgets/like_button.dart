import 'package:flutter/material.dart';
import 'package:vibeat/app/injection_container.dart';
import 'package:vibeat/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:vibeat/utils/theme.dart';

class LikeButton extends StatefulWidget {
  LikeButton({super.key, required this.beatId, this.isLiked = false});

  final String beatId;
  bool isLiked;

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        if (widget.isLiked) {
          sl<FavoriteBloc>().add(DeleteFavoriteEvent(beatId: widget.beatId));

          widget.isLiked = false;
          setState(() {});
        } else {
          sl<FavoriteBloc>().add(AddFavoriteEvent(beatId: widget.beatId));

          widget.isLiked = true;
          setState(() {});
        }
      },
      icon: Icon(
        widget.isLiked ? Icons.favorite : Icons.favorite_border,
      ),
      color: AppColors.iconPrimary,
    );
  }
}
