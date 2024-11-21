import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nishabdvaani/Widgets/HomeScreen/swap_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MatchEngine _matchEngine;
  late List<SwipeItem> _swipItems = [];

  @override
  void initState(){
    contents.forEach((content){
      var swipeItem = SwipeItem(content: content);
      _swipItems.add(swipeItem);
    });
    _matchEngine = MatchEngine(swipeItems: _swipItems );
    super.initState();
  }
  void _onStackFinished(){
    contents.forEach((content){
      var swipeItem = SwipeItem(content: content);
      _swipItems.add(swipeItem);
    });
    setState(() {
      _matchEngine = MatchEngine(swipeItems: _swipItems);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.settings, size: 35),
          onPressed: () {},
        ),
        title: Align(
          alignment: Alignment.center,
          child: Text(
            AppLocalizations.of(context)!.nishabd_vaani,
            style: GoogleFonts.openSans(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.lightBlue[100],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, size: 35),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 400,
                width: 200,
                padding: const  EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                child: Center(
                  child: SwipeCards(
                      matchEngine: _matchEngine,
                      onStackFinished: _onStackFinished,
                      itemBuilder: (BuildContext context, int index){
                        final item = contents[index % contents.length];
                        return Image.asset(
                          item.image,
                        );
                      },
                  ),
                ),
              ),
                  // Image.asset(
                  //   'assets/Home_Screen/card.png',
                  //   height: 300,
                  // ),
              Card(
                color: Colors.white,
                shadowColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.hello_learners,
                        style: GoogleFonts.openSans(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Image.asset(
                        'assets/Home_Screen/study.png',
                        height: 100,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.its_never_too_late,
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:nishabdvaani/Provider/translation_service.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final TranslationService _translationService = TranslationService();
//   String title = 'NishabdVaani';
//   String hiLearner = 'Hi Learner!';
//   String startLearning = 'It\'s never too late to start Learning';
//   bool isGujarati = false;

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<void> _translateContent(bool toGujarati) async {
//     if (toGujarati) {
//       String translatedTitle = await _translationService.translate(title, 'gu');
//       String translatedHiLearner = await _translationService.translate(hiLearner, 'gu');
//       String translatedStartLearning = await _translationService.translate(startLearning, 'gu');

//       setState(() {
//         title = translatedTitle;
//         hiLearner = translatedHiLearner;
//         startLearning = translatedStartLearning;
//       });
//     } else {
//       setState(() {
//         title = 'NishabdVaani';
//         hiLearner = 'Hi Learner!';
//         startLearning = 'It\'s never too late to start Learning';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.settings, size: 35),
//           onPressed: () {},
//         ),
//         title: Align(
//           alignment: Alignment.center,
//           child: Text(
//             title,
//             style: GoogleFonts.openSans(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//         ),
//         backgroundColor: Colors.lightBlue[100],
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.notifications, size: 35),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             SwitchListTile(
//               title: Text(
//                 isGujarati ? 'Gujarati' : 'English',
//                 style: GoogleFonts.openSans(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               value: isGujarati,
//               onChanged: (value) {
//                 setState(() {
//                   isGujarati = value;
//                 });
//                 _translateContent(value);
//               },
//             ),
//             Image.asset(
//               'assets/Home_Screen/card.png',
//               height: 300,
//             ),
//             Card(
//               color: Colors.white,
//               shadowColor: Colors.grey,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16.0),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   children: [
//                     Text(
//                       hiLearner,
//                       style: GoogleFonts.openSans(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Image.asset(
//                       'assets/Home_Screen/study.png',
//                       height: 100,
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       startLearning,
//                       style: GoogleFonts.openSans(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
