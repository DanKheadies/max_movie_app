import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:video_player/video_player.dart';

import 'package:max_movie_app/models/models.dart';

class MovieScreen extends StatelessWidget {
  final Movie movie;

  const MovieScreen({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ..._buildBackground(context, movie),
          _buildMovieInformation(context),
          _buildActions(context),
        ],
      ),
    );
  }

  Positioned _buildActions(BuildContext context) {
    return Positioned(
      bottom: 50,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15),
                backgroundColor: const Color(0xFFFF7272),
                fixedSize: Size(
                  MediaQuery.of(context).size.width * 0.425,
                  50,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {},
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                      ),
                  children: [
                    TextSpan(
                      text: 'Add to ',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const TextSpan(
                      text: 'Watchlist',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15),
                backgroundColor: Colors.white,
                fixedSize: Size(
                  MediaQuery.of(context).size.width * 0.425,
                  50,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _MoviePlayer(
                      movie: movie,
                    ),
                  ),
                );
              },
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: [
                    TextSpan(
                      text: 'Start ',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const TextSpan(
                      text: 'Watching!',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Positioned _buildMovieInformation(BuildContext context) {
    return Positioned(
      bottom: 150,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              movie.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${movie.year} | ${movie.category} | ${movie.duration.inHours}h ${movie.duration.inMinutes.remainder(60)}m',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              ignoreGestures: true,
              unratedColor: Colors.white,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4),
              onRatingUpdate: (rating) {},
              itemCount: 5,
              itemSize: 20,
              itemBuilder: (context, index) {
                return const Icon(
                  Icons.star,
                  color: Colors.amber,
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              'My peril is thus: I am, and always have been, a man of great tastes. In a world replete with temptation, I found my spirit wayward and easy to distract. The idea of prison, that naked, metal world, crushed me. The first year, I was tormented. But then I remembered the voice of a fallen angel. ‘The mind is its own place, and in itself can make a heaven of hell, or a hell of heaven.’ I sought to make the deep not just my heaven, but my womb of rebirth. “I dissected the underlying mistakes which led to my incarceration and set upon an internal odyssey to remake myself. But—and you would know this, Reaper—long is the road up out of hell! I made arrangements for supplies. I toiled twenty hours a day. I reread the books of youth with the gravity of age. I perfected my body. My mind. Planks were replaced; new banks of cannon wrought in the fires of solitude. All for the next storm. “Now I see it is upon me and I sail before you the paragon of Apollonius au Valii-Rath. And I ask one question: for what purpose have you pulled me from the deep?',
              maxLines: 8,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    height: 1.75,
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBackground(
    BuildContext context,
    Movie movie,
  ) {
    return [
      Container(
        height: double.infinity,
        color: const Color(0xFF000B49),
      ),
      Image.network(
        movie.imagePath,
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.5,
        fit: BoxFit.cover,
      ),
      const Positioned.fill(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Color(0xFF000B49),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [
                0.3,
                0.5,
              ],
            ),
          ),
        ),
      ),
    ];
  }
}

class _MoviePlayer extends StatefulWidget {
  final Movie movie;

  const _MoviePlayer({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  State<_MoviePlayer> createState() => _MoviePlayerState();
}

class _MoviePlayerState extends State<_MoviePlayer> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();

    videoPlayerController = VideoPlayerController.asset(widget.movie.videoPath)
      ..initialize().then((_) {
        setState(() {});
      });

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 9 / 16,
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Chewie(
          controller: chewieController,
        ),
      ),
    );
  }
}
