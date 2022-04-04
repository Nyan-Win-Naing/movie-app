import 'package:movie_app/data/vos/movie_vo.dart';
import 'package:movie_app/persistence/daos/movie_dao.dart';

import '../mock_data/mock_data.dart';

class MovieDaoImplMock extends MovieDao {
  Map<int, MovieVO> moviesInDatabaseMock = {};

  @override
  List<MovieVO> getAllMovies() {
    return getMockMoviesForTest();
  }

  @override
  Stream<void> getAllMoviesEventStream() {
    return Stream<void>.value(null);
  }

  @override
  MovieVO? getMovieById(int movieId) {
    return moviesInDatabaseMock.values
        .toList()
        .firstWhere((element) => element.id == movieId);
  }

  @override
  List<MovieVO> getNowPlayingMovies() {
    if ((getMockMoviesForTest().isNotEmpty)) {
      return getMockMoviesForTest()
          .where((element) => element.isNowPlaying ?? false)
          .toList();
    } else {
      return [];
    }
  }

  @override
  Stream<List<MovieVO>> getNowPlayingMoviesStream() {
    return Stream.value(getMockMoviesForTest()
        .where((element) => element.isNowPlaying ?? false)
        .toList());
  }

  @override
  List<MovieVO> getPopularMovies() {
    if (getMockMoviesForTest() != null && (getMockMoviesForTest().isNotEmpty)) {
      return getMockMoviesForTest()
          .where((element) => element.isPopular ?? false)
          .toList();
    } else {
      return [];
    }
  }

  @override
  Stream<List<MovieVO>> getPopularMoviesStream() {
    // TODO: implement getPopularMoviesStream
    throw UnimplementedError();
  }

  @override
  List<MovieVO> getTopRatedMovies() {
    // TODO: implement getTopRatedMovies
    throw UnimplementedError();
  }

  @override
  Stream<List<MovieVO>> getTopRatedMoviesStream() {
    // TODO: implement getTopRatedMoviesStream
    throw UnimplementedError();
  }

  @override
  void saveMovies(List<MovieVO> movies) {
    // TODO: implement saveMovies
  }

  @override
  void saveSingleMovie(MovieVO? movie) {
    // TODO: implement saveSingleMovie
  }
}
