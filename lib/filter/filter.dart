import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibeat/app/app_router.gr.dart';
import 'package:vibeat/filter/bloc/filter_bloc.dart';
import 'package:vibeat/filter/screen/filter_bpm/cubit/bpm_cubit.dart';
import 'package:vibeat/filter/screen/filter_genre/cubit/genre_cubit.dart';
import 'package:vibeat/filter/screen/filter_key/cubit/key_cubit.dart';
import 'package:vibeat/filter/screen/filter_mood/cubit/mood_cubit.dart';
import 'package:vibeat/filter/screen/filter_tag/cubit/tag_cubit.dart';
import 'package:vibeat/player/bloc/player_bloc.dart';
import 'package:vibeat/utils/theme.dart';

@RoutePage()
class FilterScreen extends StatelessWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 80,
                    ),
                    sliver: BlocBuilder<FilterBloc, FilterState>(
                      builder: (context, state) {
                        return SliverList.builder(
                          itemCount: state.filters.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                context.router.pushNamed(
                                    "search/${state.filters[index].pathScreen}");
                              },
                              child: Container(
                                color: Colors.transparent,
                                margin: const EdgeInsets.only(bottom: 18),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(50)),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.4),
                                          width: 1,
                                        ),
                                      ),
                                      child: Icon(
                                        state.filters[index].iconName,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      state.filters[index].name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                        letterSpacing: -0.41,
                                        height: 0.9,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 80),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            color: AppColors.background,
            child: ElevatedButton(
              onPressed: () {
                final genres =
                    context.read<GenreCubit>().state.selectedGenres.toString();
                final tags =
                    context.read<TagCubit>().state.selectedTags.toString();
                final bpmFrom = context.read<BpmCubit>().state.from.toString();
                final bpmTo = context.read<BpmCubit>().state.to.toString();
                final keys =
                    context.read<KeyCubit>().state.selectedKeys.toString();
                final moods =
                    context.read<MoodCubit>().state.selectedMoods.toString();

                print(genres);
                print(tags);
                print(bpmFrom);
                print(bpmTo);
                print(keys);
                print(moods);

                context.router.push(const ResultRoute());
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
                    'Применить фильтры',
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
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Фильтры",
            style: AppTextStyles.headline2,
          ),
          MaterialButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "Очистить все",
              style:
                  AppTextStyles.bodyPrice1.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 64.0;

  @override
  double get minExtent => 64.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
