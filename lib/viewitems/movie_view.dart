import 'package:flutter/material.dart';
import 'package:movie_app/data/vos/movie_vo.dart';
import 'package:movie_app/network/api_constants.dart';
import 'package:movie_app/resources/dimens.dart';
import 'package:movie_app/widgets/rating_view.dart';

class MovieView extends StatelessWidget {

  final MovieVO? movie;
  Function(int?) onTapMovie;

  MovieView(this.onTapMovie, {required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => this.onTapMovie(movie?.id ?? 0),
      child: Container(
        margin: EdgeInsets.only(right: MARGIN_MEDIUM),
        width: MOVIE_LIST_ITEM_WIDTH,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              "$IMAGE_BASE_URL${movie?.posterPath ?? ""}",
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: MARGIN_MEDIUM,
            ),
            Text(
              movie?.title ?? "",
              style: TextStyle(
                color: Colors.white,
                fontSize: TEXT_REGULAR_2X,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: MARGIN_MEDIUM,
            ),
            Row(
              children: [
                Text(
                  "8.9",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: TEXT_REGULAR,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: MARGIN_MEDIUM,
                ),
               RatingView(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
