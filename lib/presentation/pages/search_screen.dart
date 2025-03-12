import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_book/presentation/bloc/movie/movie_bloc.dart';
import 'package:recipe_book/presentation/bloc/movie/movie_event.dart';
import 'package:recipe_book/presentation/bloc/movie/movie_state.dart';
import 'package:recipe_book/widget/movie_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }


  void _onSearchChanged() {
    final query = _searchController.text;

    // Cancel the previous timer if there is one
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    // Start a new debounce timer
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        context.read<MovieBloc>().add(SearchMovies(query));
      } else {
        context.read<MovieBloc>().add(FetchMovies());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search Movies',
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: _onSearchChanged,
            ),
          ),
          onSubmitted: (_) => _onSearchChanged(),
        ),
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is MovieLoaded) {
            if (state.movies.isEmpty) {
              return const Center(child: Text('No Movies Found'));
            }
            return ListView.builder(
              itemCount: state.movies.length,
              itemBuilder: (context, index) {
                final movie = state.movies[index];
                return MovieCard(movie: movie);
              },
            );
          } else if (state is MovieSearchLoaded) {
            if (state.movies.isEmpty) {
              return const Center(
                  child: Text('No Movies Found for this search'));
            }
            return ListView.builder(
              itemCount: state.movies.length,
              itemBuilder: (context, index) {
                final movie = state.movies[index];
                return MovieCard(movie: movie);
              },
            );
          } else {
            return const Center(child: Text('Search for Movies'));
          }
        },
      ),
    );
  }
}
