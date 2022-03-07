import 'package:flutter/cupertino.dart';
import 'package:movie_app/data/vos/actor_vo.dart';
import 'package:movie_app/data/vos/genre_vo.dart';
import 'package:movie_app/data/vos/movie_vo.dart';
import 'package:scoped_model/scoped_model.dart';

abstract class MovieModel extends Model {
  // Network
  // Future<List<MovieVO>?> getNowPlayingMovies();
  // Future<List<MovieVO>?> getPopularMovies();
  // Future<List<MovieVO>?> getTopRatedMovies();
  void getNowPlayingMovies();
  void getPopularMovies();
  void getTopRatedMovies();
  void getGenres();
  void getMoviesByGenre(int genreId);
  void getActors(int page);
  void getMovieDetails(int movieId);
  void getCreditsByMovie(int movieId);

  // Database
  // Future<List<MovieVO>> getTopRatedMoviesFromDatabase();
  // Future<List<MovieVO>> getNowPlayingMoviesFromDatabase();
  // Future<List<MovieVO>> getPopularMoviesFromDatabase();
  // Stream<List<MovieVO>> getNowPlayingMoviesFromDatabase();
  // Stream<List<MovieVO>> getPopularMoviesFromDatabase();
  // Stream<List<MovieVO>> getTopRatedMoviesFromDatabase();
  void getNowPlayingMoviesFromDatabase();
  void getPopularMoviesFromDatabase();
  void getTopRatedMoviesFromDatabase();
  void getGenresFromDatabase();
  void getAllActorsFromDatabase();
  void getMovieDetailsFromDatabase(int movieId);
}