part of 'tag_bloc.dart';

class TagState extends Equatable {
  final List<TagModel> tags;
  final List<TagModel> selectedTags;
  final String searchQuery;
  final bool loading;
  final bool error;
  final String errorString;

  const TagState({
    required this.tags,
    required this.selectedTags,
    required this.searchQuery,
    required this.loading,
    required this.error,
    required this.errorString,
  });

  @override
  List<Object> get props => [
        tags,
        selectedTags,
        searchQuery,
        loading,
        error,
        errorString,
      ];

  TagState copyWith({
    List<TagModel>? tags,
    List<TagModel>? selectedTags,
    String? searchQuery,
    bool? loading,
    bool? error,
    String? errorString,
  }) {
    return TagState(
      tags: tags ?? this.tags,
      selectedTags: selectedTags ?? this.selectedTags,
      searchQuery: searchQuery ?? this.searchQuery,
      loading: loading ?? this.loading,
      error: error ?? this.error,
      errorString: errorString ?? this.errorString,
    );
  }
}
