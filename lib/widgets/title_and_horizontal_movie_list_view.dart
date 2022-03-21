import 'package:flutter/material.dart';
import 'package:movie_app/data/vos/movie_vo.dart';
import 'package:movie_app/resources/dimens.dart';
import 'package:movie_app/resources/strings.dart';
import 'package:movie_app/viewitems/movie_view.dart';
import 'package:movie_app/widgets/title_text.dart';

class TitleAndHorizontalMovieListView extends StatelessWidget {
  final Function(int?) onTapMovie;
  final List<MovieVO>? nowPlayingMovie;
  final String title;

  TitleAndHorizontalMovieListView({
    required this.onTapMovie,
    required this.nowPlayingMovie,
    required this.title,
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