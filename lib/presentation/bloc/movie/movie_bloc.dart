import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_book/api/movie.dart';
import 'package:recipe_book/presentation/bloc/movie/movie_event.dart';
import 'package:recipe_book/presentation/bloc/movie/movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieServices movieServices;

  MovieBloc(this.movieServices) : super(MovieInitial()) {
    on<FetchMovies>(_onFetchMovies);
    on<SearchMovies>(_onSearchMovies);
  }

  void _onFetchMovies(FetchMovies event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final movies = await movieServices.fetchMovies();
      emit(MovieLoaded(movies));
    } catch (e) {
      emit(MovieError(e.toString()));
    }
  }

  void _onSearchMovies(SearchMovies event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final movies = await movieServices.searchMovies(event.query);
      emit(MovieLoaded(movies));
    } catch (e) {
      emit(MovieError(e.toString()));
    }
  }
}
