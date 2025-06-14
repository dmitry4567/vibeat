import 'dart:async';
import 'dart:math' as math;
import 'dart:math';
import 'dart:ui';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'dart:developer' as d;
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vibeat/player/model/model_track.dart';
import 'package:vibeat/utils/image_extractor.dart';

part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  static String host = "192.168.0.135";
  // static String host = "192.168.0.136";

  final AudioPlayer player = AudioPlayer();
  late ConcatenatingAudioSource playlist;
  StreamSubscription<Duration>? _positionSubscription;
  final Map<String, List<double>> _trackWaveforms = {};
  final List<List<Color>> _trackColors = [];

  PlayerBloc() : super(PlayerState.initial()) {
    // Initialize position stream subscription
    player.currentIndexStream.listen((index) {
      // if (index! > state.currentTrackIndex) {
      //   add(NextTrackEvent());
      // }
      // else if (index < state.currentTrackIndex) {
      //   add(PreviousTrackEvent());
      // }
      // state.copyWith(playerBottom: true);
      if (index != null && index != state.currentTrackIndex) {
        add(UpdateCurrentTrackEvent(index));
      }
    });

    player.positionStream.listen((position) {
      add(UpdatePositionEvent(position));
    });

    player.playerStateStream.listen((playerState) {
      if (playerState.playing != state.isPlaying) {
        emit(state.copyWith(isPlaying: playerState.playing));
      }
    });

    player.durationStream.listen((duration) {
      if (duration != null) {
        emit(state.copyWith(duration: duration));
      }
    });

    on<UpdatePlayerBottomEvent>((event, emit) {
      emit(state.copyWith(playerBottom: event.value));
    });

    on<GetRecommendEvent>((event, emit) async {
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
            _generateWaveformForTrack(track);
            // await _getColorsBackground(track);
          }

          List<AudioSource> audioSources =
              trackList
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
            initialIndex: 0,
            initialPosition: Duration.zero,
          );

          // Set initial waveform data
          final initialWaveform =
              _trackWaveforms[trackList[0].trackUrl] ??
              _generateDefaultWaveform();

          emit(
            state.copyWith(
              trackList: trackList,
              currentTrackIndex: player.currentIndex!,
              colorsOfBackground: _trackColors,
              waveformData: initialWaveform,
            ),
          );
        } else {
          throw Exception("Failed to load new track");
        }
      } catch (e) {
        print(e);
      }
    });

    on<PlayAudioEvent>((event, emit) async {
      // final cachePath = (await LockCachingAudioSource.getCacheFile(
      //         Uri.parse(state.trackList[player.currentIndex!].trackUrl)))
      //     .toString();

      emit(state.copyWith(isPlaying: true));

      await player.play();
    });

    on<PauseAudioEvent>((event, emit) async {
      await player.pause();
      emit(state.copyWith(isPlaying: false));
    });

    on<StopAudioEvent>((event, emit) {
      emit(state.copyWith(isPlaying: false, position: Duration.zero));
    });

    on<UpdateCurrentTrackEvent>((event, emit) async {
      if (event.index >= 0 && event.index < state.trackList.length) {
        emit(
          state.copyWith(
            currentTrackIndex: event.index,
            waveformData:
                _trackWaveforms[state.trackList[event.index].trackUrl] ??
                _generateDefaultWaveform(),
          ),
        );

        await player.seek(Duration.zero, index: state.currentTrackIndex);
        await player.stop();

        await player.play();
      }
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

    on<PreviousTrackEvent>((event, emit) async {
      if (state.currentTrackIndex > 0) {
        final previousIndex = state.currentTrackIndex - 1;
        await player.seek(Duration.zero, index: previousIndex);
        await player.play();
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

    on<UpdatePositionEvent>((event, emit) async {
      if (state.dragProgress == null) {
        final currentSeconds = event.position.inSeconds;
        int newIndexFragment = state.indexFragment;

        // Если зацикливание выключено, обновляем индекс фрагмента
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

        emit(
          state.copyWith(
            position: event.position,
            indexFragment: newIndexFragment,
          ),
        );
      }
    });

    on<UpdateDragProgressEvent>((event, emit) {
      emit(state.copyWith(dragProgress: event.progress));
    });

    on<LoadNextTrackEvent>((event, emit) async {
      try {
        final newTrack = Track(
          id: "2",
          name: "name",
          bitmaker: "bitmaker",
          price: 2000,
          trackUrl: "http://$host:3000/music/2.wav",
          photoUrl: "http://$host:3000/photo/2.png",
        );

        // Generate waveform for new track
        _generateWaveformForTrack(newTrack);
        await _getColorsBackground(newTrack);

        final updatedTrackList = List<Track>.from(state.trackList)
          ..add(newTrack);

        emit(
          state.copyWith(
            trackList: updatedTrackList,
            currentTrackIndex: state.currentTrackIndex + 1,
            colorsOfBackground: [_trackColors[state.currentTrackIndex + 1]],
            waveformData:
                _trackWaveforms[newTrack.trackUrl] ??
                _generateDefaultWaveform(),
          ),
        );
      } catch (e) {
        print("Error loading track: $e");
      }
    });
  }

  void _generateWaveformForTrack(Track track) {
    if (_trackWaveforms.containsKey(track.trackUrl)) return;

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

    _trackWaveforms[track.trackUrl] = waveform;
  }

  List<double> _generateDefaultWaveform() {
    const samples = 55;
    return List.generate(samples, (i) => 0.5);
  }

  Future<void> _getColorsBackground(Track track) async {
    List<Color> colors = await ImageExtractor().extractTopAndBottomCenterColors(
      track.photoUrl,
    );

    _trackColors.add(colors);
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    player.dispose();
    return super.close();
  }
}
