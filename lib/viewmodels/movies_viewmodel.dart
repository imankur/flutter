import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';
import '../services/favorites_service.dart';
import '../services/movie_service.dart';

// Providers
final movieRepositoryProvider = Provider((ref) => MovieRepository(MovieService()));
final favoritesServiceProvider = Provider((ref) => FavoritesService());

// Movies State
class MoviesState {
  final List<Movie> movies;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final bool hasMore;

  MoviesState({
    this.movies = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
  });

  MoviesState copyWith({
    List<Movie>? movies,
    bool? isLoading,
    String? error,
    int? currentPage,
    bool? hasMore,
  }) {
    return MoviesState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

// Movies ViewModel
class MoviesViewModel extends StateNotifier<MoviesState> {
  final MovieRepository _repository;

  MoviesViewModel(this._repository) : super(MoviesState()) {
    loadMovies();
  }

  Future<void> loadMovies({bool refresh = false}) async {
    if (state.isLoading) return;

    if (refresh) {
      state = MoviesState(isLoading: true);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final response = await _repository.getPopularMovies(
        page: refresh ? 1 : state.currentPage,
      );

      final newMovies = refresh ? response.movies : [...state.movies, ...response.movies];

      state = state.copyWith(
        movies: newMovies,
        isLoading: false,
        currentPage: response.page + 1,
        hasMore: response.page < response.totalPages,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMoreMovies() async {
    if (state.hasMore && !state.isLoading) {
      await loadMovies();
    }
  }

  Future<void> refreshMovies() async {
    await loadMovies(refresh: true);
  }
}

final moviesViewModelProvider = StateNotifierProvider<MoviesViewModel, MoviesState>((ref) {
  return MoviesViewModel(ref.read(movieRepositoryProvider));
});