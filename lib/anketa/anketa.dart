import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    const double paddingWidth = 18.0;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Фиксированный заголовок
              const SliverAppBar(
                pinned: true,
                floating: false,
                elevation: 0,
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

              // Основной контент с сеткой
              SliverPadding(
                padding: const EdgeInsets.only(
                  left: paddingWidth,
                  right: paddingWidth,
                  bottom: 100,
                ),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: (size.width - (paddingWidth * 2) - 10) / 4,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Skeletonizer(
                      enabled: false,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6)),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.asset(
                                    "assets/images/genre${((index + 1) % 4 + 1).toInt()}.png",
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                ),
                                const Positioned(
                                  top: 9,
                                  left: 9,
                                  child: Text(
                                    "Detroit",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textPrimary,
                                      letterSpacing: -0.41,
                                      height: 0.81,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    childCount: 24,
                  ),
                ),
              ),
            ],
          ),

          // Фиксированная кнопка внизу экрана
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
                      onPressed: () {},
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.disabled)) {
                              return Colors
                                  .grey; // Серый цвет, если кнопка отключена
                            }
                            return AppColors
                                .primary; // Обычный цвет, если активна
                          },
                        ),
                        foregroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.disabled)) {
                              return AppColors
                                  .textPrimary; // Белый текст, если отключена
                            }
                            return Colors.black; // Чёрный текст, если активна
                          },
                        ),
                        overlayColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.pressed)) {
                              return Colors.white
                                  .withOpacity(0.1); // Белый splash-эффект
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
}
