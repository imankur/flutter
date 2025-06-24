import '../models/movie.dart';
import '../services/movie_service.dart';

class MovieRepository {
  final MovieService _movieService;

  MovieRepository(this._movieService);

  Future<MoviesResponse> getPopularMovies({int page = 1}) async {
    return await _movieService.getPopularMovies(page: page);
  }

  Future<Movie> getMovieDetails(int movieId) async {
    return await _movieService.getMovieDetails(movieId);
  }
}
