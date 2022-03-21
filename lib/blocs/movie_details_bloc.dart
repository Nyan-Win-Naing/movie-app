import 'package:flutter/foundation.dart';
import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/data/models/movie_model_impl.dart';
import 'package:movie_app/data/vos/actor_vo.dart';
import 'package:movie_app/data/vos/movie_vo.dart';

class MovieDetailsBloc extends ChangeNotifier {
  /// State
  MovieVO? mMovie;
  List<ActorVO>? mActorsList;
  List<ActorVO>? mCreatorsList;
  List<MovieVO>? mRelatedMovies;

  /// Model
  MovieModel mMovieModel = MovieModelImpl();

  MovieDetailsBloc(int movieId) {
    /// Movie Details
    mMovieModel.getMovieDetails(movieId).then((movie) {
      this.mMovie = movie;
      this.getRelatedMovies(movie.genres?.first.id ?? 0);
      notifyListeners();
    });

    /// Movie Details Database
    mMovieModel.getMovieDetailsFromDatabase(movieId).then((movie) {
      this.mMovie = movie;
      notifyListeners();
    });

    /// Credits
    mMovieModel.getCreditsByMovie(movieId).then((creditsList) {
      this.mActorsList = creditsList.first ?? [];
      this.mCreatorsList = creditsList[1];
      notifyListeners();
    });
  }

  void getRelatedMovies(int genreId) {
    mMovieModel.getMoviesByGenre(genreId).then((relatedMovies) {
      mRelatedMovies = relatedMovies;
      notifyListeners();
    });
  }
}