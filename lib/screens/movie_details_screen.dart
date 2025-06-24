import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../viewmodels/movie_details_viewmodel.dart';

class MovieDetailsScreen extends ConsumerWidget {
  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsState = ref.watch(movieDetailsViewModelProvider(movieId));

    return Scaffold(
      body: _buildBody(context, ref, detailsState),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, MovieDetailsState state) {
    if (state.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: ${state.error}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(movieDetailsViewModelProvider(movieId).notifier)
                    .loadMovieDetails(movieId),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final movie = state.movie!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: movie.fullBackdropPath,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.movie, size: 100),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  state.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: state.isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  ref.read(movieDetailsViewModelProvider(movieId).notifier)
                      .toggleFavorite();
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: movie.fullPosterPath,
                          width: 120,
                          height: 180,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Container(
                            width: 120,
                            height: 180,
                            color: Colors.grey[300],
                            child: const Icon(Icons.movie, size: 50),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  movie.voteAverage.toStringAsFixed(1),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Release Date: ${movie.releaseDate}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Overview',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.overview,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ref.read(movieDetailsViewModelProvider(movieId).notifier)
                            .toggleFavorite();
                      },
                      icon: Icon(
                        state.isFavorite ? Icons.favorite : Icons.favorite_border,
                      ),
                      label: Text(
                        state.isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state.isFavorite ? Colors.red : Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}