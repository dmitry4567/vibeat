import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibeat/app/app_router.dart';
import 'package:vibeat/filter/bloc/filter_bloc.dart';
import 'package:vibeat/filter/screen/filter_bpm/cubit/bpm_cubit.dart';
import 'package:vibeat/filter/screen/filter_genre/cubit/genre_cubit.dart';
import 'package:vibeat/filter/screen/filter_key/cubit/key_cubit.dart';
import 'package:vibeat/filter/screen/filter_mood/cubit/mood_cubit.dart';
import 'package:vibeat/filter/screen/filter_tag/cubit/tag_cubit.dart';
import 'package:vibeat/player/bloc/player_bloc.dart';
import 'package:vibeat/utils/theme.dart';
import 'package:vibeat/widgets/custom_error.dart';

Future<void> main() async {
  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return CustomError(errorDetails: errorDetails);
  };

  // await JustAudioBackground.init(
  //   androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
  //   androidNotificationChannelName: 'Audio playback',
  //   androidNotificationOngoing: true,
  // );

  runApp(
    MultiBlocProvider(providers: [
      BlocProvider(
        create: (_) => PlayerBloc(),
      ),
      BlocProvider(
        create: (_) => FilterBloc(),
      ),
      BlocProvider(
        create: (_) => GenreCubit(),
      ),
      BlocProvider(
        create: (_) => TagCubit(),
      ),
      BlocProvider(
        create: (_) => BpmCubit(),
      ),
      BlocProvider(
        create: (_) => KeyCubit(),
      ),
      BlocProvider(
        create: (_) => MoodCubit(),
      ),
    ], child: const MainApp()),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final ThemeMode _themeMode = ThemeMode.system;

  final _router = AppRouter();

  @override
  void initState() {
    super.initState();

    context.read<PlayerBloc>().add(GetRecommendEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router.config(),
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
    );
  }
}