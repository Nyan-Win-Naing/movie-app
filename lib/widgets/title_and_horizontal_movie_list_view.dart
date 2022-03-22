import 'package:flutter/material.dart';
import 'package:movie_app/components/smart_list_view.dart';
import 'package:movie_app/data/vos/movie_vo.dart';
import 'package:movie_app/resources/dimens.dart';
import 'package:movie_app/resources/strings.dart';
import 'package:movie_app/viewitems/movie_view.dart';
import 'package:movie_app/widgets/title_text.dart';

class TitleAndHorizontalMovieListView extends StatelessWidget {
  final Function(int?) onTapMovie;
  final List<MovieVO>? nowPlayingMovie;
  final String title;
  final Function onListEndReached;

  TitleAndHorizontalMovieListView({
    required this.onTapMovie,
    required this.nowPlayingMovie,
    required this.title,
    required this.onListEndReached,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: MARGIN_MEDIUM_2),
          child: TitleText(title),
        ),
        const SizedBox(height: MARGIN_MEDIUM_2),
        HorizontalMovieListView(
          onTapMovie: (movieId) => this.onTapMovie(movieId),
          movieList: nowPlayingMovie,
          onListEndReached: () {
            this.onListEndReached();
          },
        ),
      ],
    );
  }
}

class HorizontalMovieListView extends StatelessWidget {
  final Function(int?) onTapMovie;
  final List<MovieVO>? movieList;
  final Function onListEndReached;

  HorizontalMovieListView({
    required this.onTapMovie,
    required this.movieList,
    required this.onListEndReached,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MOVIE_LIST_HEIGHT,
      child: (movieList != null)
          //     ? ListView.builder(
          //   scrollDirection: Axis.horizontal,
          //   padding: const EdgeInsets.only(left: MARGIN_MEDIUM_2),
          //   itemCount: movieList?.length ?? 0,
          //   itemBuilder: (BuildContext context, int index) {
          //     return GestureDetector(
          //       onTap: () => onTapMovie(movieList?[index].id),
          //       child: MovieView(
          //         movie: movieList?[index],
          //       ),
          //     );
          //   },
          // )
          ? SmartHorizontalListView(
              padding: EdgeInsets.only(left: MARGIN_MEDIUM_2),
              itemCount: movieList?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return MovieView(
                  (movieId) {
                    this.onTapMovie(movieId);
                  },
                  movie: movieList?[index],
                );
              },
              onListEndReached: () {
                this.onListEndReached();
              })
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
