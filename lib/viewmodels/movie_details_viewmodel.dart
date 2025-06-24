import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';
import '../services/favorites_service.dart';
import 'movies_viewmodel.dart';

class MovieDetailsState {
  final Movie? movie;
  final bool isLoading;
  final String? error;
  final bool isFavorite;

  MovieDetailsState({
    this.movie,
    this.isLoading = false,
    this.error,
    this.isFavorite = false,
  });

  MovieDetailsState copyWith({
    Movie? movie,
    bool? isLoading,
    String? error,
    bool? isFavorite,
  }) {
    return MovieDetailsState(
      movie: movie ?? this.movie,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class MovieDetailsViewModel extends StateNotifier<MovieDetailsState> {
  final MovieRepository _repository;
  final FavoritesService _favoritesService;

  MovieDetailsViewModel(this._repository, this._favoritesService) 
      : super(MovieDetailsState());

  Future<void> loadMovieDetails(int movieId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final movie = await _repository.getMovieDetails(movieId);
      final isFavorite = await _favoritesService.isFavorite(movieId);

      state = state.copyWith(
        movie: movie,
        isLoading: false,
        isFavorite: isFavorite,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> toggleFavorite() async {
    if (state.movie == null) return;

    try {
      if (state.isFavorite) {
        await _favoritesService.removeFromFavorites(state.movie!.id);
      } else {
        await _favoritesService.addToFavorites(state.movie!);
      }

      state = state.copyWith(isFavorite: !state.isFavorite);
    } catch (e) {
      // Handle error
    }
  }
}

final movieDetailsViewModelProvider = StateNotifierProvider.family<MovieDetailsViewModel, MovieDetailsState, int>((ref, movieId) {
  final viewModel = MovieDetailsViewModel(
    ref.read(movieRepositoryProvider),
    ref.read(favoritesServiceProvider),
  );
  viewModel.loadMovieDetails(movieId);
  return viewModel;
});