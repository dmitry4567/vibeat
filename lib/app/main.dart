import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vibeat/app/app_router.dart';
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

    // context.read<PlayerBloc>().add(GetRecommendEvent());
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
