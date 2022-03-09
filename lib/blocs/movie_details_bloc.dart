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

  /// Model
  MovieModel mMovieModel = MovieModelImpl();

  MovieDetailsBloc(int movieId) {
    /// Movie Details
    mMovieModel.getMovieDetails(movieId).then((movie) {
      this.mMovie = movie;
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
}