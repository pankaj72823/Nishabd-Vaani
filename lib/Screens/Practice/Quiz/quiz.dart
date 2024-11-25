// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class Quiz  extends StatefulWidget{
//   @override
//   State<Quiz> createState() => _QuizState();
// }
//
// class _QuizState extends State<Quiz> {
//    final List<String> quiz = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: const EdgeInsets.all(16.0),
//        child: Column(
//           children: [
//              Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                    for(var option in quiz )
//                     ElevatedButton(
//                        onPressed: () {
//                        setState(() {
//                           if (_selectedOption == option) {
//                              _selectedOption = null; // Deselect the option
//                           } else {
//                              _selectedOption = option; // Select the option
//                           }
//                        });
//                     },
//                        style: ElevatedButton.styleFrom(
//                           backgroundColor: _selectedOption == option
//                               ? Colors.purple[300]
//                               : Colors.white,
//                           padding:  const EdgeInsets.symmetric(vertical: 8),
//                           shape: RoundedRectangleBorder(
//                              borderRadius: BorderRadius.circular(20),
//                              side: BorderSide(
//                                 color: _selectedOption == option
//                                     ? Colors.purple[300]!
//                                     : Colors.purple,
//                              ),
//                           ),
//                        ),
//                         child: Text(option, style: GoogleFonts.openSans(
//                          fontSize: 20,
//                          fontWeight: FontWeight.bold,
//                       ),
//                       ),
//                     ),
//                 ],
//              ),
//              const SizedBox(width: double.infinity,),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 for(var option in quiz )
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         if (_selectedOption == option) {
//                           _selectedOption = null; // Deselect the option
//                         } else {
//                           _selectedOption = option; // Select the option
//                         }
//                       });
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: _selectedOption == option
//                           ? Colors.purple[300]
//                           : Colors.white,
//                       padding:  const EdgeInsets.symmetric(vertical: 8),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                         side: BorderSide(
//                           color: _selectedOption == option
//                               ? Colors.purple[300]!
//                               : Colors.purple,
//                         ),
//                       ),
//                     ),
//                     child: Text(option, style: GoogleFonts.openSans(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     ),
//                   ),
//               ],
//             ),
//           ],
//        ),
//     );
//   }
// }