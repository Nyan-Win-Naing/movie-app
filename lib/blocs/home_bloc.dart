import 'package:flutter/foundation.dart';
import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/data/models/movie_model_impl.dart';
import 'package:movie_app/data/vos/actor_vo.dart';
import 'package:movie_app/data/vos/genre_vo.dart';
import 'package:movie_app/data/vos/movie_vo.dart';

class HomeBloc extends ChangeNotifier {
  /// States
  List<MovieVO>? mNowPlayingMovieList;
  List<MovieVO>? mPopularMoviesList;
  List<GenreVO>? mGenreList;
  List<ActorVO>? mActors;
  List<MovieVO>? mShowCaseMovieList;
  List<MovieVO>? mMoviesByGenreList;

  /// Page
  int pageForNowPlayingMovies = 1;

  /// Model
  MovieModel mMovieModel = MovieModelImpl();

  HomeBloc([MovieModel? movieModel]) {
    /// Set Mock Model For Test Data
    if(movieModel != null) {
      mMovieModel = movieModel;
    }


    /// Now Playing Movies Database
    mMovieModel.getNowPlayingMoviesFromDatabase().listen((movieList) {
      mNowPlayingMovieList = movieList;
      notifyListeners();
    }).onError((error) {
      debugPrint(error.toString());
    });

    /// Popular Movies Database
    mMovieModel.getPopularMoviesFromDatabase().listen((movieList) {
      mPopularMoviesList = movieList;
      notifyListeners();
    }).onError((error) {
      debugPrint(error.toString());
    });

    /// Genres
    mMovieModel.getGenres().then((genreList) {
      mGenreList = genreList;

      /// Movies By Genre
      _getMoviesByGenreAndRefresh(mGenreList?.first.id ?? 0);
    }).catchError((error) {
      debugPrint(error.toString());
    });


    /// Genres Database
    mMovieModel.getGenresFromDatabase().then((genreList) {
      mGenreList = genreList;

      /// Movies By Genre
      _getMoviesByGenreAndRefresh(mGenreList?.first.id ?? 0);
    }).catchError((error) {
      debugPrint(error.toString());
    });

    /// Showcases Database
    mMovieModel.getTopRatedMoviesFromDatabase().listen((movieList) {
      mShowCaseMovieList = movieList;
      notifyListeners();
    }).onError((error) {
      debugPrint(error.toString());
    });

    /// Actors
    mMovieModel.getActors(1).then((actorList) {
      mActors = actorList;
      notifyListeners();
    }).catchError((error) {
      debugPrint(error.toString());
    });

    /// Actors Database
    mMovieModel.getAllActorsFromDatabase().then((actorList) {
      mActors = actorList;
      notifyListeners();
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }

  void onTapGenre(int genreId) {
    _getMoviesByGenreAndRefresh(genreId);
  }

  void _getMoviesByGenreAndRefresh(int genreId) {
    mMovieModel.getMoviesByGenre(genreId).then((moviesByGenre) {
      mMoviesByGenreList = moviesByGenre;
      notifyListeners();
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }

  void onNowPlayingMovieListEndReached() {
    this.pageForNowPlayingMovies += 1;
    mMovieModel.getNowPlayingMovies(pageForNowPlayingMovies);
  }

}