import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vibeat/filter/screen/filter_key/cubit/key_cubit.dart';
import 'package:vibeat/filter/screen/filter_key/model/key_model.dart';
import 'package:vibeat/filter/screen/filter_key/widgets/key_card.dart';
import 'package:vibeat/utils/theme.dart';

@RoutePage()
class FilterKeyScreen extends StatelessWidget {
  const FilterKeyScreen({super.key});

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
                  BlocBuilder<KeyCubit, KeyState>(
                    buildWhen: (previous, current) =>
                        previous.selectedKeys != current.selectedKeys ||
                        previous.keys != current.keys,
                    builder: (context, state) {
                      if (state is KeyError) {
                        return const SliverFillRemaining(
                          child: Center(
                            child: Text('Error'),
                          ),
                        );
                      } else if (state is KeyLoading) {
                        return SliverList.builder(
                          itemCount: 8,
                          itemBuilder: (_, index) => Skeletonizer(
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
                        itemCount: state.keys.length,
                        itemBuilder: (_, index) => Skeletonizer(
                          enabled: false,
                          child: KeyCard(
                            index: index,
                            keyData: state.keys[index],
                            onToggle: () {
                              context
                                  .read<KeyCubit>()
                                  .toggleKeySelection(state.keys[index]);
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
                hintText: 'Ключ',
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
            onChanged: (value) => context.read<KeyCubit>().searchKeys(value),
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
                "Выберите тональность",
                style: AppTextStyles.headline2,
              ),
              MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  context.read<KeyCubit>().clearSelection();
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
