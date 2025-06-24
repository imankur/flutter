class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String releaseDate;
  final double voteAverage;
  final String backdropPath;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.backdropPath,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      releaseDate: json['release_date'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      backdropPath: json['backdrop_path'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'release_date': releaseDate,
      'vote_average': voteAverage,
      'backdrop_path': backdropPath,
    };
  }

  // Updated to handle both URL formats with better fallback
  String get fullPosterPath {
    if (posterPath.isEmpty) {
      return 'https://picsum.photos/500/750?random=${id + 1000}';
    }
    // If it's already a full URL, return as is
    if (posterPath.startsWith('http')) {
      return posterPath;
    }
    // Otherwise, construct TMDB URL
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }

  String get fullBackdropPath {
    if (backdropPath.isEmpty) {
      return 'https://picsum.photos/780/439?random=${id + 2000}';
    }
    // If it's already a full URL, return as is
    if (backdropPath.startsWith('http')) {
      return backdropPath;
    }
    // Otherwise, construct TMDB URL
    return 'https://image.tmdb.org/t/p/w780$backdropPath';
  }
}

class MoviesResponse {
  final List<Movie> movies;
  final int page;
  final int totalPages;

  MoviesResponse({
    required this.movies,
    required this.page,
    required this.totalPages,
  });

  factory MoviesResponse.fromJson(Map<String, dynamic> json) {
    return MoviesResponse(
      movies: (json['results'] as List)
          .map((movie) => Movie.fromJson(movie))
          .toList(),
      page: json['page'] ?? 1,
      totalPages: json['total_pages'] ?? 1,
    );
  }
}