import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:vibeat/filter/screen/filter_genre/model/genre_model.dart';
import 'package:http/http.dart' as http;

part 'genre_state.dart';

class GenreCubit extends Cubit<GenreState> {
  List<GenreModel> _originalGenres = [];

  GenreCubit() : super(GenreInitial()) {
    loadInitialGenres();
  }

  void loadInitialGenres() async {
    try {
      emit(GenreLoading());

      final response = await http.get(
        Uri.parse('http://192.168.43.60:7772/api/metadata/genres'),
      );

      await Future.delayed(const Duration(milliseconds: 500));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        
        _originalGenres =
            data.map((json) => GenreModel.fromJson(json)).toList();
        emit(GenreLoaded(genres: _originalGenres, selectedGenres: const []));
      }
    } catch (e) {
      emit(GenreError());
    }
  }

  void searchGenres(String query) {
    if (state is GenreLoaded) {
      final currentState = state as GenreLoaded;

      if (query.isEmpty) {
        emit(
          GenreLoaded(
            genres: _originalGenres.map((genre) {
              final isSelected = currentState.selectedGenres.any(
                (selected) => selected.name == genre.name,
              );
              return genre.copyWith(isSelected: isSelected);
            }).toList(),
            selectedGenres: currentState.selectedGenres,
            searchQuery: '',
          ),
        );
        return;
      }

      final filteredGenres = _originalGenres
          .where(
        (genre) => genre.name.toLowerCase().contains(query.toLowerCase()),
      )
          .map((genre) {
        final isSelected = currentState.selectedGenres.any(
          (selected) => selected.name == genre.name,
        );
        return genre.copyWith(isSelected: isSelected);
      }).toList();

      emit(
        GenreLoaded(
          genres: filteredGenres,
          selectedGenres: currentState.selectedGenres,
          searchQuery: query,
        ),
      );
    }
  }

  void toggleGenreSelection(GenreModel genre) {
    // if (state is GenreLoaded) {
    final currentState = state as GenreLoaded;

    final isAlreadySelected = currentState.selectedGenres.any(
      (selectedGenre) => selectedGenre.name == genre.name,
    );

    List<GenreModel> updatedSelected = List.from(currentState.selectedGenres);
    List<GenreModel> updatedGenres = currentState.genres.map((g) {
      if (g.name == genre.name) {
        return g.copyWith(isSelected: !isAlreadySelected);
      }
      return g;
    }).toList();

    if (isAlreadySelected) {
      updatedSelected.removeWhere((g) => g.name == genre.name);
    } else {
      updatedSelected.add(genre.copyWith(isSelected: true));
    }

    emit(
      GenreLoaded(
        genres: updatedGenres,
        selectedGenres: updatedSelected,
        searchQuery: currentState.searchQuery,
      ),
    );
    // }
  }

  void clearSelection() {
    if (state is GenreLoaded) {
      final currentState = state as GenreLoaded;

      // Reset all genres' selection state
      final clearedGenres = currentState.genres
          .map((genre) => genre.copyWith(isSelected: false))
          .toList();

      emit(
        GenreLoaded(
          genres: clearedGenres,
          selectedGenres: const [], // Clear selected genres
          searchQuery: currentState.searchQuery,
        ),
      );
    }
  }
}
