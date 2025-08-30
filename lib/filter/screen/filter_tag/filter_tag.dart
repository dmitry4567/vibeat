import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vibeat/filter/bloc/filter_bloc.dart';
import 'package:vibeat/filter/screen/filter_tag/bloc/tag_bloc.dart';
import 'package:vibeat/filter/screen/filter_tag/model/tag_model.dart';
import 'package:vibeat/filter/screen/filter_tag/widgets/tag_card.dart';
import 'package:vibeat/utils/random_word_generator.dart';
import 'package:vibeat/utils/theme.dart';

import '../widgets/error_placeholder.dart';

@RoutePage()
class FilterTagScreen extends StatefulWidget {
  const FilterTagScreen({super.key});

  @override
  State<FilterTagScreen> createState() => _FilterTagScreenState();
}

class _FilterTagScreenState extends State<FilterTagScreen> {
  @override
  void initState() {
    super.initState();

    context.read<TagBloc>().add(GetTrendTags());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
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
                  BlocBuilder<TagBloc, TagState>(
                    buildWhen: (previous, current) =>
                        previous.selectedTags != current.selectedTags ||
                        previous.tags != current.tags,
                    builder: (context, state) {
                      if (state.error) {
                        return const SliverFillRemaining(
                          child: ErrorPlaceholder(),
                        );
                      }

                      if (state.loading) {
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
                                      id: '1',
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
                      } else {
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
                                      id: state.tags[index].id,
                                      name: state.tags[index].name,
                                      isSelected: state.tags[index].isSelected,
                                    ),
                                    onToggle: () {
                                      context.read<TagBloc>().add(
                                          ChooseTag(tag: state.tags[index]));
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }
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
                if (context.read<TagBloc>().state.selectedTags.isNotEmpty) {
                  context.read<FilterBloc>().add(const ToggleFilter(1, true));
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
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          DebounceTextField(
            hintText: 'Тэги',
            onDebouncedTextChanged: (text) {
              context.read<TagBloc>().add(SearchQuery(query: text));
            },
          ),
          const SizedBox(height: 24),
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
                  context.read<TagBloc>().add(CleanTags());
                  
                  context.read<FilterBloc>().add(const ToggleFilter(1, false));
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

class DebounceTextField extends StatefulWidget {
  final ValueChanged<String>? onDebouncedTextChanged;
  final String hintText;

  const DebounceTextField({
    super.key,
    this.onDebouncedTextChanged,
    required this.hintText,
  });

  @override
  _DebounceTextFieldState createState() => _DebounceTextFieldState();
}

class _DebounceTextFieldState extends State<DebounceTextField> {
  final TextEditingController _textController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _textController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onTextChanged(String text) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 0), () {
      if (widget.onDebouncedTextChanged != null) {
        widget.onDebouncedTextChanged!(text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlignVertical: TextAlignVertical.center,
      obscureText: false,
      autofocus: false,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.search,
          color: AppColors.iconSecondary,
        ),
        hintText: widget.hintText,
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
      controller: _textController,
      onChanged: _onTextChanged,
      onFieldSubmitted: (value) =>
          context.read<TagBloc>().add(SearchQuery(query: value)),
      style: AppTextStyles.filterTextField,
      keyboardType: TextInputType.text,
    );
  }
}
