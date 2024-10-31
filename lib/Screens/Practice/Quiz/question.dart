import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nishabdvaani/Provider/quiz_provider.dart';
import 'package:nishabdvaani/Screens/Practice/Quiz/score_screen.dart';


class Question extends ConsumerStatefulWidget{
  const Question({super.key});

  @override
  _Question createState() => _Question();

}

class _Question extends ConsumerState<Question>{
  String? _selectedOption;
  bool? submitted = false;
  bool answer_value = false;
  bool? _isPrimary = true;

  void toggleButton(){
    setState(() {
      _isPrimary = !_isPrimary!;
    });
  }

  void _checkAnswer(String ans){
    if(_selectedOption==ans){
      answer_value= true;
    }
    else{
      answer_value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final quiz = ref.watch(QuizProvider);
    final count = ref.watch(counterProvider);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height:400,
                  width: 400,
                  child: Stack(
                    children: [
                      Container(
                        height: 250,
                        width: 400,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue,
                              Colors.lightBlueAccent,
                            ]
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      Positioned(
                        top: 160,
                        left: 28,
                        child: Container(
                        height: 220,
                        width:350,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(1,1),
                              blurRadius: 3,
                              spreadRadius: 1,
                              color: Colors.lightBlueAccent.withOpacity(0.3),
                            )
                          ]
                        ),
                          child: Padding(
                              padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${count-1}',
                                      style:
                                      GoogleFonts.openSans(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 28,
                                      ),
                                    ),
                                    Text(
                                      '${count+1}',
                                      style:
                                      GoogleFonts.openSans(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28,
                                      ),
                                    ),
                                  ],
                                ),
                                Center(
                                  child: Text(
                                    'Question $count/7',
                                    style:
                                    GoogleFonts.openSans(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20,),
                                Center(
                                  child: Text(
                                    quiz.question,
                                    style:
                                    GoogleFonts.openSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ),
                      ),
                      Positioned(
                        top: 40,
                        left: 20,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 40,
                              width: 350,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Stack(
                                children: [
                                  LayoutBuilder(
                                      builder: (context, constraints) => Container(
                                        width: constraints.maxWidth*0.4,
                                          decoration:  BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Colors.orangeAccent,
                                                Colors.orange,
                                              ]
                                            ),
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                      )
                                  ),
                                  // const Positioned.fill(
                                  //     child: Padding(
                                  //       padding: EdgeInsets.all(8.0),
                                  //       child: Row(
                                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //         children: [
                                  //           Text('20sec',
                                  //           ),
                                  //           Icon(Icons.timer, size: 24, color: Colors.black,)
                                  //         ],
                                  //       ),
                                  //     ) ,
                                  // )
                                ],
                              ),
                            ),
                          ),

                      ),
                    ],
                  ),
                ),
                for (var option in quiz.options)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (_selectedOption == option) {
                            _selectedOption = null; // Deselect the option
                          } else {
                            _selectedOption = option; // Select the option
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedOption == option
                            ? Colors.purple[300]
                            : Colors.white,
                        padding:  const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: _selectedOption == option
                                ? Colors.purple[300]!
                                : Colors.purple,
                          ),
                        ),
                      ),
                      child: submitted! ?  Row(
                        children: [
                          answer_value ? const Icon(Icons.thumb_up_sharp)
                          : const Icon(Icons.thumb_down_sharp),
                          Text(
                            option,
                            style: GoogleFonts.openSans(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ) : null,
                    ),
                  ),
                const SizedBox(height: 32,),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 32),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Icon(Icons.arrow_back_ios, size: 40,color: Colors.blue,),
                //       Icon(Icons.arrow_forward_ios, size: 40,color: Colors.blue,),
                //
                //     ],
                //   ),
                // ),
                Padding(
                    padding: EdgeInsets.all(20),
                    child:
                    ElevatedButton(
                        onPressed: () async {
                          if(_isPrimary!) {
                            setState(() {
                              submitted = true;
                              _checkAnswer(quiz.correctAnswer);
                            });
                            toggleButton();
                          }
                          else{
                            if(count>7){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (ctx) => const ScoreScreen(),
                              ),
                              );
                            }
                            await ref.read(counterProvider.notifier).state++;
                            ref.read(QuizProvider.notifier)
                                .fetchNextQuestion(answer_value);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isPrimary! ?  Colors.blue : Colors.lightBlueAccent.withOpacity(0.4),
                          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 16),
                        ),
                        child: Container(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text( _isPrimary! ? 'Check Answer' : 'Next',
                              style:
                              GoogleFonts.openSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                    ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

}
