import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibeat/custom_functions.dart';
import 'package:vibeat/filter/bloc/filter_bloc.dart';
import 'package:vibeat/filter/screen/filter_bpm/cubit/bpm_cubit.dart';
import 'package:vibeat/utils/theme.dart';

@RoutePage()
class FilterBpmScreen extends StatefulWidget {
  const FilterBpmScreen({super.key});

  @override
  State<FilterBpmScreen> createState() => _FilterBpmScreenState();
}

class _FilterBpmScreenState extends State<FilterBpmScreen> {
  late TextEditingController _fromController;
  late TextEditingController _toController;

  @override
  void initState() {
    super.initState();
    _fromController = TextEditingController();
    _toController = TextEditingController();

    final state = context.read<BpmCubit>().state;

    if (state.from != 0) _fromController.text = state.from.toString();
    if (state.to != 0) _toController.text = state.to.toString();
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<BpmCubit>().updateBpm(
              _fromController.text,
              _toController.text,
            );

        if (_fromController.text != "" || _toController.text != "") {
          context.read<FilterBloc>().add(const ToggleFilter(2, true));
        }

        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.appbar,
          forceMaterialTransparency: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              print('Кнопка назад нажата');
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Выберите Bpm",
                    style: AppTextStyles.headline2,
                  ),
                  MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      context.read<BpmCubit>().clearSelection();
                      context
                          .read<FilterBloc>()
                          .add(const ToggleFilter(2, false));

                      _fromController.clear();
                      _toController.clear();
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
              const SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      controller: _fromController,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          context.read<BpmCubit>().changeFrom(int.parse(value));
                        }
                      },
                      obscureText: false,
                      autofocus: false,
                      decoration: InputDecoration(
                          hintText: '0',
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
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        letterSpacing: -0.41,
                        height: 0.6,
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      height: 1,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      controller: _toController,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          context.read<BpmCubit>().changeTo(int.parse(value));
                        }
                      },
                      obscureText: false,
                      autofocus: false,
                      decoration: InputDecoration(
                          hintText: '300',
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
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        letterSpacing: -0.41,
                        height: 0.6,
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                color: AppColors.background,
                child: ElevatedButton(
                  onPressed: () {
                    if (_fromController.text.isEmpty &&
                        _toController.text.isEmpty) {
                      return;
                    }

                    // if (int.parse(_fromController.text != ""
                    //         ? _fromController.text
                    //         : "0") >
                    //     int.parse(_toController.text != ""
                    //         ? _toController.text
                    //         : "0")) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     setupSnackBar("Неверные данные"),
                    //   );

                    //   return;
                    // }

                    context.read<BpmCubit>().updateBpm(
                          _fromController.text,
                          _toController.text,
                        );
                    context.read<FilterBloc>().add(const ToggleFilter(2, true));

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
        ),
      ),
    );
  }
}
