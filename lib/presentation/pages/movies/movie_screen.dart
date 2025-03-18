import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_book/bloc/movie/movie_bloc.dart';
import 'package:recipe_book/bloc/movie/movie_event.dart';
import 'package:recipe_book/bloc/movie/movie_state.dart';
import 'package:recipe_book/widget/movie_card.dart';

class MyMovieScreen extends StatefulWidget {
  const MyMovieScreen({super.key});

  @override
  State<MyMovieScreen> createState() => _MyMovieScreenState();
}

class _MyMovieScreenState extends State<MyMovieScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MovieBloc>().add(FetchMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is MovieLoaded) {
            if (state.movies.isEmpty) {
              return const Center(child: Text('No Movies Available'));
            }
            return ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Popular Movies',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 250,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.movies.length,
                    itemBuilder: (context, index) {
                      final movie = state.movies[index];
                      // return MovieCard(movie: movie);
                      return SizedBox(
                        width: 200, // Set a fixed width for the movie card
                        child: MovieCard(movie: movie),
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'All Movies',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(10.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: state.movies.length,
                  itemBuilder: (context, index) {
                    final movie = state.movies[index];
                    return MovieCard(movie: movie);
                  },
                ),
              ],
            );
          } else {
            return const Center(child: Text('No Movies Available'));
          }
        },
      ),
    );
  }
}
