import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nishabdvaani/Screens/Learning/Maths/Numbers/maths_option.dart';
import 'package:nishabdvaani/Provider/numbers_provider.dart';
// import 'package:nishabdvaani/Screens/Learning/EnglishAlphabet/question_english.dart';

class Numbers extends ConsumerWidget {
  const Numbers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final numberState = ref.watch(NumberProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MathsOption(),
              ),
            );
          },
        ),
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'Numbers',
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.network(
                numberState.signImage,
                width: 200,
                height: 100,
              ),
              Text(
                numberState.number.toString(),
                style: GoogleFonts.openSans(
                  fontSize: 64,
                  color: Colors.black,
                ),
              ),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: List.generate(numberState.number, (index) {
                  return Image.network(
                    numberState.Basket,
                    width: 50,
                    height: 50,
                  );
                }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 50),
                    onPressed: () {
                      ref.read(NumberProvider.notifier).fetchPrevious();
                    },
                    color: Colors.black,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 50),
                    onPressed: () {
                      ref.read(NumberProvider.notifier).fetchNext();
                    },
                    color: Colors.black,
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




// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:nishabdvaani/Screens/Learning/Maths/Numbers/maths_option.dart';
// import 'package:nishabdvaani/Provider/numbers_provider.dart';
// // import 'package:nishabdvaani/Screens/Learning/EnglishAlphabet/question_english.dart';

// class Numbers extends ConsumerWidget {
//   const Numbers({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final numberState = ref.watch(NumberProvider);
//     //
//     // if (numberState.flag == 'quiz') {
//     //   WidgetsBinding.instance.addPostFrameCallback((_) {
//     //     Navigator.pushReplacement(
//     //       context,
//     //       MaterialPageRoute(
//     //         builder: (context) => QuestionEnglish(
//     //           question: alphabetState.question,
//     //           options: alphabetState.options,
//     //           answer: alphabetState.answer,
//     //         ),
//     //       ),
//     //     );
//     //   });
//     // }

//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => MathsOption(),
//               ),
//             );
//           },
//         ),
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
//           child:Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Image.network(
//                 numberState.signImage,
//                 width: 200,
//                 height: 100,
//               ),
//               Text(
//                 numberState.number.toString(),
//                 style: GoogleFonts.openSans(
//                   fontSize: 64,
//                   color: Colors.black,
//                 ),
//               ),
//               Image.network(
//                 numberState.Basket,
//                 width: 50,
//                 height: 50,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.arrow_back_ios, size: 50),
//                     onPressed: () {
//                       ref.read(NumberProvider.notifier).fetchPrevious();
//                     },
//                     color: Colors.black,
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.arrow_forward_ios, size: 50),
//                     onPressed: () {
//                       ref.read(NumberProvider.notifier).fetchNext();
//                     },
//                     color: Colors.black,
//                   ),
//                 ],
//               ),
//             ],
//           )
//               // : Container(), // Empty container as navigation happens in the addPostFrameCallback
//         ),
//       ),
//     );
//   }
// }




