import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Division extends StatefulWidget {
  @override
  State<Division> createState() => _DivisionState();
}

class _DivisionState extends State<Division> {
  final videoUrl = "https://youtu.be/UipahxduaHI?si=m6VxGdvN_SHEkzo4";

  late YoutubePlayerController playerController;

  @override
  void initState() {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    playerController = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(autoPlay: false),
    );
    super.initState();
  }

  void seekBackward() {
    final currentPosition = playerController.value.position;
    if (currentPosition.inSeconds - 10 > 0) {
      playerController.seekTo(currentPosition - Duration(seconds: 10));
    }
  }

  void seekForward() {
    final currentPosition = playerController.value.position;
    final duration = playerController.value.metaData.duration;
    if (currentPosition.inSeconds + 10 < duration.inSeconds) {
      playerController.seekTo(currentPosition + Duration(seconds: 10));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'Division',
            style: GoogleFonts.openSans(
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          ),
        ),
        backgroundColor: Colors.lightBlue[100],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                children: [
                  Center(
                    child: Container(
                      height: isPortrait ? screenHeight * 0.3: screenHeight * 0.7,
                      width: isPortrait ? screenWidth * 1 : screenWidth*0.7,
                      child: YoutubePlayer(controller: playerController),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    right: 100,
                    left: 100,
                    bottom: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: seekBackward,
                          icon: Icon(Icons.replay_10, size: 32, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: seekForward,
                          icon: Icon(Icons.forward_10, size: 32, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48,),

              // Example section with responsive card
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Example',
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: isPortrait ? screenHeight * 0.2 : screenHeight * 0.5,
                    width: isPortrait ? screenWidth * 0.8 : screenWidth*0.4,
                    color: Colors.lightBlue,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Image.asset(

                        'assets/Learning/division_example.gif',
                        width: screenWidth, // Adjust based on screen width
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}