import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/data/vos/actor_vo.dart';
import 'package:movie_app/data/vos/genre_vo.dart';
import 'package:movie_app/data/vos/movie_vo.dart';
import 'package:movie_app/network/dataagents/movie_data_agent.dart';
import 'package:movie_app/network/dataagents/retrofit_data_agent_impl.dart';
import 'package:movie_app/persistence/daos/impls/actor_dao_impl.dart';
import 'package:movie_app/persistence/daos/impls/genre_dao_impl.dart';
import 'package:movie_app/persistence/daos/impls/movie_dao_impl.dart';
import 'package:stream_transform/stream_transform.dart';

class MovieModelImpl extends MovieModel {
  static final MovieModelImpl _singleton = MovieModelImpl._internal();

  factory MovieModelImpl() {
    return _singleton;
  }

  MovieModelImpl._internal() {
    getNowPlayingMoviesFromDatabase();
    getTopRatedMoviesFromDatabase();
    getPopularMoviesFromDatabase();
    getActors(1);
    getAllActorsFromDatabase();
    getGenres();
    getGenresFromDatabase();
  }

  MovieDataAgent _dataAgent = RetrofitDataAgentImpl();

  /// Daos
  MovieDaoImpl mMovieDao = MovieDaoImpl();
  GenreDaoImpl mGenreDao = GenreDaoImpl();
  ActorDaoImpl mActorDao = ActorDaoImpl();

  /// Home Page State
  List<MovieVO>? mNowPlayingMovies;
  List<MovieVO>? popularMovies;
  List<MovieVO>? topRatedMovies;
  List<MovieVO>? moviesByGenre;
  List<GenreVO>? genres;
  List<ActorVO>? actors;

  /// Movie Details Page State
  MovieVO? movieDetails;
  List<ActorVO>? cast;
  List<ActorVO>? crew;

  // Network
  @override
  void getNowPlayingMovies(int page) {
    _dataAgent.getNowPlayingMovies(page).then((movies) async {
      List<MovieVO>? nowPlayingMovies = movies?.map((movie) {
        movie.isNowPlaying = true;
        movie.isPopular = false;
        movie.isTopRated = false;
        return movie;
      }).toList();
      mMovieDao.saveMovies(nowPlayingMovies);
      // mNowPlayingMovies = nowPlayingMovies;
      // notifyListeners();
    });
  }

  @override
  void getPopularMovies() {
    _dataAgent.getPopularMovies(1).then((movies) async {
      List<MovieVO>? popularMovies = movies?.map((movie) {
        movie.isPopular = true;
        movie.isNowPlaying = false;
        movie.isTopRated = false;
        return movie;
      }).toList();
      mMovieDao.saveMovies(popularMovies);
      // this.popularMovies = popularMovies;
      // notifyListeners();
    });
  }

  @override
  void getTopRatedMovies() {
    _dataAgent.getTopRatedMovies(1).then((movies) async {
      List<MovieVO>? topRatedMovies = movies?.map((movie) {
        movie.isTopRated = true;
        movie.isPopular = false;
        movie.isNowPlaying = false;
        return movie;
      }).toList();

      mMovieDao.saveMovies(topRatedMovies);
      // this.topRatedMovies = topRatedMovies;
      // notifyListeners();
    });
  }

  @override
  Future<List<ActorVO>?> getActors(int page) {
    return _dataAgent.getActors(page).then((actors) async {
      mActorDao.saveAllActors(actors);
      // this.actors = actors;
      // notifyListeners();
      return Future.value(actors);
    });
  }

  @override
  Future<List<GenreVO>> getGenres() {
    return _dataAgent.getGenres().then((genres) async {
      mGenreDao.saveAllGenres(genres);
      // this.genres = genres;
      // getMoviesByGenre(genres?.first.id ?? 0);
      // notifyListeners();
      return Future.value(genres);
    });
  }

  @override
  Future<List<MovieVO>?> getMoviesByGenre(int genreId) {
    // return _dataAgent.getMoviesByGenre(genreId).then((moviesList) {
    //   moviesByGenre = moviesList;
    //   notifyListeners();
    // });
    return _dataAgent.getMoviesByGenre(genreId);
  }

  @override
  Future<List<List<ActorVO>?>> getCreditsByMovie(int movieId) {
    // _dataAgent.getCreditsByMovie(movieId).then((castAndCrew) {
    //   cast = castAndCrew.first;
    //   crew = castAndCrew[1];
    //   notifyListeners();
    // });
    return _dataAgent.getCreditsByMovie(movieId);
  }

  @override
  Future<MovieVO> getMovieDetails(int movieId) {
    // _dataAgent.getMovieDetails(movieId).then((movie) async {
    //   mMovieDao.saveSingleMovie(movie);
    //   movieDetails = movie;
    //   notifyListeners();
    //   return Future.value(movie);
    // });

    return _dataAgent.getMovieDetails(movieId).then((movie) async {
      mMovieDao.saveSingleMovie(movie);
      return Future.value(movie);
    });
  }

  // Database
  @override
  Future<List<ActorVO>> getAllActorsFromDatabase() {
    // actors = mActorDao.getAllActors();
    // notifyListeners();
    return Future.value(mActorDao.getAllActors());
  }

  @override
  Future<List<GenreVO>> getGenresFromDatabase() {
    return Future<List<GenreVO>>.value(mGenreDao.getAllGenres());
    // genres = mGenreDao.getAllGenres();
    // notifyListeners();
  }

  @override
  Future<MovieVO> getMovieDetailsFromDatabase(int movieId) {
    return Future.value(mMovieDao.getMovieById(movieId));
    // movieDetails = mMovieDao.getMovieById(movieId);
    // notifyListeners();
  }

  // @override
  // Future<List<MovieVO>> getNowPlayingMoviesFromDatabase() {
  //   // return Future.value(mMovieDao
  //   //     .getAllMovies()
  //   //     .where((movie) => movie.isNowPlaying ?? true)
  //   //     .toList());
  //   this.getNowPlayingMovies();
  //   return mMovieDao
  //       .getAllMoviesEventStream()
  //       .startWith(mMovieDao.getNowPlayingMoviesStream())
  //       .combineLatest(mMovieDao.getNowPlayingMoviesStream(),
  //           (event, movieList) => movieList as List<MovieVO>)
  //       .first
  //       .then((nowPlayingMovies) {
  //     mNowPlayingMovies = nowPlayingMovies;
  //     notifyListeners();
  //     return Future.value(mNowPlayingMovies);
  //   });
  // }

  // @override
// Future<List<MovieVO>> getPopularMoviesFromDatabase() {
//   // return Future.value(mMovieDao
//   //     .getAllMovies()
//   //     .where((movie) => movie.isPopular ?? true)
//   //     .toList());
//   this.getPopularMovies();
//   return mMovieDao
//       .getAllMoviesEventStream()
//       .startWith(mMovieDao.getPopularMoviesStream())
//       .combineLatest(mMovieDao.getPopularMoviesStream(),
//           (event, movieList) => movieList as List<MovieVO>)
//       .first
//   .then((popularMoives) {
//     this.popularMovies = popularMovies;
//     notifyListeners();
//     return Future.value(popularMoives);
//   });
// }

// @override
// Future<List<MovieVO>> getTopRatedMoviesFromDatabase() {
//   // return Future.value(mMovieDao
//   //     .getAllMovies()
//   //     .where((movie) => movie.isTopRated ?? true)
//   //     .toList());
//   this.getTopRatedMovies();
//   return mMovieDao
//       .getAllMoviesEventStream()
//       .startWith(mMovieDao.getTopRatedMoviesStream())
//       .combineLatest(mMovieDao.getTopRatedMoviesStream(),
//           (event, movieList) => movieList as List<MovieVO>)
//       .first
//       .then((topRatedMovies) {
//     this.topRatedMovies = topRatedMovies;
//     notifyListeners();
//     return Future.value(topRatedMovies);
//   });
// }

  /// Reactive stream for Now playing, popular, top rated
  Stream<List<MovieVO>> getNowPlayingMoviesFromDatabase() {
    this.getNowPlayingMovies(1);
    return mMovieDao
        .getAllMoviesEventStream()
        .startWith(mMovieDao.getNowPlayingMoviesStream())
        .map((event) => mMovieDao.getNowPlayingMovies());
    //     .then((nowPlayingMovies) {
    //   mNowPlayingMovies = nowPlayingMovies;
    //   notifyListeners();
    // });
  }

  @override
  Stream<List<MovieVO>> getPopularMoviesFromDatabase() {
    this.getPopularMovies();
    return mMovieDao
        .getAllMoviesEventStream()
        .startWith(mMovieDao.getPopularMoviesStream())
        .map((event) => mMovieDao.getPopularMovies());
    //     .then((popularMovies) {
    //   this.popularMovies = popularMovies;
    //   notifyListeners();
    // });
  }

  @override
  Stream<List<MovieVO>> getTopRatedMoviesFromDatabase() {
    this.getTopRatedMovies();
    return mMovieDao
        .getAllMoviesEventStream()
        .startWith(mMovieDao.getTopRatedMoviesStream())
        .map((event) => mMovieDao.getTopRatedMovies());
    //     .then((topRatedMovies) {
    //   this.topRatedMovies = topRatedMovies;
    //   notifyListeners();
    // });
  }
}
