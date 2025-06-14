import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vibeat/filter/bloc/filter_bloc.dart';
import 'package:vibeat/filter/screen/filter_genre/cubit/genre_cubit.dart';
import 'package:vibeat/filter/screen/filter_genre/model/genre_model.dart';
import 'package:vibeat/filter/screen/filter_genre/widgets/genre_card.dart';
import 'package:vibeat/filter/screen/widgets/error_placeholder.dart';
import 'package:vibeat/utils/theme.dart';

@RoutePage()
class FilterGenreScreen extends StatelessWidget {
  const FilterGenreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double paddingWidth = 18.0;
    final size = MediaQuery.of(context).size;

    final textController1 = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.appbar,
        forceMaterialTransparency: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _FilterHeaderDelegate(),
                  ),
                  BlocBuilder<GenreCubit, GenreState>(
                    // buildWhen: (previous, current) =>
                    // previous.selectedGenres != current.selectedGenres ||
                    // previous.genres != current.genres,
                    builder: (context, state) {
                      if (state is GenreError) {
                        return const SliverFillRemaining(
                          child: ErrorPlaceholder(),
                        );
                      } else if (state is GenreLoading) {
                        return SliverGrid.builder(
                          itemCount: 8,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent:
                                (size.width - (paddingWidth * 2) - 10) / 3,
                          ),
                          itemBuilder: (_, index) => Skeletonizer(
                            enabled: true,
                            child: GenreCard(
                              index: index,
                              genre: const GenreModel(
                                name: 'Loading...',
                                countOfBeats: 0,
                                key: '',
                                isSelected: false,
                                photoUrl: '',
                              ),
                              onToggle: () {},
                            ),
                          ),
                        );
                      }

                      return SliverGrid.builder(
                        itemCount: state.genres.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent:
                              (size.width - (paddingWidth * 2) - 10) / 3,
                        ),
                        itemBuilder: (_, index) => GenreCard(
                          index: index,
                          genre: state.genres[index],
                          onToggle: () {
                            context.read<GenreCubit>().toggleGenreSelection(
                                  state.genres[index],
                                );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            color: AppColors.background,
            child: ElevatedButton(
              onPressed: () {
                if (context
                    .read<GenreCubit>()
                    .state
                    .selectedGenres
                    .isNotEmpty) {
                  context.read<FilterBloc>().add(const ToggleFilter(0));
                }
                context.router.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const SizedBox(
                height: 46,
                child: Center(
                  child: Text(
                    'Сохранить выбор',
                    style: AppTextStyles.headline1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          TextFormField(
            textAlignVertical: TextAlignVertical.center,
            // controller: textController1,
            obscureText: false,
            autofocus: false,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: AppColors.iconSecondary),
              hintText: 'Жанры',
              hintStyle: AppTextStyles.filterTextField,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.focusedBorderTextField,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0x00000000),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0x00000000),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              filled: true,
              fillColor: AppColors.backgroundFilterTextField,
              contentPadding: const EdgeInsets.only(
                left: 12,
                right: 12,
                top: 7,
                bottom: 7,
              ),
            ),
            onChanged: (value) =>
                context.read<GenreCubit>().searchGenres(value),
            style: AppTextStyles.filterTextField,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Выберите жанры", style: AppTextStyles.headline2),
              MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  context.read<GenreCubit>().clearSelection();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Очистить все",
                  style: AppTextStyles.bodyPrice1.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 144.0;

  @override
  double get minExtent => 144.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
