import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../model/filterItem_model.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  List<String> listOfFilter = [
    "Жанры",
    "Тэги",
    "Цена",
    "Bpm",
    "Тональность",
    "Настроение",
    "Продолжительность",
  ];

  FilterBloc() : super(FilterState.initial()) {
    on<FilterEvent>((event, emit) async {});

    on<ToggleFilter>((event, emit) async {
      final updatedFilters = List<FilterItem>.from(state.filters);

      final currentItem = updatedFilters[event.index];
      updatedFilters[event.index] = currentItem.copyWith(
        choose: event.value,
      );

      emit(state.copyWith(filters: updatedFilters));
    });

    on<CleanFilter>(
      (event, emit) {
        final updatedFilters = List<FilterItem>.from(state.filters);

        for (var i = 0; i < state.filters.length; i++) {
          final currentItem = updatedFilters[i];
          updatedFilters[i] = currentItem.copyWith(
            choose: false,
          );
        }

        emit(state.copyWith(filters: updatedFilters));
      },
    );
  }
}
