import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/data/models/movie_model_impl.dart';
import 'package:movie_app/data/vos/movie_vo.dart';

import '../mock_data/mock_data.dart';
import '../network/movie_data_agent_impl_mock.dart';
import '../persistence/actor_dao_impl_mock.dart';
import '../persistence/genre_dao_impl_mock.dart';
import '../persistence/movie_dao_impl_mock.dart';

void main() {
  group("movie_model_impl", () {
    var movieModel = MovieModelImpl();

    setUp(() {
      movieModel.setDaosAndDataAgents(
        MovieDaoImplMock(),
        ActorDaoImplMock(),
        GenreDaoImplMock(),
        MovieDataAgentImplMock(),
      );
    });

    test(
        "Saving Now Playing Movies and Getting Now Playing Movies From Database",
        () {
          print("Void return call back works.......");
      expect(
          movieModel.getNowPlayingMoviesFromDatabase(),
          emits(
            [
              MovieVO(
                false,
                "/iQFcwSGbZXMkeyKrxbPnwnRo5fl.jpg",
                [28, 12, 878],
                634649,
                "en",
                "Spider-Man: No Way Home",
                "Peter Parker is unmasked and no longer able to separate his normal life from the high-stakes of being a super-hero. When he asks for help from Doctor Strange the stakes become even more dangerous, forcing him to discover what it truly means to be Spider-Man.",
                8426.2,
                "/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg",
                "2021-12-15",
                "Spider-Man: No Way Home",
                false,
                8.2,
                10923,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                isNowPlaying: true,
                isTopRated: false,
                isPopular: false,
              ),
            ],
          ));
    });

    test("Saving Popular Movies and Getting Popular Movies From Database", () {
      expect(
        movieModel.getPopularMoviesFromDatabase(),
        emits(
          [
            MovieVO(
              false,
              "/fOy2Jurz9k6RnJnMUMRDAgBwru2.jpg",
              [16, 10751, 35, 14],
              508947,
              "en",
              "Turning Red",
              "Thirteen-year-old Mei is experiencing the awkwardness of being a teenager with a twist – when she gets too excited, she transforms into a giant red panda.",
              8326.002,
              "/qsdjk9oAKSQMWs0Vt5Pyfh6O4GZ.jpg",
              "2022-03-01",
              "Turning Red",
              false,
              7.5,
              1374,
              null,
              null,
              null,
              null,
              null,
              null,
              null,
              null,
              null,
              null,
              null,
              null,
              isPopular: true,
              isTopRated: false,
              isNowPlaying: false,
            ),
          ],
        ),
      );
    });

    test("Saving Top Rated Movies and Getting Top Rated Movies From Database",
        () {
      expect(
          movieModel.getTopRatedMoviesFromDatabase(),
          emits(
            [
              MovieVO(
                false,
                "/t7I942V5U1Ggn6OevN75u3sNYH9.jpg",
                [28, 53],
                760868,
                "sv",
                "Svart krabba",
                "To end an apocalyptic war and save her daughter, a reluctant soldier embarks on a desperate mission to cross a frozen sea carrying a top-secret cargo.",
                3649.07,
                "/mcIYHZYwUbvhvUt8Lb5nENJ7AlX.jpg",
                "2022-03-18",
                "Black Crab",
                false,
                6.1,
                248,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                isTopRated: true,
                isPopular: false,
                isNowPlaying: false,
              ),
            ],
          ));
    });

    test(
      "Get Genres Test",
      () {
        expect(
          movieModel.getGenres(),
          completion(equals(getMockGenres())),
        );
      },
    );

    test(
      "Get Actors Test",
      () {
        expect(
          movieModel.getActors(1),
          completion(equals(getMockActors())),
        );
      },
    );

    test(
      "Get Credits Test",
      () {
        expect(
          movieModel.getCreditsByMovie(1),
          completion(equals(getMockCredits())),
        );
      },
    );

    test("Get Movie Details Test", () {
      expect(
          movieModel.getMovieDetails(1),
          completion(
            equals(getMockMoviesForTest().first),
          ));
    });

    test("Get Actors From Database Test", () async {
      await movieModel.getActors(1);
      expect(
          movieModel.getAllActorsFromDatabase(),
          completion(
            equals(getMockActors()),
          ));
    });

    test("Get Movie Details From Database Test", () async {
      await movieModel.getMovieDetails(1);
      expect(
          movieModel.getMovieDetails(1),
          completion(
            equals(getMockMoviesForTest().first),
          ));
    });

    test("Get Genres From Database Test", () async {
      await movieModel.getGenres();
      expect(
          movieModel.getGenresFromDatabase(),
          completion(
            equals(getMockGenres()),
          ));
    });
  });
}
