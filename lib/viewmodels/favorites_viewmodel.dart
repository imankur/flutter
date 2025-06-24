import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie.dart';
import '../services/favorites_service.dart';
import 'movies_viewmodel.dart';

class FavoritesState {
  final List<Movie> favorites;
  final bool isLoading;
  final String? error;

  FavoritesState({
    this.favorites = const [],
    this.isLoading = false,
    this.error,
  });

  FavoritesState copyWith({
    List<Movie>? favorites,
    bool? isLoading,
    String? error,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class FavoritesViewModel extends StateNotifier<FavoritesState> {
  final FavoritesService _favoritesService;

  FavoritesViewModel(this._favoritesService) : super(FavoritesState()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final favorites = await _favoritesService.getFavorites();
      state = state.copyWith(favorites: favorites, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> removeFromFavorites(int movieId) async {
    try {
      await _favoritesService.removeFromFavorites(movieId);
      await loadFavorites();
    } catch (e) {
      // Handle error
    }
  }
}

final favoritesViewModelProvider = StateNotifierProvider<FavoritesViewModel, FavoritesState>((ref) {
  return FavoritesViewModel(ref.read(favoritesServiceProvider));
});