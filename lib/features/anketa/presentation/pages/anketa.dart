import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibeat/app/app_router.gr.dart';
import 'package:vibeat/custom_functions.dart';
import 'package:vibeat/features/anketa/domain/entities/anketa_entity.dart';
import 'package:vibeat/features/anketa/presentation/bloc/anketa_bloc.dart';
import 'package:vibeat/features/signIn/presentation/bloc/auth_bloc.dart';
import 'package:vibeat/utils/theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

@RoutePage()
class AnketaScreen extends StatefulWidget {
  const AnketaScreen({super.key});

  @override
  State<AnketaScreen> createState() => _AnketaScreenState();
}

class _AnketaScreenState extends State<AnketaScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AnketaBloc>().add(GetAnketaEvent());
  }

  @override
  Widget build(BuildContext context) {
    const double paddingWidth = 18.0;
    final size = MediaQuery.of(context).size;

    return BlocConsumer<AnketaBloc, AnketaState>(
      listener: (context, state) {
        if (state.status == AnketaStatus.error && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            setupSnackBar(state.errorMessage!)
          );
        }
        if (state.isResponseSuccess == true) {
          context.router.replaceAll([const HeadRoute()]);
        }
      },
      builder: (context, state) {
        if (state.status == AnketaStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.anketa != null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    const SliverAppBar(
                      pinned: true,
                      floating: false,
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      backgroundColor: AppColors.background,
                      surfaceTintColor: Colors.transparent,
                      expandedHeight: 0,
                      toolbarHeight: 120,
                      flexibleSpace: Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Text(
                            "Выберите\nлюбимые жанры",
                            style: AppTextStyles.headline,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.only(
                        left: paddingWidth,
                        right: paddingWidth,
                        bottom: 100,
                      ),
                      sliver: SliverGrid.builder(
                        itemCount: state.anketa!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent:
                              (size.width - (paddingWidth * 2) - 10) / 4,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                        ),
                        itemBuilder: (context, index) => Skeletonizer(
                          enabled: false,
                          child: GestureDetector(
                            onTap: () {},
                            child: CardGenre(
                              index: index,
                              text: state.anketa![index].text,
                              genre: state.anketa![index],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 12, bottom: 52),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 56,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              // context.read<AuthBloc>().add(AnketaDataRequested());
                              context.read<AnketaBloc>().add(
                                    const SendAnketaResponseEvent(),
                                  );
                            },
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.disabled)) {
                                    return Colors
                                        .grey; // Серый цвет, если кнопка отключена
                                  }
                                  return AppColors
                                      .primary; // Обычный цвет, если активна
                                },
                              ),
                              foregroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.disabled)) {
                                    return AppColors
                                        .textPrimary; // Белый текст, если отключена
                                  }
                                  return Colors
                                      .black; // Чёрный текст, если активна
                                },
                              ),
                              overlayColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.pressed)) {
                                    return Colors.white.withOpacity(
                                        0.1); // Белый splash-эффект
                                  }
                                  return Colors
                                      .transparent; // Прозрачный, если не нажата
                                },
                              ),
                            ),
                            child: const Text(
                              'Далее',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.buttonTextField,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(
          child: Text('Неизвестный статус анкеты'),
        );
      },
    );
  }
}

class CardGenre extends StatefulWidget {
  const CardGenre(
      {super.key,
      required this.index,
      required this.text,
      required this.genre});

  final int index;
  final String text;
  final AnketaEntity genre;

  @override
  State<CardGenre> createState() => _CardGenreState();
}

class _CardGenreState extends State<CardGenre> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          context.read<AnketaBloc>().add(
                AddGenreEvent(
                  genre: widget.genre,
                ),
              );
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
              color: isSelected
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
              Positioned.fill(
                child: Image.asset(
                  "assets/images/genre${((widget.index + 1) % 4 + 1).toInt()}.png",
                  fit: BoxFit.fitWidth,
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
                  widget.text,
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
              isSelected
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
