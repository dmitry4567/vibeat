import 'package:bloc/bloc.dart';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:vibeat/filter/screen/filter_tag/model/tag_model.dart';

part 'tag_state.dart';

class TagCubit extends Cubit<TagState> {
  List<TagModel> _originalTags = [];

  TagCubit() : super(TagInitial()) {
    loadInitialTags();
  }

  void loadInitialTags() async {
    try {
      emit(TagLoading());

      final response = await http
          .get(Uri.parse('http://192.168.0.140:3000/music/filters/tags'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _originalTags = data.map((json) => TagModel.fromJson(json)).toList();
        emit(TagLoaded(
          tags: _originalTags,
          selectedTags: const [],
        ));
      }
    } catch (e) {
      emit(TagError());
    }
  }

  void searchTags(String query) {
    if (state is TagLoaded) {
      final currentState = state as TagLoaded;

      if (query.isEmpty) {
        emit(TagLoaded(
          tags: _originalTags.map((genre) {
            final isSelected = currentState.selectedTags
                .any((selected) => selected.name == genre.name);
            return genre.copyWith(isSelected: isSelected);
          }).toList(),
          selectedTags: currentState.selectedTags,
          searchQuery: '',
        ));
        return;
      }

      final filteredGenres = _originalTags
          .where(
              (genre) => genre.name.toLowerCase().contains(query.toLowerCase()))
          .map((genre) {
        final isSelected = currentState.selectedTags
            .any((selected) => selected.name == genre.name);
        return genre.copyWith(isSelected: isSelected);
      }).toList();

      emit(TagLoaded(
        tags: filteredGenres,
        selectedTags: currentState.selectedTags,
        searchQuery: query,
      ));
    }
  }

  void toggleTagSelection(TagModel tag) {
    if (state is TagLoaded) {
      final currentState = state as TagLoaded;
      final isAlreadySelected = currentState.selectedTags
          .any((selectedTag) => selectedTag.name == tag.name);

      List<TagModel> updatedSelected = List.from(currentState.selectedTags);
      List<TagModel> updatedTags = currentState.tags.map((g) {
        if (g.name == tag.name) {
          return g.copyWith(isSelected: !isAlreadySelected);
        }
        return g;
      }).toList();

      if (isAlreadySelected) {
        updatedSelected.removeWhere((t) => t.name == tag.name);
      } else {
        updatedSelected.add(tag.copyWith(isSelected: true));
      }

      emit(TagLoaded(
        tags: updatedTags,
        selectedTags: updatedSelected,
        searchQuery: currentState.searchQuery,
      ));
    }
  }

  void clearSelection() {
    if (state is TagLoaded) {
      final currentState = state as TagLoaded;

      // Reset all genres' selection state
      final clearedGenres = currentState.tags
          .map((tag) => tag.copyWith(isSelected: false))
          .toList();

      emit(TagLoaded(
        tags: clearedGenres,
        selectedTags: const [], // Clear selected genres
        searchQuery: currentState.searchQuery,
      ));
    }
  }
}
