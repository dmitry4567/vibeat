part of 'genre_cubit.dart';

abstract class GenreState extends Equatable {
  final List<GenreModel> genres;
  final List<GenreModel> selectedGenres;
  final String searchQuery;

  const GenreState({
    required this.genres,
    required this.selectedGenres,
    this.searchQuery = '',
  });

  @override
  List<Object> get props => [genres, selectedGenres, searchQuery];
}

class GenreInitial extends GenreState {
  GenreInitial() : super(genres: [], selectedGenres: []);
}

class GenreLoading extends GenreState {
  GenreLoading() : super(genres: [], selectedGenres: []);
}

class GenreError extends GenreState {
  GenreError() : super(genres: [], selectedGenres: []);
}

class GenreLoaded extends GenreState {
  const GenreLoaded({
    required List<GenreModel> genres,
    required List<GenreModel> selectedGenres,
    String searchQuery = '',
  }) : super(
          genres: genres,
          selectedGenres: selectedGenres,
          searchQuery: searchQuery,
        );
}
