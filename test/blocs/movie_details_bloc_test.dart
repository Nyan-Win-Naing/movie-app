import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/blocs/movie_details_bloc.dart';

import '../data.models/movie_model_impl_mock.dart';
import '../mock_data/mock_data.dart';

void main() {
  group("Movie Details Bloc Test", () {
    MovieDetailsBloc? movieDetailsBloc;

    setUp(() {
      movieDetailsBloc = MovieDetailsBloc(1, MovieModelImplMock());
    });

    test("Fetch Movie Details Test", () {
      expect(movieDetailsBloc?.mMovie, getMockMoviesForTest().first);
    });

    test("Fetch Creators Test", () {
      expect(
        movieDetailsBloc?.mCreatorsList?.contains(getMockCredits().last.first),
        true,
      );
    });

    test(
      "Fetch Actors Test",
      () {
        expect(
          movieDetailsBloc?.mActorsList?.contains(getMockCredits().first.first),
          true,
        );
      },
    );
  });
}
