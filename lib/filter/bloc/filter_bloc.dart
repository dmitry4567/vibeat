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
  }
}
