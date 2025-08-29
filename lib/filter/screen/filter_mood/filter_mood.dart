import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vibeat/filter/bloc/filter_bloc.dart';
import 'package:vibeat/filter/screen/filter_key/model/key_model.dart';
import 'package:vibeat/filter/screen/filter_key/widgets/key_card.dart';
import 'package:vibeat/filter/screen/filter_mood/cubit/mood_cubit.dart';
import 'package:vibeat/utils/theme.dart';

import '../widgets/error_placeholder.dart';

@RoutePage()
class FilterMoodScreen extends StatefulWidget {
  const FilterMoodScreen({super.key});

  @override
  State<FilterMoodScreen> createState() => _FilterMoodScreenState();
}

class _FilterMoodScreenState extends State<FilterMoodScreen> {
  late final TextEditingController textController;

  @override
  void initState() {
    super.initState();

    textController = TextEditingController();
    textController.text = '';

    context.read<MoodCubit>().searchMoods(textController.text);
  }

  @override
  void dispose() {
    super.dispose();

    textController.dispose();
  }

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
                    delegate: _FilterHeaderDelegate(textController),
                  ),
                  BlocBuilder<MoodCubit, MoodState>(
                    buildWhen:
                        (previous, current) =>
                            previous.selectedMoods != current.selectedMoods ||
                            previous.moods != current.moods,
                    builder: (context, state) {
                      if (state is MoodError) {
                        return const SliverFillRemaining(
                          child: ErrorPlaceholder(),
                        );
                      } else if (state is MoodLoading) {
                        return SliverList.builder(
                          itemCount: 8,
                          itemBuilder:
                              (_, index) => Skeletonizer(
                                enabled: true,
                                child: KeyCard(
                                  index: index,
                                  keyData: const KeyModel(
                                    name: 'Loading...',
                                    key: '',
                                    isSelected: false,
                                  ),
                                  onToggle: () {},
                                ),
                              ),
                        );
                      }

                      return SliverList.builder(
                        itemCount: state.moods.length,
                        itemBuilder:
                            (_, index) => Skeletonizer(
                              enabled: false,
                              child: KeyCard(
                                index: index,
                                keyData: state.moods[index],
                                onToggle: () {
                                  context.read<MoodCubit>().toggleMoodSelection(
                                    state.moods[index],
                                  );
                                },
                              ),
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
                if (context.read<MoodCubit>().state.selectedMoods.isNotEmpty) {
                  context.read<FilterBloc>().add(const ToggleFilter(4, true));
                }

                context.maybePop();
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
  const _FilterHeaderDelegate(this.textController);

  final TextEditingController textController;

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
            controller: textController,
            obscureText: false,
            autofocus: false,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: AppColors.iconSecondary),
              hintText: 'Настроение',
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
            onChanged: (value) {
              context.read<MoodCubit>().searchMoods(value);
            },
            style: AppTextStyles.filterTextField,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Выберите настроение", style: AppTextStyles.headline2),
              MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  context.read<MoodCubit>().clearSelection();
                  context.read<FilterBloc>().add(const ToggleFilter(4, false));
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
