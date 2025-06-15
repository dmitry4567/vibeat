import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vibeat/app/app_router.dart';
import 'package:vibeat/features/anketa/presentation/bloc/anketa_bloc.dart';
import 'package:vibeat/features/signIn/presentation/bloc/auth_bloc.dart';
import 'package:vibeat/app/router.dart';
import 'package:vibeat/filter/bloc/filter_bloc.dart';
import 'package:vibeat/filter/screen/filter_bpm/cubit/bpm_cubit.dart';
import 'package:vibeat/filter/screen/filter_genre/cubit/genre_cubit.dart';
import 'package:vibeat/filter/screen/filter_key/cubit/key_cubit.dart';
import 'package:vibeat/filter/screen/filter_mood/cubit/mood_cubit.dart';
import 'package:vibeat/filter/screen/filter_tag/bloc/tag_bloc.dart';
import 'package:vibeat/player/bloc/player_bloc.dart';
import 'package:vibeat/utils/theme.dart';
import 'package:vibeat/widgets/custom_error.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:vibeat/app/injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return CustomError(errorDetails: errorDetails);
  };

  // await JustAudioBackground.init(
  //   androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
  //   androidNotificationChannelName: 'Audio playback',
  //   androidNotificationOngoing: true,
  // );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PlayerBloc()),
        BlocProvider(create: (_) => FilterBloc()),
        BlocProvider(create: (_) => GenreCubit()),
        BlocProvider(create: (_) => TagBloc()),
        BlocProvider(create: (_) => BpmCubit()),
        BlocProvider(create: (_) => KeyCubit()),
        BlocProvider(create: (_) => MoodCubit()),
        BlocProvider(
          create: (context) => di.sl<AuthBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<AnketaBloc>(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

final router = AppRouter();

class _MainAppState extends State<MainApp> {
  final ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();

    // context.read<PlayerBloc>().add(GetRecommendEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router.config(
        navigatorObservers: () =>
            [MyAutoRouterObserver(context.read<PlayerBloc>())],
      ),
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
    );
  }
}
