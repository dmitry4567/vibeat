import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vibeat/app/injection_container.dart';
import 'package:vibeat/core/api_client.dart';
import 'package:vibeat/filter/result.dart';
import 'package:vibeat/player/colors_utils.dart';
import 'package:vibeat/player/model/model_track.dart';

part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerStateApp> {
  static String host = "192.168.43.60";
  // static String host = "192.168.0.136";

  AudioPlayer player = AudioPlayer();
  late ConcatenatingAudioSource playlist;
  late PageController pageController;
  // StreamSubscription<PlaybackEvent>? _playerStateSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<PositionDiscontinuity>? _positionDiscontinuityStream;

  final apiClient = sl<ApiClient>().dio;

  bool isListened = false;
  Duration _lastPosition = Duration.zero;
  Timer? _listeningTimer;
  int listenedSeconds = 0;

  // String get currentBeatId => player.audioSource.

  Future<void> listenTrack() async {
    // final response = await apiClient.post(
    //   "beatActivity/listened",
    //   data: {"beatId": beatData[state.currentTrackIndex].id},
    // );
  }

  void _initializeSubscriptions() {
    _durationSubscription = player.durationStream.listen(
      (duration) {
        if (duration != null) add(UpdateDurationEvent(duration));
      },
      onError: (error) {
        // Обработка ошибок
      },
    );

    _positionSubscription = player.positionStream.listen(
      (position) {
        if (position < state.duration) {
          add(UpdatePositionEvent(position));
        }
        // print(position);
      },
      onError: (error) {
        // Обработка ошибок
      },
    );

    _positionDiscontinuityStream =
        player.positionDiscontinuityStream.listen((event) {
      if (event.reason == PositionDiscontinuityReason.autoAdvance) {
        if (state.currentTrackIndex < state.trackList.length - 1) {
          // add(UpdatePageControllerEvent(state.currentTrackIndex + 1))

          add(NextBeatInPlaylistEvent());
        }
      }
    });

    // _playerStateSubscription = player.playerStateStream.listen((playerState) {
    //   if (playerState.processingState == ProcessingState.completed) {
    //     add(PlayerTrackEnded());
    //   }
    // });
  }

  void _trackListeningTime(Duration currentPosition) {
    // Логика отслеживания времени прослушивания
    final difference = (currentPosition - _lastPosition).inSeconds;

    if (difference > 0) {
      listenedSeconds += difference;
      _lastPosition = currentPosition;
    }

    // Отправка на сервер после 30 секунд прослушивания
    if (listenedSeconds >= 5 && !isListened) {
      _markTrackAsListened();
      isListened = true;
    }
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
    // Initialize position stream subscription
    // player.currentIndexStream.listen((index) {
    // if (index! > state.currentTrackIndex) {
    //   add(NextTrackEvent());
    // }
    // else if (index < state.currentTrackIndex) {
    //   add(PreviousTrackEvent());
    // }
    // state.copyWith(playerBottom: true);

    // if (index != null && index != state.currentTrackIndex) {
    //   add(UpdateCurrentTrackEvent(index));
    // }
    // });

    // player.positionStream.listen((position) async {
    //   add(UpdatePositionEvent(position));

    //   if (player.playing) {
    //     final diff = position.inSeconds - _lastPosition.inSeconds;
    //     if (diff > 0) {
    //       listenedSeconds += diff;

    //       d.log('Total listened seconds: $listenedSeconds');
    //       if (listenedSeconds == 5) {
    //         await listenTrack();
    //       }
    //     }
    //     _lastPosition = position;
    //   }
    // });

    // player.PlayerStateAppStream.listen((PlayerStateApp) {
    //   if (PlayerStateApp.playing != state.isPlaying) {
    //     emit(state.copyWith(isPlaying: PlayerStateApp.playing));
    //   }
    // });

    // player.durationStream.listen((duration) {
    //   if (duration != null) {
    //     emit(state.copyWith(duration: duration));
    //   }
    // });

    // on<PlayerTrackEnded>((event, emit) {
    //   add(NextBeatInPlaylistEvent());
    // });

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

    on<GetRecommendEvent>(
      (event, emit) async {
        try {
          final response = await http.get(
            Uri.parse("http://$host:3000/music/rec/rec"),
          );

          if (response.statusCode == 200) {
            final trackData = jsonDecode(response.body);

            List<Track> trackList = [];

            for (var t in trackData) {
              final track = Track(
                id: t["id"],
                name: t["name"],
                bitmaker: t["bitmaker"],
                price: int.parse(t["price"]),
                trackUrl: t["trackUrl"],
                photoUrl: t["photoUrl"],
              );

              trackList.add(track);
              // Generate waveform data for each track
              // _generateWaveformForTrack(track);
              // await _getColorsBackground(track);
            }

            List<AudioSource> audioSources = trackList
                .map(
                  (track) => AudioSource.uri(
                    Uri.parse(track.trackUrl),
                    tag: MediaItem(
                      id: track.id,
                      album: "Album name",
                      artist: track.bitmaker,
                      title: track.name,
                      artUri: Uri.parse(track.photoUrl),
                    ),
                  ),
                )
                .toList();

            playlist = ConcatenatingAudioSource(
              useLazyPreparation: true,
              shuffleOrder: DefaultShuffleOrder(),
              children: audioSources,
            );

            await player.setAudioSource(
              playlist,
              preload: true,
              initialIndex: 0,
              initialPosition: Duration.zero,
            );

            // Set initial waveform data
            // final initialWaveform = _trackWaveforms[trackList[0].trackUrl] ??
            //     _generateDefaultWaveform();

            emit(state.copyWith(
              trackList: trackList,
              currentTrackIndex: player.currentIndex!,
              // colorsOfBackground: _trackColors,
              // waveformData: initialWaveform,
            ));
          } else {
            throw Exception("Failed to load new track");
          }
        } catch (e) {
          print(e);
        }
      },
    );

    on<PlayCurrentBeatEvent>((event, emit) async {
      bool shouldLoadNewPlaylist =
          state.trackList.isEmpty || event.beats[0].id != state.trackList[0].id;

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
          // Загружаем новый плейлист
          emit(state.copyWith(
            isInitialized: true,
            trackList: [],
            playerBottom: false, // Временно скрываем плеер во время загрузки
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

          // Создаем новый список треков
          List<Track> trackList = event.beats
              .map((t) => Track(
                    id: t.id,
                    name: t.name,
                    bitmaker: "icantluvv",
                    price: t.price,
                    trackUrl:
                        'http://storage.yandexcloud.net/mp3beats/${t.url}',
                    photoUrl: t.picture,
                  ))
              .toList();

          // Создаем аудиоисточники
          List<AudioSource> audioSources = trackList
              .map((track) => AudioSource.uri(
                    Uri.parse(track.trackUrl),
                    tag: MediaItem(
                      id: track.id,
                      album: "Album name",
                      artist: track.bitmaker,
                      title: track.name,
                      artUri: Uri.parse(track.photoUrl),
                    ),
                  ))
              .toList();

          playlist = ConcatenatingAudioSource(
            useLazyPreparation: true,
            children: audioSources,
          );

          // Устанавливаем новый аудиоисточник с явным указанием индекса
          await player.setAudioSource(
            playlist,
            // initialIndex: event.index,
          );

          // Ждем завершения инициализации
          await player.load();

          final waveformData =
              _generateWaveformForTrack(trackList[event.index]);

          final bgColors = await _getColorsBackground(trackList[event.index]);

          emit(state.copyWith(
            isInitialized: false,
            trackList: trackList,
            currentTrackIndex: event.index,
            playerBottom: true,
            isPlaying: true,
            waveformData: waveformData,
            colorsOfBackground: bgColors,
            currentTrackBeatId: trackList[event.index].id,
          ));

          await player.play();
        } else {
          // Используем существующий плейлист
          await player.stop();

          // СНАЧАЛА обновляем состояние с новым индексом
          emit(state.copyWith(
            currentTrackIndex: event.index,
            playerBottom: true,
            isPlaying: true,
            currentTrackBeatId: state.trackList[event.index].id,
          ));

          // Затем выполняем seek
          await player.seek(Duration.zero, index: event.index);

          // Генерируем waveform для выбранного трека
          final waveformData =
              _generateWaveformForTrack(state.trackList[event.index]);

          final backgroundColors =
              await _getColorsBackground(state.trackList[event.index]);

          // Обновляем состояние с waveform
          emit(state.copyWith(
            waveformData: waveformData,
            colorsOfBackground: backgroundColors,
          ));

          await player.play();
        }
      } catch (e) {
        print("Error in PlayCurrentBeatEvent: $e");
        // В случае ошибки восстанавливаем предыдущее состояние
        emit(state.copyWith(
          isInitialized: false,
          playerBottom: state.playerBottom,
        ));
      }
    });

    on<PreviousTrackEvent>((event, emit) async {
      if (player.currentIndex! > 0) {
        emit(state.copyWith(
          currentTrackIndex: player.currentIndex! - 1,
        ));

        await player.seekToPrevious();

        if (!state.isPause) {
          await player.play();
        }

        _lastPosition = Duration.zero;
        listenedSeconds = 0;

        final waveformData =
            _generateWaveformForTrack(state.trackList[player.currentIndex!]);

        emit(state.copyWith(
          waveformData: waveformData,
          currentTrackBeatId: state.trackList[player.currentIndex!].id,
        ));
      }
    });

    on<NextBeatInPlaylistEvent>((event, emit) async {
      if (state.currentTrackIndex < state.trackList.length - 1) {
        int newIndex = state.currentTrackIndex + 1;

        var file = await DefaultCacheManager().getSingleFile(state.trackList[newIndex].photoUrl);
        final colors = await ProfessionalColorUtils.extractPaletteColorCached(file);
        // int newIndex = player.currentIndex! + 1;

        emit(state.copyWith(
          currentTrackIndex: newIndex,
        ));

        await player.seekToNext();

        if (!state.isPause) {
          await player.play();
        }

        _lastPosition = Duration.zero;
        listenedSeconds = 0;

        final waveformData =
            _generateWaveformForTrack(state.trackList[player.currentIndex!]);

        // final bgColors = await _getColorsBackground(state.trackList[newIndex]);

        emit(state.copyWith(
          colorsOfBackground: colors,
          waveformData: waveformData,
          currentTrackBeatId: state.trackList[player.currentIndex!].id,
          loopCurrentFragment: false,
        ));

        // emit(state.copyWith(
        //   currentTrackIndex: player.currentIndex! + 1,
        // ));
        // add(UpdateCurrentTrackIndexEvent(state.currentTrackIndex + 1));

        // add(UpdateCurrentTrackIndexEvent(player.currentIndex! + 1));

        // await player.seekToNext();

        // if (!state.isPause) {
        //   await player.play();
        // }

        // _lastPosition = Duration.zero;
        // listenedSeconds = 0;

        // final waveformData =
        //     _generateWaveformForTrack(state.trackList[player.currentIndex!]);

        // emit(state.copyWith(
        //   waveformData: waveformData,
        //   currentTrackBeatId: state.trackList[player.currentIndex!].id,
        // ));
      }

      // final beat = state.trackList[state.currentTrackIndex + 1];

      // _generateWaveformForTrack(beat);
      // // await _getColorsBackground(beat);

      // final updatedTrackList = List<Track>.from(state.trackList)..add(beat);

      // final newChild = AudioSource.uri(
      //   Uri.parse(beat.trackUrl),
      //   tag: MediaItem(
      //     id: beat.id,
      //     album: "Album name",
      //     artist: beat.bitmaker,
      //     title: beat.name,
      //     artUri: Uri.parse(beat.photoUrl),
      //   ),
      // );

      // await playlist.add(newChild);

      // final nextIndex = state.currentTrackIndex + 1;

      // await player.seek(Duration.zero, index: nextIndex);
      // // await player.play();

      // _lastPosition = Duration.zero;
      // listenedSeconds = 0;

      // emit(state.copyWith(
      //   // trackList: updatedTrackList,
      //   currentTrackBeatId: updatedTrackList[player.currentIndex!].id,
      // ));
    });

    on<PlayAudioEvent>((event, emit) async {
      emit(state.copyWith(
        isPause: false,
        isPlaying: true,
      ));
      // final cachePath = (await LockCachingAudioSource.getCacheFile(
      //         Uri.parse(state.trackList[player.currentIndex!].trackUrl)))
      //     .toString();

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
      ));

      await player.seek(null, index: event.index);

      if (!state.isPause) {
        await player.play();
      }

      _lastPosition = Duration.zero;
      listenedSeconds = 0;

      final waveformData =
          _generateWaveformForTrack(state.trackList[player.currentIndex!]);

      emit(state.copyWith(
        waveformData: waveformData,
        currentTrackBeatId: state.trackList[player.currentIndex!].id,
        loopCurrentFragment: false,
      ));

      // if (event.index >= 0 && event.index < state.trackList.length) {
      // emit(
      //   state.copyWith(
      //     currentTrackIndex: event.index,
      //     waveformData:
      //         _trackWaveforms[state.trackList[event.index].trackUrl] ??
      //             _generateDefaultWaveform(),
      //   ),
      // );

      // await player.seek(Duration.zero, index: state.currentTrackIndex);
      // await player.stop();

      // await player.play();
      // }
    });

    on<NextTrackEvent>((event, emit) async {
      // Load more tracks if we're near the end
      final response = await http.get(
        Uri.parse("http://$host:3000/music/rec/rec2"),
      );

      if (response.statusCode == 200) {
        final t = jsonDecode(response.body);

        final newTrack = Track(
          id: t["id"],
          name: t["name"].toString(),
          bitmaker: t["bitmaker"].toString(),
          price: int.parse(t["price"]),
          trackUrl: t["trackUrl"],
          photoUrl: t["photoUrl"],
        );

        _generateWaveformForTrack(newTrack);
        // await _getColorsBackground(newTrack);

        final updatedTrackList = List<Track>.from(state.trackList)
          ..add(newTrack);

        final newChild = AudioSource.uri(
          Uri.parse(newTrack.trackUrl),
          tag: MediaItem(
            id: newTrack.id,
            album: "Album name",
            artist: newTrack.bitmaker,
            title: newTrack.name,
            artUri: Uri.parse(newTrack.photoUrl),
          ),
        );

        await playlist.add(newChild);

        final nextIndex = state.currentTrackIndex + 1;

        await player.seek(Duration.zero, index: nextIndex);
        await player.play();

        emit(state.copyWith(trackList: updatedTrackList));
      }
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

    // on<UpdatePositionEvent>((event, emit) async {
    // if (state.dragProgress == null) {
    //   final currentSeconds = event.position.inSeconds;
    //   int newIndexFragment = state.indexFragment;

    //   // Если зацикливание выключено, обновляем индекс фрагмента
    //   if (!state.loopCurrentFragment) {
    //     for (int i = 0; i < state.fragmentsMusic.length; i++) {
    //       if (i == state.fragmentsMusic.length - 1) {
    //         if (currentSeconds >= state.fragmentsMusic[i]) {
    //           newIndexFragment = i;
    //         }
    //       } else if (currentSeconds >= state.fragmentsMusic[i] &&
    //           currentSeconds < state.fragmentsMusic[i + 1]) {
    //         newIndexFragment = i;
    //         break;
    //       }
    //     }
    //   }

    //   // Проверяем необходимость зацикливания
    //   if (state.loopCurrentFragment) {
    //     final currentFragmentStart =
    //         state.fragmentsMusic[state.indexFragment];
    //     final currentFragmentEnd =
    //         state.indexFragment < state.fragmentsMusic.length - 1
    //             ? state.fragmentsMusic[state.indexFragment + 1]
    //             : state.duration.inSeconds;

    //     // Если вышли за пределы текущего фрагмента
    //     if (currentSeconds >= currentFragmentEnd) {
    //       await player.seek(Duration(seconds: currentFragmentStart));
    //       emit(
    //         state.copyWith(position: Duration(seconds: currentFragmentStart)),
    //       );
    //       return;
    //     }
    //   }

    //   emit(
    //     state.copyWith(
    //       position: event.position,
    //       indexFragment: newIndexFragment,
    //     ),
    //   );
    // }
    // });

    on<UpdateDragProgressEvent>((event, emit) {
      emit(state.copyWith(dragProgress: event.progress));
    });

    on<LoadNextTrackEvent>((event, emit) async {
      try {
        final newTrack = Track(
          id: "2",
          name: "name",
          bitmaker: "icantluvv",
          price: 2000,
          trackUrl: "http://$host:3000/music/2.wav",
          photoUrl: "http://$host:3000/photo/2.png",
        );

        // Generate waveform for new track
        _generateWaveformForTrack(newTrack);
        // await _getColorsBackground(newTrack);

        final updatedTrackList = List<Track>.from(state.trackList)
          ..add(newTrack);

        emit(
          state.copyWith(
            trackList: updatedTrackList,
            currentTrackIndex: state.currentTrackIndex + 1,
            // colorsOfBackground: [_trackColors[state.currentTrackIndex + 1]],
            // waveformData: _trackWaveforms[newTrack.trackUrl] ??
            //     _generateDefaultWaveform(),
          ),
        );
      } catch (e) {
        print("Error loading track: $e");
      }
    });
  }

  List<double> _generateWaveformForTrack(Track track) {
    final random = Random(track.trackUrl.hashCode);
    final List<double> waveform = [];
    const int samples = 55;

    double prevAmplitude = 0.5;
    for (int i = 0; i < samples; i++) {
      // Create a more natural-looking waveform with smoother transitions
      double newAmplitude = prevAmplitude;

      // Add some randomness while keeping it smooth
      newAmplitude += (random.nextDouble() - 0.5) * 0.3;

      // Add periodic variations to create rhythm-like patterns
      newAmplitude += math.sin(i * math.pi / 8) * 0.2;

      // Ensure the amplitude stays within reasonable bounds
      newAmplitude = newAmplitude.clamp(0.3, 0.9);

      // Add some higher peaks occasionally
      if (random.nextDouble() < 0.2) {
        newAmplitude = (newAmplitude + 0.9) / 2;
      }

      waveform.add(newAmplitude);
      prevAmplitude = newAmplitude;
    }

    return waveform;
  }

  List<double> _generateDefaultWaveform() {
    const samples = 55;
    return List.generate(samples, (i) => 0.5);
  }

  Future<Color> _getColorsBackground(Track track) async {
    final color = ProfessionalColorUtils.extractPaletteColorNetwork(track.photoUrl);

    return color;
  }

  Future<Color> _getColorsBackgroundCached(File file) async {
    final color = ProfessionalColorUtils.extractPaletteColorCached(file);

    return color;
  }

  @override
  Future<void> close() {
    _listeningTimer?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    // player.dispose();

    return super.close();
  }
}
