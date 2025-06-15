part of 'tag_bloc.dart';

abstract class TagEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetTrendTags extends TagEvent {}

class ChooseTag extends TagEvent {
  final TagModel tag;

  ChooseTag({required this.tag});

  @override
  List<Object?> get props => [tag];
}

class SearchQuery extends TagEvent {
  final String query;

  SearchQuery({required this.query});

  @override
  List<Object?> get props => [query];
}

class CleanTags extends TagEvent {}
