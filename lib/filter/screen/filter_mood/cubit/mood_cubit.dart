import 'package:bloc/bloc.dart';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:vibeat/filter/screen/filter_mood/model/mood_model.dart';

part 'mood_state.dart';

class MoodCubit extends Cubit<MoodState> {
  List<MoodModel> _originalMoods = [];

  MoodCubit() : super(MoodInitial()) {
    loadInitialMoods();
  }

  void loadInitialMoods() async {
    try {
      emit(MoodLoading());

      final response = await http.get(
        Uri.parse('http://192.168.0.135:8080/metadata/moods'),
      );

      await Future.delayed(const Duration(milliseconds: 500));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];

        _originalMoods = data.map((json) => MoodModel.fromJson(json)).toList();
        emit(MoodLoaded(moods: _originalMoods, selectedMoods: const []));
      }
    } catch (e) {
      emit(MoodError());
    }
  }

  void searchMoods(String query) {
    if (state is MoodLoaded) {
      final currentState = state as MoodLoaded;

      if (query.isEmpty) {
        emit(
          MoodLoaded(
            moods: _originalMoods.map((mood) {
              final isSelected = currentState.selectedMoods.any(
                (selected) => selected.name == mood.name,
              );
              return mood.copyWith(isSelected: isSelected);
            }).toList(),
            selectedMoods: currentState.selectedMoods,
            searchQuery: '',
          ),
        );
        return;
      }

      final filteredMoods = _originalMoods
          .where(
        (mood) => mood.name.toLowerCase().contains(query.toLowerCase()),
      )
          .map((mood) {
        final isSelected = currentState.selectedMoods.any(
          (selected) => selected.name == mood.name,
        );
        return mood.copyWith(isSelected: isSelected);
      }).toList();

      emit(
        MoodLoaded(
          moods: filteredMoods,
          selectedMoods: currentState.selectedMoods,
          searchQuery: query,
        ),
      );
    }
  }

  void toggleMoodSelection(MoodModel mood) {
    if (state is MoodLoaded) {
      final currentState = state as MoodLoaded;
      final isAlreadySelected = currentState.selectedMoods.any(
        (selectedMood) => selectedMood.name == mood.name,
      );

      List<MoodModel> updatedSelected = List.from(currentState.selectedMoods);
      List<MoodModel> updatedMoods = currentState.moods.map((m) {
        if (m.name == mood.name) {
          return m.copyWith(isSelected: !isAlreadySelected);
        }
        return m;
      }).toList();

      if (isAlreadySelected) {
        updatedSelected.removeWhere((m) => m.name == mood.name);
      } else {
        updatedSelected.add(mood.copyWith(isSelected: true));
      }

      emit(
        MoodLoaded(
          moods: updatedMoods,
          selectedMoods: updatedSelected,
          searchQuery: currentState.searchQuery,
        ),
      );
    }
  }

  void clearSelection() {
    if (state is MoodLoaded) {
      final currentState = state as MoodLoaded;

      // Reset all Moods' selection state
      final clearedMoods = currentState.moods
          .map((mood) => mood.copyWith(isSelected: false))
          .toList();

      emit(
        MoodLoaded(
          moods: clearedMoods,
          selectedMoods: const [], // Clear selected Moods
          searchQuery: currentState.searchQuery,
        ),
      );
    }
  }
}
