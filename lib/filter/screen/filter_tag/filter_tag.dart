import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vibeat/filter/screen/filter_genre/cubit/genre_cubit.dart';
import 'package:vibeat/filter/screen/filter_tag/cubit/tag_cubit.dart';
import 'package:vibeat/filter/screen/filter_tag/model/tag_model.dart';
import 'package:vibeat/filter/screen/filter_tag/widgets/tag_card.dart';
import 'package:vibeat/utils/random_word_generator.dart';
import 'package:vibeat/utils/theme.dart';

import '../widgets/error_placeholder.dart';

@RoutePage()
class FilterTagScreen extends StatelessWidget {
  const FilterTagScreen({super.key});

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
                  BlocBuilder<TagCubit, TagState>(
                    buildWhen: (previous, current) =>
                        previous.selectedTags != current.selectedTags ||
                        previous.tags != current.tags,
                    builder: (context, state) {
                      if (state is TagError) {
                        return const SliverFillRemaining(
                          child: ErrorPlaceholder(),
                        );
                      }

                      if (state is TagLoading) {
                        return SliverToBoxAdapter(
                          child: Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: List.generate(
                              20,
                              (index) {
                                return Skeletonizer(
                                  enabled: true,
                                  child: TagCard(
                                    index: index,
                                    tag: TagModel(
                                      name: RandomWordGenerator.getRandomWord(),
                                      isSelected: false,
                                    ),
                                    onToggle: () {},
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }

                      return SliverToBoxAdapter(
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: List.generate(
                            state.tags.length,
                            (index) {
                              return Skeletonizer(
                                enabled: false,
                                child: TagCard(
                                  index: index,
                                  tag: TagModel(
                                    name: state.tags[index].name,
                                    isSelected: state.tags[index].isSelected,
                                  ),
                                  onToggle: () {
                                    context
                                        .read<TagCubit>()
                                        .toggleTagSelection(state.tags[index]);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            color: AppColors.background,
            child: ElevatedButton(
              onPressed: () {
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
      BuildContext context, double shrinkOffset, bool overlapsContent) {
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
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.iconSecondary,
                ),
                hintText: 'Тэги',
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
                )),
            onChanged: (value) => context.read<TagCubit>().searchTags(value),
            style: AppTextStyles.filterTextField,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Выберите тэги",
                style: AppTextStyles.headline2,
              ),
              MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  context.read<TagCubit>().clearSelection();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Очистить все",
                  style: AppTextStyles.bodyPrice1
                      .copyWith(color: AppColors.primary),
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
