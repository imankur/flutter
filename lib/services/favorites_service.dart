import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorite_movies';

  Future<List<Movie>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];

    return favoritesJson
        .map((json) => Movie.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> addToFavorites(Movie movie) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();

    if (!favorites.any((fav) => fav.id == movie.id)) {
      favorites.add(movie);
      final favoritesJson = favorites
          .map((movie) => jsonEncode(movie.toJson()))
          .toList();
      await prefs.setStringList(_favoritesKey, favoritesJson);
    }
  }

  Future<void> removeFromFavorites(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();

    favorites.removeWhere((movie) => movie.id == movieId);
    final favoritesJson = favorites
        .map((movie) => jsonEncode(movie.toJson()))
        .toList();
    await prefs.setStringList(_favoritesKey, favoritesJson);
  }

  Future<bool> isFavorite(int movieId) async {
    final favorites = await getFavorites();
    return favorites.any((movie) => movie.id == movieId);
  }
}
