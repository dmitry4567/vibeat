import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibeat/app/injection_container.dart';
import 'package:vibeat/core/api_client.dart';
import 'package:vibeat/features/favorite/data/models/beat_model.dart';
import 'package:vibeat/player/colors_utils.dart';
import 'package:vibeat/player/model/model_track.dart';

part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerStateApp> {
  static String host = "192.168.43.60";

  AudioPlayer player = AudioPlayer();
  late ConcatenatingAudioSource playlist;
  late PageController pageController;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<PositionDiscontinuity>? _positionDiscontinuityStream;

  final apiClient = sl<ApiClient>().dio;

  bool isListened = false;
  Timer? _listeningTimer;

  void _initializeSubscriptions() {
    _durationSubscription = player.durationStream.listen(
      (duration) {
        if (duration != null) add(UpdateDurationEvent(duration));
      },
      onError: (error) {},
    );

    _positionSubscription = player.positionStream.listen(
      (position) {
        if (position < state.duration) {
          add(UpdatePositionEvent(position));
        }
      },
      onError: (error) {},
    );

    _positionDiscontinuityStream =
        player.positionDiscontinuityStream.listen((event) {
      if (event.reason == PositionDiscontinuityReason.autoAdvance) {
        if (state.currentTrackIndex < state.trackList.length - 1) {
          // add(UpdatePageControllerEvent(state.currentTrackIndex + 1))

          // add(NextBeatInPlaylistEvent());
        }
      }
    });
  }

  Future<void> _markTrackAsListened() async {
    try {
      // final response = await apiClient.post(
      //   "beatActivity/listened",
      //   data: {"beatId": beatData[state.currentTrackIndex].id},
      // );
    } catch (e) {
      // Обработка ошибок
    }
  }

  PlayerBloc() : super(PlayerStateApp.initial()) {
    _initializeSubscriptions();

    on<UpdatePlayerBottomEvent>((event, emit) {
      emit(state.copyWith(playerBottom: event.value));
    });

    on<UpdatePositionEvent>((event, emit) async {
      if (state.dragProgress == null) {
        final currentSeconds = event.position.inSeconds;
        int newIndexFragment = state.indexFragment;

        if (!state.loopCurrentFragment) {
          for (int i = 0; i < state.fragmentsMusic.length; i++) {
            if (i == state.fragmentsMusic.length - 1) {
              if (currentSeconds >= state.fragmentsMusic[i]) {
                newIndexFragment = i;
              }
            } else if (currentSeconds >= state.fragmentsMusic[i] &&
                currentSeconds < state.fragmentsMusic[i + 1]) {
              newIndexFragment = i;
              break;
            }
          }
        }

        // Проверяем необходимость зацикливания
        if (state.loopCurrentFragment) {
          final currentFragmentStart =
              state.fragmentsMusic[state.indexFragment];
          final currentFragmentEnd =
              state.indexFragment < state.fragmentsMusic.length - 1
                  ? state.fragmentsMusic[state.indexFragment + 1]
                  : state.duration.inSeconds;

          // Если вышли за пределы текущего фрагмента
          if (currentSeconds >= currentFragmentEnd) {
            await player.seek(Duration(seconds: currentFragmentStart));
            emit(
              state.copyWith(position: Duration(seconds: currentFragmentStart)),
            );
            return;
          }
        }

        emit(state.copyWith(
          indexFragment: newIndexFragment,
          position: event.position,
        ));
      }

      // _trackListeningTime(event.position);
    });

    on<UpdateDurationEvent>((event, emit) {
      emit(state.copyWith(duration: event.duration));
    });

    on<PlayCurrentBeatEvent>((event, emit) async {
      bool shouldLoadNewPlaylist = state.trackList.isEmpty ||
          event.beats[0].id != state.trackList[0].id ||
          event.beats.length != state.trackList.length ||
          event.beats.last.id != state.trackList.last.id;
      print(shouldLoadNewPlaylist);

      // if ((event.beats.length != state.trackList.length) &&
      //     (event.beats[state.currentTrackIndex].id !=
      //         state.trackList[state.currentTrackIndex].id) &&
      //     (event.beats[0].id != state.trackList[0].id) &&
      //     (event.beats[event.beats.length - 1].id !=
      //         state.trackList[state.trackList.length - 1].id)) {
      //   shouldLoadNewPlaylist = true;
      //   print("new playlist");
      // }

      try {
        if (shouldLoadNewPlaylist) {
          emit(state.copyWith(
            isInitialized: true,
            trackList: [],
            playerBottom: false,
            colorsOfBackground: Colors.grey,
          ));

          // Останавливаем и очищаем текущий плеер
          await player.dispose();
          _positionSubscription?.cancel();
          _durationSubscription?.cancel();
          _positionDiscontinuityStream?.cancel();

          player = AudioPlayer();
          _initializeSubscriptions();

          // await player.stop();
          // await player.setAudioSource(
          //   ConcatenatingAudioSource(children: []),
          //   initialIndex: event.index,
          //   initialPosition: Duration.zero,
          // );

          final audioSources = event.beats.map((t) {
            final trackUrl = 'http://storage.yandexcloud.net/mp3beats/${t.url}';
            final photoUrl = t.picture;

            return TrackAudioSource(
              id: t.id,
              name: t.name,
              bitmaker: t.beatmakerName,
              price: t.price,
              trackUrl: trackUrl,
              photoUrl: photoUrl,
              bpm: t.bpm,
              tune: t.key.name,
              timeStamps: t.timeStamps.isNotEmpty ? t.timeStamps : null,
            );
          }).toList();

          emit(state.copyWith(
            trackList: audioSources,
            currentTrackIndex: event.index,
            currentTrackBeatId: audioSources[event.index].id,
          ));

          playlist = ConcatenatingAudioSource(
            useLazyPreparation: true,
            children: audioSources,
          );

          await player.setAudioSource(
            playlist,
            initialIndex: event.index,
          );

          // await player.load();

          final waveformData =
              _generateWaveformForTrack(audioSources[event.index]);

          var file = await DefaultCacheManager()
              .getSingleFile(state.trackList[event.index].photoUrl);
          final bgColors =
              await ProfessionalColorUtils.extractPaletteColorCached(file);

          emit(state.copyWith(
            colorsOfBackground: bgColors,
            isInitialized: false,
            playerBottom: true,
            isPlaying: true,
            waveformData: waveformData,
            isTimeStamps: false,
          ));

          // for (var i = 0; i < state.trackList.length; i++) {
          //   if (state.trackList[i].timeStamps != null) {
          //     print(i);
          //     print(state.trackList[i].timeStamps.toString());
          //   }
          // }

          // if (state.trackList[event.index].timeStamps != null) {
          //   List<int> fragmentsMusic = [0];
          //   List<String> fragmentsNames = [];

          //   for (var fragment in state.trackList[event.index].timeStamps!) {
          //     fragmentsMusic.add(fragment.endTime);
          //     fragmentsNames.add(fragment.title);
          //   }

          //   emit(state.copyWith(
          //     isTimeStamps: true,
          //     fragmentsMusic: fragmentsMusic,
          //     fragmentsNames: fragmentsNames,
          //   ));
          // } else {
          //   emit(state.copyWith(isTimeStamps: false));
          // }

          await player.play();
        } else {
          player.stop();

          // if (state.trackList[event.index].timeStamps == null) {
          //   emit(state.copyWith(isTimeStamps: false));
          // } else {
          //   List<int> fragmentsMusic = [0];
          //   List<String> fragmentsNames = [];

          //   for (var fragment in state.trackList[event.index].timeStamps!) {
          //     fragmentsMusic.add(fragment.endTime);
          //     fragmentsNames.add(fragment.title);
          //   }

          //   emit(state.copyWith(
          //     isTimeStamps: true,
          //     fragmentsMusic: fragmentsMusic,
          //     fragmentsNames: fragmentsNames,
          //   ));
          // }

          // СНАЧАЛА обновляем состояние с новым индексом
          emit(state.copyWith(
            currentTrackIndex: event.index,
            currentTrackBeatId: state.trackList[event.index].id,
            playerBottom: true,
            isPlaying: true,
          ));

          // Затем выполняем seek
          player.seek(Duration.zero, index: event.index);

          // Генерируем waveform для выбранного трека
          final waveformData =
              _generateWaveformForTrack(state.trackList[event.index]);

          var file = await DefaultCacheManager()
              .getSingleFile(state.trackList[event.index].photoUrl);
          final bgColors =
              await ProfessionalColorUtils.extractPaletteColorCached(file);

          // Обновляем состояние с waveform
          emit(state.copyWith(
            waveformData: waveformData,
            colorsOfBackground: bgColors,
          ));

          player.play();
        }
      } catch (e) {
        print("Error in PlayCurrentBeatEvent: $e");
        emit(state.copyWith(
          isInitialized: false,
          playerBottom: state.playerBottom,
        ));
      }
    });

    on<PreviousTrackEvent>((event, emit) async {
      if (player.currentIndex! > 0) {
        int newIndex = state.currentTrackIndex - 1;

        final waveformData =
            _generateWaveformForTrack(state.trackList[player.currentIndex!]);

        var file = await DefaultCacheManager()
            .getSingleFile(state.trackList[newIndex].photoUrl);
        final bgColors =
            await ProfessionalColorUtils.extractPaletteColorCached(file);

        emit(state.copyWith(
          colorsOfBackground: bgColors,
          waveformData: waveformData,
          currentTrackIndex: player.currentIndex! - 1,
          currentTrackBeatId: state.trackList[player.currentIndex! - 1].id,
        ));

        await player.seekToPrevious();

        if (!state.isPause) {
          await player.play();
        }

        emit(state.copyWith(
          loopCurrentFragment: false,
          isTimeStamps: false,
        ));

        if (state.trackList[player.currentIndex!].timeStamps != null) {
          emit(state.copyWith(isTimeStamps: true));
        }
      }
    });

    on<NextBeatInPlaylistEvent>((event, emit) async {
      if (state.currentTrackIndex < state.trackList.length - 1) {
        int newIndex = state.currentTrackIndex + 1;

        final waveformData =
            _generateWaveformForTrack(state.trackList[player.currentIndex!]);

        var file = await DefaultCacheManager()
            .getSingleFile(state.trackList[newIndex].photoUrl);
        final colors =
            await ProfessionalColorUtils.extractPaletteColorCached(file);

        emit(state.copyWith(
          colorsOfBackground: colors,
          waveformData: waveformData,
          currentTrackIndex: newIndex,
          currentTrackBeatId: state.trackList[newIndex].id,
        ));

        await player.seekToNext();

        if (!state.isPause) {
          await player.play();
        }

        emit(state.copyWith(
          loopCurrentFragment: false,
          isTimeStamps: false,
        ));
      }
    });

    on<PlayAudioEvent>((event, emit) async {
      emit(state.copyWith(
        isPause: false,
        isPlaying: true,
      ));

      await player.play();
    });

    on<PauseAudioEvent>((event, emit) async {
      emit(state.copyWith(
        isPause: true,
        isPlaying: false,
      ));

      await player.pause();
    });

    on<StopAudioEvent>((event, emit) {
      emit(state.copyWith(isPlaying: false, position: Duration.zero));
    });

    on<UpdateCurrentTrackIndexEvent>((event, emit) async {
      emit(state.copyWith(
        currentTrackIndex: event.index,
        currentTrackBeatId: state.trackList[event.index].id,
      ));

      await player.seek(null, index: event.index);

      if (!state.isPause) {
        await player.play();
      }

      final waveformData =
          _generateWaveformForTrack(state.trackList[player.currentIndex!]);

      var file = await DefaultCacheManager()
          .getSingleFile(state.trackList[player.currentIndex!].photoUrl);
      final bgColors =
          await ProfessionalColorUtils.extractPaletteColorCached(file);

      emit(state.copyWith(
        colorsOfBackground: bgColors,
        waveformData: waveformData,
        loopCurrentFragment: false,
      ));
    });

    on<NextFragmentEvent>((event, emit) async {
      if (state.indexFragment < state.fragmentsMusic.length - 1) {
        final nextIndex = state.indexFragment + 1;
        await player.seek(Duration(seconds: state.fragmentsMusic[nextIndex]));

        emit(state.copyWith(indexFragment: nextIndex));
      }
    });

    on<PreviousFragmentEvent>((event, emit) async {
      if (state.indexFragment > 0) {
        final prevIndex = state.indexFragment - 1;
        await player.seek(Duration(seconds: state.fragmentsMusic[prevIndex]));

        emit(state.copyWith(indexFragment: prevIndex));
      }
    });

    on<ToggleRepeatEvent>((event, emit) {
      emit(state.copyWith(isRepeat: !state.isRepeat));
    });

    on<ToggleLoopFragmentEvent>((event, emit) {
      emit(state.copyWith(loopCurrentFragment: !state.loopCurrentFragment));
    });

    on<UpdateDragProgressEvent>((event, emit) {
      emit(state.copyWith(dragProgress: event.progress));
    });
  }

  // void setTimeStamps() {
  //   if (state.trackList[event.index].timeStamps == null) {
  //     emit(state.copyWith(isTimeStamps: false));
  //   } else {
  //     List<int> fragmentsMusic = [0];
  //     List<String> fragmentsNames = [];

  //     for (var fragment in state.trackList[event.index].timeStamps!) {
  //       fragmentsMusic.add(fragment.endTime);
  //       fragmentsNames.add(fragment.title);
  //     }

  //     emit(state.copyWith(
  //       isTimeStamps: true,
  //       fragmentsMusic: fragmentsMusic,
  //       fragmentsNames: fragmentsNames,
  //     ));
  //   }
  // }

  List<double> _generateWaveformForTrack(TrackAudioSource track) {
    final random = Random(track.trackUrl.hashCode);
    final List<double> waveform = [];
    const int samples = 55;

    double prevAmplitude = 0.5;
    for (int i = 0; i < samples; i++) {
      double newAmplitude = prevAmplitude;
      newAmplitude += (random.nextDouble() - 0.5) * 0.3;
      newAmplitude += math.sin(i * math.pi / 8) * 0.2;
      newAmplitude = newAmplitude.clamp(0.3, 0.9);
      if (random.nextDouble() < 0.2) {
        newAmplitude = (newAmplitude + 0.9) / 2;
      }
      waveform.add(newAmplitude);
      prevAmplitude = newAmplitude;
    }

    return waveform;
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();

    return super.close();
  }
}
