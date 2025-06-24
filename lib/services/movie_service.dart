import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieService {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  
  // Mock movie data with working placeholder images from Picsum
  static final List<Map<String, dynamic>> _mockMoviesData = [
    {
      'id': 1,
      'title': 'The Matrix',
      'overview': 'A computer programmer is led to fight an underground war against powerful computers who have constructed his entire reality with a system called the Matrix.',
      'poster_path': 'https://picsum.photos/500/750?random=1',
      'backdrop_path': 'https://picsum.photos/780/439?random=11',
      'release_date': '2024-03-15',
      'vote_average': 8.7,
    },
    {
      'id': 2,
      'title': 'Inception',
      'overview': 'A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.',
      'poster_path': 'https://picsum.photos/500/750?random=2',
      'backdrop_path': 'https://picsum.photos/780/439?random=12',
      'release_date': '2024-04-20',
      'vote_average': 8.8,
    },
    {
      'id': 3,
      'title': 'Interstellar',
      'overview': 'A team of explorers travel through a wormhole in space in an attempt to ensure humanity\'s survival.',
      'poster_path': 'https://picsum.photos/500/750?random=3',
      'backdrop_path': 'https://picsum.photos/780/439?random=13',
      'release_date': '2024-05-10',
      'vote_average': 8.6,
    },
    {
      'id': 4,
      'title': 'The Dark Knight',
      'overview': 'Batman raises the stakes in his war on crime with the help of Lt. Jim Gordon and District Attorney Harvey Dent.',
      'poster_path': 'https://picsum.photos/500/750?random=4',
      'backdrop_path': 'https://picsum.photos/780/439?random=14',
      'release_date': '2024-02-28',
      'vote_average': 9.0,
    },
    {
      'id': 5,
      'title': 'Pulp Fiction',
      'overview': 'The lives of two mob hitmen, a boxer, a gangster and his wife intertwine in four tales of violence and redemption.',
      'poster_path': 'https://picsum.photos/500/750?random=5',
      'backdrop_path': 'https://picsum.photos/780/439?random=15',
      'release_date': '2024-01-15',
      'vote_average': 8.9,
    },
    {
      'id': 6,
      'title': 'Fight Club',
      'overview': 'An insomniac office worker and a devil-may-care soap maker form an underground fight club.',
      'poster_path': 'https://picsum.photos/500/750?random=6',
      'backdrop_path': 'https://picsum.photos/780/439?random=16',
      'release_date': '2024-06-05',
      'vote_average': 8.8,
    },
    {
      'id': 7,
      'title': 'Forrest Gump',
      'overview': 'The presidencies of Kennedy and Johnson, the Vietnam War, and other historical events unfold from the perspective of an Alabama man.',
      'poster_path': 'https://picsum.photos/500/750?random=7',
      'backdrop_path': 'https://picsum.photos/780/439?random=17',
      'release_date': '2024-03-22',
      'vote_average': 8.8,
    },
    {
      'id': 8,
      'title': 'The Godfather',
      'overview': 'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.',
      'poster_path': 'https://picsum.photos/500/750?random=8',
      'backdrop_path': 'https://picsum.photos/780/439?random=18',
      'release_date': '2024-04-12',
      'vote_average': 9.2,
    },
    {
      'id': 9,
      'title': 'The Shawshank Redemption',
      'overview': 'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.',
      'poster_path': 'https://picsum.photos/500/750?random=9',
      'backdrop_path': 'https://picsum.photos/780/439?random=19',
      'release_date': '2024-05-18',
      'vote_average': 9.3,
    },
    {
      'id': 10,
      'title': 'Goodfellas',
      'overview': 'The story of Henry Hill and his life in the mob, covering his relationship with his wife Karen Hill.',
      'poster_path': 'https://picsum.photos/500/750?random=10',
      'backdrop_path': 'https://picsum.photos/780/439?random=20',
      'release_date': '2024-06-01',
      'vote_average': 8.7,
    },
  ];

  Future<MoviesResponse> getPopularMovies({int page = 1}) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Calculate pagination
      const moviesPerPage = 10;
      final startIndex = (page - 1) * moviesPerPage;
      final endIndex = startIndex + moviesPerPage;
      
      // Generate more movies if needed
      List<Map<String, dynamic>> allMovies = [];
      
      // Repeat the base movies to simulate more content
      for (int i = 0; i < 5; i++) {
        allMovies.addAll(_mockMoviesData.map((movie) {
          final newId = movie['id'] + (i * 10);
          return {
            ...movie,
            'id': newId,
            'title': '${movie['title']} ${i > 0 ? '(${i + 1})' : ''}',
            'poster_path': 'https://picsum.photos/500/750?random=${newId + 100}',
            'backdrop_path': 'https://picsum.photos/780/439?random=${newId + 200}',
          };
        }));
      }
      
      final pageMovies = allMovies.skip(startIndex).take(moviesPerPage).toList();
      final movies = pageMovies.map((json) => Movie.fromJson(json)).toList();
      
      return MoviesResponse(
        movies: movies,
        page: page,
        totalPages: (allMovies.length / moviesPerPage).ceil(),
      );
    } catch (e) {
      throw Exception('Failed to load movies: $e');
    }
  }

  Future<Movie> getMovieDetails(int movieId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Find the movie from our mock data or create a detailed version
      final baseMovieId = movieId % 10;
      final baseIndex = baseMovieId == 0 ? 9 : baseMovieId - 1;
      final baseMovie = _mockMoviesData[baseIndex];
      
      final seriesNumber = (movieId - 1) ~/ 10;
      final title = seriesNumber > 0 
          ? '${baseMovie['title']} (${seriesNumber + 1})'
          : baseMovie['title'];
      
      return Movie(
        id: movieId,
        title: title,
        overview: '${baseMovie['overview']}\n\nThis is an extended version of the movie description with more details about the plot, characters, and cinematic elements that make this film a masterpiece. The movie explores deep themes and provides an engaging experience for viewers of all ages.',
        posterPath: 'https://picsum.photos/500/750?random=${movieId + 100}',
        releaseDate: baseMovie['release_date'],
        voteAverage: baseMovie['vote_average'],
        backdropPath: 'https://picsum.photos/780/439?random=${movieId + 200}',
      );
    } catch (e) {
      throw Exception('Failed to load movie details: $e');
    }
  }
}