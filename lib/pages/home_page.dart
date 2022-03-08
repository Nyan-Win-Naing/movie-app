import 'package:flutter/material.dart';
import 'package:movie_app/blocs/home_bloc.dart';
import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/data/models/movie_model_impl.dart';
import 'package:movie_app/data/vos/actor_vo.dart';
import 'package:movie_app/data/vos/genre_vo.dart';
import 'package:movie_app/data/vos/movie_vo.dart';
import 'package:movie_app/pages/movie_details_page.dart';
import 'package:movie_app/resources/colors.dart';
import 'package:movie_app/resources/dimens.dart';
import 'package:movie_app/resources/strings.dart';
import 'package:movie_app/viewitems/actor_view.dart';
import 'package:movie_app/viewitems/banner_view.dart';
import 'package:movie_app/viewitems/movie_view.dart';
import 'package:movie_app/viewitems/showcase_view.dart';
import 'package:movie_app/widgets/actors_and_creators_section_view.dart';
import 'package:movie_app/widgets/see_more_text.dart';
import 'package:movie_app/widgets/title_text.dart';
import 'package:movie_app/widgets/title_text_with_see_more_view.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc _bloc = HomeBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PRIMARY_COLOR,
        centerTitle: true,
        title: const Text(
          MAIN_SCREEN_APP_BAR_TITLE,
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: const Icon(
          Icons.menu,
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(
              top: 0,
              left: 0,
              bottom: 0,
              right: MARGIN_MEDIUM_2,
            ),
            child: Icon(
              Icons.search,
            ),
          ),
        ],
      ),
      body: Container(
        color: HOME_SCREEN_BACKGROUND_COLOR,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                stream: _bloc.mPopularMoviesListStreamController.stream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<MovieVO>> snapshot) {
                  return BannerSectionView(
                    movieList: snapshot.data?.take(8).toList() ?? [],
                  );
                },
              ),
              const SizedBox(height: MARGIN_LARGE),
              StreamBuilder(
                stream: _bloc.mNowPlayingStreamController.stream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<MovieVO>> snapshot) {
                  return BestPopularMoviesAndSerialsSectionView(
                    onTapMovie: (movieId) =>
                        _navigateToMovieDetailsScreen(context, movieId),
                    nowPlayingMovie: snapshot.data,
                  );
                },
              ),
              const SizedBox(height: MARGIN_LARGE),
              CheckMovieShowTimesSectionView(),
              const SizedBox(height: MARGIN_LARGE),
              StreamBuilder(
                stream: _bloc.mGenreListStreamController.stream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<GenreVO>> genreSnapShot) {
                  return StreamBuilder(
                    stream: _bloc.mMoviesByGenreListStreamController.stream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<MovieVO>> moviesByGenreSnapShot) {
                      return GenreSectionView(
                        onTapMovie: (movieId) =>
                            _navigateToMovieDetailsScreen(context, movieId),
                        genreList: genreSnapShot.data,
                        moviesByGenre: moviesByGenreSnapShot.data,
                        onChooseGenre: (genreId) {
                          if (genreId != null) {
                            _bloc.onTapGenre(genreId);
                          }
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: MARGIN_LARGE),
              StreamBuilder(
                stream: _bloc.mShowCaseMovieListStreamController.stream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<MovieVO>> snapshot) {
                  return ShowcasesSection(
                    topRatedMovies: snapshot.data,
                  );
                },
              ),
              const SizedBox(height: MARGIN_LARGE),
              StreamBuilder(
                stream: _bloc.mActorsStreamController.stream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<ActorVO>> snapshot) {
                  return ActorsAndCreatorsSectionView(
                    BEST_ACTORS_TITLE,
                    BEST_ACTORS_SEE_MORE,
                    actorsList: snapshot.data,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void _navigateToMovieDetailsScreen(
  //   BuildContext context,
  //   int? movieId,
  //   MovieModelImpl model,
  // ) {
  //   model.getMovieDetails(movieId ?? 0);
  //   model.getMovieDetailsFromDatabase(movieId ?? 0);
  //   model.getCreditsByMovie(movieId ?? 0);
  //   if (movieId != null) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => MovieDetailsPage(
  //             // movieId: movieId,
  //             ),
  //       ),
  //     );
  //   }
  // }

  void _navigateToMovieDetailsScreen(
    BuildContext context,
    int? movieId,
  ) {
    if (movieId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MovieDetailsPage(
            movieId: movieId,
          ),
        ),
      );
    }
  }
}

class GenreSectionView extends StatelessWidget {
  final List<GenreVO>? genreList;
  final List<MovieVO>? moviesByGenre;
  final Function(int?) onTapMovie;
  final Function(int?) onChooseGenre;

  GenreSectionView({
    required this.onTapMovie,
    required this.genreList,
    required this.moviesByGenre,
    required this.onChooseGenre,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
          child: DefaultTabController(
            length: genreList?.length ?? 0,
            child: TabBar(
              isScrollable: true,
              indicatorColor: PLAY_BUTTON_COLOR,
              unselectedLabelColor: HOME_SCREEN_LIST_TITLE_COLOR,
              tabs: genreList
                      ?.map(
                        (genre) => Tab(
                          child: Text(genre.name ?? ""),
                        ),
                      )
                      .toList() ??
                  [],
              onTap: (index) {
                onChooseGenre(genreList?[index].id);
              },
            ),
          ),
        ),
        Container(
          color: PRIMARY_COLOR,
          padding: const EdgeInsets.only(
            top: MARGIN_MEDIUM_2,
            bottom: MARGIN_LARGE,
          ),
          child: HorizontalMovieListView(
            onTapMovie: (movieId) => this.onTapMovie(movieId),
            movieList: moviesByGenre,
          ),
        ),
      ],
    );
  }
}

class CheckMovieShowTimesSectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: PRIMARY_COLOR,
      margin: const EdgeInsets.symmetric(
        horizontal: MARGIN_MEDIUM_2,
      ),
      padding: const EdgeInsets.all(MARGIN_LARGE),
      height: SHOWTIME_SECTION_HEIGHT,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                MAIN_SCREEN_CHECK_MOVIE_SHOWTIMES,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: TEXT_HEADING_1X,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              SeeMoreText(
                MAIN_SCREEN_SEE_MORE,
                textColor: PLAY_BUTTON_COLOR,
              ),
            ],
          ),
          const Spacer(),
          const Icon(
            Icons.location_on_rounded,
            color: Colors.white,
            size: BANNER_PLAY_BUTTON_SIZE,
          ),
        ],
      ),
    );
  }
}

class ShowcasesSection extends StatelessWidget {
  final List<MovieVO>? topRatedMovies;

  ShowcasesSection({required this.topRatedMovies});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
          child: TitleTextWithSeeMoreView(
            SHOW_CASES_TITLE,
            SHOW_CASES_SEE_MORE,
          ),
        ),
        const SizedBox(height: MARGIN_MEDIUM_2),
        Container(
          height: SHOW_CASES_HEIGHT,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: MARGIN_MEDIUM_2),
            children: topRatedMovies
                    ?.map((topRatedMovie) => ShowCaseView(
                          movie: topRatedMovie,
                        ))
                    .toList() ??
                [],
          ),
        ),
      ],
    );
  }
}

class BestPopularMoviesAndSerialsSectionView extends StatelessWidget {
  final Function(int?) onTapMovie;
  final List<MovieVO>? nowPlayingMovie;

  BestPopularMoviesAndSerialsSectionView({
    required this.onTapMovie,
    required this.nowPlayingMovie,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: MARGIN_MEDIUM_2),
          child: TitleText(MAIN_SCREEN_BEST_POPULAR_MOVIES_AND_SERIALS),
        ),
        const SizedBox(height: MARGIN_MEDIUM_2),
        HorizontalMovieListView(
          onTapMovie: (movieId) => this.onTapMovie(movieId),
          movieList: nowPlayingMovie,
        ),
      ],
    );
  }
}

class HorizontalMovieListView extends StatelessWidget {
  final Function(int?) onTapMovie;
  final List<MovieVO>? movieList;

  HorizontalMovieListView({
    required this.onTapMovie,
    required this.movieList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MOVIE_LIST_HEIGHT,
      child: (movieList != null)
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: MARGIN_MEDIUM_2),
              itemCount: movieList?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => onTapMovie(movieList?[index].id),
                  child: MovieView(
                    movie: movieList?[index],
                  ),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class BannerSectionView extends StatefulWidget {
  final List<MovieVO>? movieList;

  BannerSectionView({required this.movieList});

  @override
  State<BannerSectionView> createState() => _BannerSectionViewState();
}

class _BannerSectionViewState extends State<BannerSectionView> {
  double _position = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 3.5,
          child: PageView(
            onPageChanged: (page) {
              setState(() {
                _position = page.toDouble();
              });
            },
            children: widget.movieList
                    ?.map(
                      (movie) => BannerView(
                        movie: movie,
                      ),
                    )
                    .toList() ??
                [],
          ),
        ),
        const SizedBox(height: MARGIN_MEDIUM_2),
        DotsIndicator(
          // dotsCount: widget.movieList?.length ?? 1,
          dotsCount: (widget.movieList?.length == 0)
              ? 1
              : widget.movieList?.length ?? 1,
          position: _position,
          decorator: const DotsDecorator(
            color: HOME_SCREEN_BANNER_DOTS_INACTIVE_COLOR,
            activeColor: PLAY_BUTTON_COLOR,
          ),
        ),
      ],
    );
  }
}
