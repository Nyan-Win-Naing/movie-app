import 'dart:async';

import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/data/models/movie_model_impl.dart';
import 'package:movie_app/data/vos/actor_vo.dart';
import 'package:movie_app/data/vos/movie_vo.dart';

class MovieDetailsBloc {
  /// Stream Controllers
  StreamController<MovieVO> movieStreamController = StreamController();
  StreamController<List<ActorVO>> creatorsStreamController = StreamController();
  StreamController<List<ActorVO>> actorsStreamController = StreamController();

  /// Models
  MovieModel mMovieModel = MovieModelImpl();

  MovieDetailsBloc(int movieId) {
    /// Movie Details
    mMovieModel.getMovieDetails(movieId).then((movie) {
      movieStreamController.sink.add(movie);
    });

    /// Movie Details Database
    mMovieModel.getMovieDetailsFromDatabase(movieId).then((movie) {
      movieStreamController.sink.add(movie);
    });

    mMovieModel.getCreditsByMovie(movieId).then((creditsList) {
      print("Credits list in details bloc: $creditsList");
      actorsStreamController.sink.add(creditsList.first ?? []);
      creatorsStreamController.sink.add(creditsList[1] ?? []);
    });
  }

  void dispose() {
    movieStreamController.close();
    creatorsStreamController.close();
    actorsStreamController.close();
  }
}
