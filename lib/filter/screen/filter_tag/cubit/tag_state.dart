part of 'tag_cubit.dart';

abstract class TagState extends Equatable {
  final List<TagModel> tags;
  final List<TagModel> selectedTags;
  final String searchQuery;

  const TagState({
    required this.tags,
    required this.selectedTags,
    this.searchQuery = '',
  });

  @override
  List<Object> get props => [tags, selectedTags, searchQuery];
}

class TagInitial extends TagState {
  TagInitial() : super(tags: [], selectedTags: []);
}

class TagLoading extends TagState {
  TagLoading() : super(tags: [], selectedTags: []);
}

class TagError extends TagState {
  TagError() : super(tags: [], selectedTags: []);
}

class TagLoaded extends TagState {
  const TagLoaded({
    required List<TagModel> tags,
    required List<TagModel> selectedTags,
    String searchQuery = '',
  }) : super(
          tags: tags,
          selectedTags: selectedTags,
          searchQuery: searchQuery,
        );
}
