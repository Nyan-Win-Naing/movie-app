import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/data/vos/actor_vo.dart';
import 'package:movie_app/data/vos/genre_vo.dart';
import 'package:movie_app/data/vos/movie_vo.dart';
import 'package:movie_app/network/dataagents/movie_data_agent.dart';
import 'package:movie_app/network/dataagents/retrofit_data_agent_impl.dart';
import 'package:movie_app/persistence/daos/actor_dao.dart';
import 'package:movie_app/persistence/daos/genre_dao.dart';
import 'package:movie_app/persistence/daos/movie_dao.dart';
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
  MovieDao mMovieDao = MovieDao();
  GenreDao mGenreDao = GenreDao();
  ActorDao mActorDao = ActorDao();

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
  void getNowPlayingMovies() {
    _dataAgent.getNowPlayingMovies(1).then((movies) async {
      List<MovieVO>? nowPlayingMovies = movies?.map((movie) {
        movie.isNowPlaying = true;
        movie.isPopular = false;
        movie.isTopRated = false;
        return movie;
      }).toList();
      mMovieDao.saveMovies(nowPlayingMovies);
      mNowPlayingMovies = nowPlayingMovies;
      notifyListeners();
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
      this.popularMovies = popularMovies;
      notifyListeners();
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
      this.topRatedMovies = topRatedMovies;
      notifyListeners();
    });
  }

  @override
  void getActors(int page) {
    _dataAgent.getActors(page).then((actors) async {
      mActorDao.saveAllActors(actors);
      this.actors = actors;
      notifyListeners();
      return Future.value(actors);
    });
  }

  @override
  void getGenres() {
    _dataAgent.getGenres().then((genres) async {
      mGenreDao.saveAllGenres(genres);
      this.genres = genres;
      getMoviesByGenre(genres?.first.id ?? 0);
      notifyListeners();
      return Future.value(genres);
    });
  }

  @override
  void getMoviesByGenre(int genreId) {
    _dataAgent.getMoviesByGenre(genreId).then((moviesList) {
      moviesByGenre = moviesList;
      notifyListeners();
    });
  }

  @override
  void getCreditsByMovie(int movieId) {
    _dataAgent.getCreditsByMovie(movieId).then((castAndCrew) {
      cast = castAndCrew.first;
      crew = castAndCrew[1];
      notifyListeners();
    });
  }

  @override
  void getMovieDetails(int movieId) {
    _dataAgent.getMovieDetails(movieId).then((movie) async {
      mMovieDao.saveSingleMovie(movie);
      movieDetails = movie;
      notifyListeners();
      return Future.value(movie);
    });
  }

  // Database
  @override
  void getAllActorsFromDatabase() {
    actors = mActorDao.getAllActors();
    notifyListeners();
  }

  @override
  void getGenresFromDatabase() {
    // return Future<List<GenreVO>>.value(mGenreDao.getAllGenres());
    genres = mGenreDao.getAllGenres();
    notifyListeners();
  }

  @override
  void getMovieDetailsFromDatabase(int movieId) {
    // Future.value(mMovieDao.getMovieById(movieId));
    movieDetails = mMovieDao.getMovieById(movieId);
    notifyListeners();
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

  /// Reactive stream for Now playing, popular, top rated
  void getNowPlayingMoviesFromDatabase() {
    this.getNowPlayingMovies();
    mMovieDao
        .getAllMoviesEventStream()
        .startWith(mMovieDao.getNowPlayingMoviesStream())
        .map((event) => mMovieDao.getNowPlayingMovies())
        .first
        .then((nowPlayingMovies) {
      mNowPlayingMovies = nowPlayingMovies;
      notifyListeners();
    });
  }

  @override
  void getPopularMoviesFromDatabase() {
    this.getPopularMovies();
    mMovieDao
        .getAllMoviesEventStream()
        .startWith(mMovieDao.getPopularMoviesStream())
        .map((event) => mMovieDao.getPopularMovies())
        .first
        .then((popularMovies) {
      this.popularMovies = popularMovies;
      notifyListeners();
    });
  }

  @override
  void getTopRatedMoviesFromDatabase() {
    this.getTopRatedMovies();
    mMovieDao
        .getAllMoviesEventStream()
        .startWith(mMovieDao.getTopRatedMoviesStream())
        .map((event) => mMovieDao.getTopRatedMovies())
        .first
        .then((topRatedMovies) {
      this.topRatedMovies = topRatedMovies;
      notifyListeners();
    });
  }

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
}
