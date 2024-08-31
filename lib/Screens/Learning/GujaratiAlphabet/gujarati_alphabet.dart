import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nishabdvaani/Screens/Learning/letter.dart';
import '../../../Provider/gujarati_alphabet_provider.dart';
import 'package:nishabdvaani/Screens/Learning/GujaratiAlphabet/question_gujarati.dart';

class GujaratiAlphabet extends ConsumerWidget {
  const GujaratiAlphabet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alphabetState = ref.watch(GujaratialphabetProvider);

    if (alphabetState.flag == 'quiz') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionGujarati(
              question: alphabetState.question,
              options: alphabetState.options,
              answer: alphabetState.answer,
            ),
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Letter(),
          ),
        );
          },
        ),
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'Gujarati Alphabet',
            style: GoogleFonts.openSans(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.purple[300],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: alphabetState.flag == 'Learn'
              ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.network(
                alphabetState.signImage,
                width: 200,
                height: 100,
              ),
              Text(
                alphabetState.alphabet,
                style: GoogleFonts.openSans(
                  fontSize: 64,
                  color: Colors.black,
                ),
              ),
              Image.network(
                alphabetState.objectImage,
                width: 300,
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 50),
                    onPressed: () {
                      ref.read(GujaratialphabetProvider.notifier).fetchPreviousAlphabet();
                    },
                    color: Colors.black,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 50),
                    onPressed: () {
                      ref.read(GujaratialphabetProvider.notifier).fetchNextAlphabet();
                    },
                    color: Colors.black,
                  ),
                ],
              ),
            ],
          )
              : Container(), // Empty container as navigation happens in the addPostFrameCallback
        ),
      ),
    );
  }
}




//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../../Provider/alphabet_provider.dart';
// import 'question_gujarati.dart'; // Ensure this import path is correct
//
// class EnglishAlphabet extends ConsumerWidget {
//   const EnglishAlphabet({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final alphabetState = ref.watch(alphabetProvider);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Align(
//           alignment: Alignment.center,
//           child: Text(
//             'English Alphabet',
//             style: GoogleFonts.openSans(
//               color: Colors.white,
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         backgroundColor: Colors.purple[300],
//       ),
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Container(
//           width: MediaQuery.of(context).size.width * 0.9,
//           height: MediaQuery.of(context).size.height * 0.8,
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.3),
//                 spreadRadius: 2,
//                 blurRadius: 5,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           child: alphabetState.flag == 'Learn'
//               ? Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Image.network(
//                 alphabetState.signImage,
//                 width: 100,
//                 height: 100,
//               ),
//               Text(
//                 alphabetState.alphabet,
//                 style: GoogleFonts.openSans(
//                   fontSize: 70,
//                   color: Colors.black,
//                 ),
//               ),
//               Image.network(
//                 alphabetState.objectImage,
//                 width: 300,
//                 height: 100,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.arrow_back_ios, size: 40),
//                     onPressed: () {
//                       ref.read(alphabetProvider.notifier).fetchPreviousAlphabet();
//                     },
//                     color: Colors.black,
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.arrow_forward_ios, size: 40),
//                     onPressed: () {
//                       ref.read(alphabetProvider.notifier).fetchNextAlphabet();
//                     },
//                     color: Colors.black,
//                   ),
//                 ],
//               ),
//             ],
//           )
//               : QuestionEnglish(
//             question: alphabetState.question,
//             options: alphabetState.options,
//             answer: alphabetState.answer,
//           ),
//         ),
//       ),
//     );
//   }
// }





//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import 'package:nishabdvaani/Screens/Learning/EnglishAlphabet/question_gujarati.dart';
//
// import '../../../Provider/alphabet_provider.dart';
//
// class EnglishAlphabet extends ConsumerWidget {
//   const EnglishAlphabet({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final alphabetState = ref.watch(alphabetProvider);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Align(
//           alignment: Alignment.center,
//           child: Text(
//             'English Alphabet',
//             style: GoogleFonts.openSans(
//               color: Colors.white,
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         backgroundColor: Colors.purple[300],
//       ),
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Container(
//           width: MediaQuery.of(context).size.width * 0.9,
//           height: MediaQuery.of(context).size.height * 0.8,
//           padding: EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.3),
//                 spreadRadius: 2,
//                 blurRadius: 5,
//                 offset: Offset(0, 3),
//               ),
//             ],
//           ),
//           child: alphabetState.flag == 'Learn'
//               ? Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Image.network(
//                 alphabetState.signImage,
//                 width: 100,
//                 height: 100,
//               ),
//               Text(
//                 alphabetState.alphabet,
//                 style: GoogleFonts.openSans(fontSize: 64, color: Colors.black),
//               ),
//               Image.network(
//                 alphabetState.objectImage,
//                 width: 100,
//                 height: 100,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.arrow_back_ios, size: 50,),
//                     onPressed: () {
//                       ref.read(alphabetProvider.notifier).fetchPreviousAlphabet();
//                     },
//                     color: Colors.black,
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.arrow_forward_ios, size: 50,),
//                     onPressed: () {
//                       ref.read(alphabetProvider.notifier).fetchNextAlphabet();
//                     },
//                     color: Colors.black,
//                   ),
//                 ],
//               ),
//             ],
//           )
//               : QuestionEnglish(
//             question: alphabetState.question,
//             options: alphabetState.options,
//             answer: alphabetState.answer,
//           ),
//         ),
//       ),
//     );
//   }
// }


