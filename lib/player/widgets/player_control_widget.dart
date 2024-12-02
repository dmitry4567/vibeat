import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibeat/player/bloc/player_bloc.dart';
import 'package:vibeat/utils/theme.dart';

class PlayerControlWidget extends StatelessWidget {
  const PlayerControlWidget({super.key, required this.pageController});

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                context.read<PlayerBloc>().add(PreviousTrackEvent());

                pageController.previousPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastLinearToSlowEaseIn,
                );
              },
              icon: const Icon(
                Icons.skip_previous,
                size: 48,
              ),
              color: AppColors.iconPrimary,
            ),
            IconButton(
              onPressed: () async {
                context.read<PlayerBloc>().state.isPlaying
                    ? context.read<PlayerBloc>().add(PauseAudioEvent())
                    : context.read<PlayerBloc>().add(PlayAudioEvent());
              },
              icon: Icon(
                state.isPlaying ? Icons.pause_circle : Icons.play_circle,
                size: 64,
              ),
              color: AppColors.iconPrimary,
            ),
            IconButton(
              onPressed: () {
                context.read<PlayerBloc>().add(NextTrackEvent());

                pageController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastLinearToSlowEaseIn,
                );
              },
              icon: const Icon(
                Icons.skip_next,
                size: 48,
              ),
              color: AppColors.iconPrimary,
            ),
          ],
        );
      },
    );
  }
}
