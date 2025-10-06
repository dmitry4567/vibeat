import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibeat/app/injection_container.dart';
import 'package:vibeat/player/bloc/player_bloc.dart';
import 'package:vibeat/utils/theme.dart';

class PlayerControlWidget extends StatelessWidget {
  const PlayerControlWidget({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerStateApp>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () async {
                if (pageController.page!.round() > 0) {
                  await pageController.previousPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linearToEaseOut,
                    // curve: Curves.fastLinearToSlowEaseIn,
                  );

                  sl<PlayerBloc>().add(PreviousTrackEvent());
                }
              },
              icon: const Icon(
                Icons.skip_previous,
                size: 48,
              ),
              color: AppColors.iconPrimary,
            ),
            IconButton(
              onPressed: () {
                sl<PlayerBloc>().add(
                    state.isPlaying ? PauseAudioEvent() : PlayAudioEvent());
              },
              icon: Icon(
                state.isPlaying ? Icons.pause_circle : Icons.play_circle,
                size: 64,
                color: AppColors.iconPrimary,
              ),
            ),
            IconButton(
              onPressed: () async {
                if (pageController.page!.round() < state.trackList.length - 1) {
                  await pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linearToEaseOut,
                  );

                  sl<PlayerBloc>().add(NextBeatInPlaylistEvent());
                  // sl<PlayerBloc>().add(UpdateCurrentTrackIndexEvent(
                  // state.currentTrackIndex + 1));
                }
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
