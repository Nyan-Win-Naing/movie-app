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
  void getNowPlayingMovies(int page);
  void getPopularMovies();
  void getTopRatedMovies();
  // void getGenres();
  Future<List<GenreVO>?> getGenres();
  Future<List<MovieVO>?> getMoviesByGenre(int genreId);
  Future<List<ActorVO>?> getActors(int page);
  Future<MovieVO> getMovieDetails(int movieId);
  Future<List<List<ActorVO>?>> getCreditsByMovie(int movieId);

  // Database
  Stream<List<MovieVO>> getTopRatedMoviesFromDatabase();
  Stream<List<MovieVO>> getNowPlayingMoviesFromDatabase();
  Stream<List<MovieVO>> getPopularMoviesFromDatabase();
  // Stream<List<MovieVO>> getNowPlayingMoviesFromDatabase();
  // Stream<List<MovieVO>> getPopularMoviesFromDatabase();
  // Stream<List<MovieVO>> getTopRatedMoviesFromDatabase();
  // void getNowPlayingMoviesFromDatabase();
  // void getPopularMoviesFromDatabase();
  // void getTopRatedMoviesFromDatabase();
  Future<List<GenreVO>> getGenresFromDatabase();
  Future<List<ActorVO>> getAllActorsFromDatabase();
  Future<MovieVO> getMovieDetailsFromDatabase(int movieId);
}