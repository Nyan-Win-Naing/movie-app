import 'package:hive/hive.dart';
import 'package:movie_app/data/vos/movie_vo.dart';
import 'package:movie_app/persistence/hive_constants.dart';

class MovieDao {
  static final MovieDao _singleton = MovieDao._internal();

  factory MovieDao() {
    return _singleton;
  }

  MovieDao._internal();

  void saveMovies(List<MovieVO>? movies) async {
    Map<int, MovieVO> movieMap = Map.fromIterable(movies ?? [],
        key: (movie) => movie.id, value: (movie) => movie);
    await getMovieBox().putAll(movieMap);
  }

  void saveSingleMovie(MovieVO? movie) async {
    await getMovieBox().put(movie!.id, movie);
  }

  List<MovieVO> getAllMovies() {
    // List<MovieVO> movieListFromDatabase = getMovieBox().values.toList();
    // movieListFromDatabase.forEach((element) => print(element.title));
    return getMovieBox().values.toList();
  }

  MovieVO? getMovieById(int movieId) {
    return getMovieBox().get(movieId);
  }

  /// Reactive Programming
  Stream<void> getAllMoviesEventStream() {
    print("Watch function in movie dao works........");
    return getMovieBox().watch();
  }

  Stream<List<MovieVO>> getNowPlayingMoviesStream() {
    print("Get Now Playing Movies Stream Function works........");
    print("Get now playing movies stream: ${getAllMovies()
        .where((element) => element.isNowPlaying ?? false)
        .toList()}");
    return Stream.value(getAllMovies()
        .where((element) => element.isNowPlaying ?? false)
        .toList());
  }

  Stream<List<MovieVO>> getPopularMoviesStream() {
    return Stream.value(getAllMovies()
        .where((element) => element.isPopular ?? false)
        .toList());
  }

  Stream<List<MovieVO>> getTopRatedMoviesStream() {
    return Stream.value(getAllMovies()
        .where((element) => element.isTopRated ?? false)
        .toList());
  }


  Box<MovieVO> getMovieBox() {
    return Hive.box<MovieVO>(BOX_NAME_MOVIE_VO);
  }

  /// New Functions
  List<MovieVO> getNowPlayingMovies() {
    if(getAllMovies() != null && (getAllMovies().isNotEmpty)) {
      print("Movies are present....");
      return getAllMovies()
          .where((element) => element.isNowPlaying ?? false)
          .toList();
    } else {
      print("No Movies......");
      return [];
    }
  }

  List<MovieVO> getPopularMovies() {
    if(getAllMovies() != null && (getAllMovies().isNotEmpty)) {
      return getAllMovies()
          .where((element) => element.isPopular ?? false)
          .toList();
    } else {
      return [];
    }
  }

  List<MovieVO> getTopRatedMovies() {
    if(getAllMovies() != null && (getAllMovies().isNotEmpty)) {
      return getAllMovies()
          .where((element) => element.isTopRated ?? false)
          .toList();
    } else {
      return [];
    }
  }

}
