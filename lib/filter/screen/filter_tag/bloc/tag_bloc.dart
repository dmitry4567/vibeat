import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vibeat/filter/screen/filter_tag/model/tag_model.dart';

part 'tag_state.dart';
part 'tag_event.dart';

class TagBloc extends Bloc<TagEvent, TagState> {
  List<TagModel> _trendTags = [];

  TagBloc()
      : super(const TagState(
          tags: [],
          selectedTags: [],
          searchQuery: '',
          loading: true,
          error: false,
          errorString: '',
        )) {
    on<GetTrendTags>((event, emit) async {
      try {
        final response = await http
            .get(Uri.parse('http://192.168.43.60:7772/api/metadata/tags'));

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body)['data'];

          _trendTags = data.map((json) => TagModel.fromJson(json)).toList();

          emit(state.copyWith(
            tags: state.selectedTags + _trendTags,
            loading: false,
          ));
        }
      } catch (e) {
        emit(state.copyWith(error: true));
      }
    });

    on<ChooseTag>((event, emit) async {
      final isAlreadySelected = state.selectedTags
          .any((selectedTag) => selectedTag.name == event.tag.name);

      List<TagModel> updatedSelected = List.from(state.selectedTags);
      List<TagModel> updatedTags = state.tags.map((g) {
        if (g.name == event.tag.name) {
          return g.copyWith(isSelected: !isAlreadySelected);
        }
        return g;
      }).toList();

      if (isAlreadySelected) {
        updatedSelected.removeWhere((t) => t.name == event.tag.name);
      } else {
        updatedSelected.add(event.tag.copyWith(isSelected: true));
      }

      emit(state.copyWith(
        tags: updatedTags,
        selectedTags: updatedSelected,
      ));
    });

    on<SearchQuery>((event, emit) async {
      if (event.query.isEmpty) {
        emit(state.copyWith(
          tags: state.selectedTags + _trendTags,
        ));

        return;
      }

      final response = await http.get(Uri.parse(
          'http://192.168.43.60:7772/api/metadata/tagsByName/${event.query}'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];

        List<TagModel> dataTags =
            data.map((json) => TagModel.fromJson(json)).toList();

        final filteredGenres = dataTags
            .where((genre) =>
                genre.name.toLowerCase().contains(event.query.toLowerCase()))
            .map((genre) {
          final isSelected =
              state.selectedTags.any((selected) => selected.name == genre.name);
          return genre.copyWith(isSelected: isSelected);
        }).toList();

        emit(state.copyWith(
          tags: filteredGenres,
          selectedTags: state.selectedTags,
          searchQuery: event.query,
        ));
      }
    });

    on<CleanTags>((event, emit) async {
      List<TagModel> updatedTags = state.tags.map((g) {
        g.isSelected = false;
        return g;
      }).toList();

      emit(state.copyWith(
        tags: updatedTags,
        selectedTags: const [],
      ));
    });
  }
}
