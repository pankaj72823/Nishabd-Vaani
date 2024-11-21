import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nishabdvaani/Provider/quiz_provider.dart';
import 'package:nishabdvaani/Screens/Practice/Quiz/score_screen.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Question extends ConsumerStatefulWidget{
  const Question({super.key});
  @override
  _Question createState() {
    return _Question();
  }

}

class _Question extends ConsumerState<Question>{
  int _currentQuestion = 0;
  String? _selectedOption;
  String? _selectedColumnA;
  String? _selectedColumnB;
  String? _wrongSelectionB;
  List<Map<String, dynamic>> _frozenPairs = [];
  List<Map<String,dynamic>> _incorrectPairs = [];


  bool? submitted = false;
  bool? answer_value;
  bool? _isPrimary = true;
  bool _showMatchAnswer = false;
  int _unattempted = 0;


  void toggleButton(){
    setState(() {
      _isPrimary! ? _isPrimary = !_isPrimary! : _isPrimary = true;
    });
  }

  void _checkAnswer(String ans){
    setState(() {
      if(_selectedOption==ans){
        answer_value= true;
        ref.read(scoreProvider.notifier).state++;
      }
      else{
        answer_value = false;
      }
    });

  }

  void  checkMatchingAnswer(List correctAnswer){
    setState(() {

      if(_frozenPairs.length == correctAnswer.length) {
        ref
            .read(scoreProvider.notifier)
            .state++;
        answer_value = true;
      }
      else{
        answer_value = false;
      }
    });
  }

  void checkMatch(String letter, String imageUrl, List correctAnswers) {
    bool isCorrect = correctAnswers.any((answer) =>
    answer['alphabet'] == letter && answer['signImage'] == imageUrl);

    setState(() {
      if (isCorrect) {
        // Add to frozen pairs if correct
        _frozenPairs.add({"alphabet": letter, "signImage": imageUrl});
        Vibrate.feedback(FeedbackType.success); // Optional vibration for success
      } else {
        // Add to incorrect pairs if incorrect
        _incorrectPairs.add({"alphabet": letter, "signImage": imageUrl});
        Vibrate.feedback(FeedbackType.error); // Optional vibration for error
      }

        // Reset selections after freezing the pair
        _selectedColumnA = null;
        _selectedColumnB = null;

    });
  }

  bool hasUserCompletedSelection(int pairs ) {
    _showMatchAnswer = true;
    int totalPairs = pairs;
    return _frozenPairs.length + _incorrectPairs.length == totalPairs;
  }



  void updateCurrentQuestion() {
    if (_currentQuestion <=7) {
      setState(() {
        _currentQuestion++;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    double progress = _currentQuestion/7;
    final quiz = ref.watch(QuizProvider);
    final count = ref.watch(counterProvider);
    final score = ref.watch(scoreProvider);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:  quiz is QuizState ? Column(
              children: [
                SizedBox(
                  height:350,
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
                        top: 120,
                        left: 28,
                        child: Container(
                        height: 180,
                        width:350,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(1,1),
                              blurRadius: 3,
                              spreadRadius: 1,
                              color: Colors.lightBlueAccent.withOpacity(0.3),
                            )
                          ]
                        ),
                          child: Padding(
                              padding: const EdgeInsets.all(16),
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
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                     quiz.difficulty==2 ?
                                        Text(quiz.question, style: GoogleFonts.openSans(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                      ),)
                                      : Image.network(quiz.question, height: 80, width:150),

                                       const SizedBox(width: 8,),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20,),
                              ],
                            ),
                          ),
                      ),
                      ),
                      Positioned(
                        top: 40,
                        left: 20,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                // Background container with curved borders
                                Container(
                                  height: 30,
                                  width: 320,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                // Foreground container with curved borders showing progress
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  height: 30,
                                  width: progress * MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                // Text to show percentage on top of the progress indicator
                                Center(
                                  child: Text(
                                    '  ${(progress * 100).toStringAsFixed(0)}%',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
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
                        backgroundColor: option == _selectedOption ? Colors.lightBlueAccent[100] : Colors.white,
                        padding:  const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            width:  (option == _selectedOption) && (submitted!) ?
                            answer_value! ? 3: 2
                                :  (option == quiz.correctAnswer) && (submitted!) ?
                                3 : 1,
                            color: (option == _selectedOption) && (submitted!) ?
                                answer_value! ? Colors.green : Colors.red
                                :  (option == quiz.correctAnswer) && (submitted!) ?
                                Colors.green
                                : Colors.black,
                          ),
                        ),
                      ),
                      child: (option == _selectedOption) && (submitted!) ?  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          answer_value! ?  Image.asset('assets/Practice_Screen/correct.png', height: 20, width:30)
                          : Image.asset('assets/Practice_Screen/wrong.png', height: 20, width:30 ,),
                          quiz.difficulty==2 ?  Align(alignment: Alignment.center, child:  Image.network(option, height: 60, width:100)) :
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              option,
                              style: GoogleFonts.openSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ]
                      ) : (option == quiz.correctAnswer) && (submitted!) ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/Practice_Screen/correct.png', height: 20, width:20),
                          quiz.difficulty==2 ? Align(alignment: Alignment.center, child:  Image.network(option, height: 60, width:150))
                          : Align(
                            alignment: Alignment.center,
                            child: Text(
                              option,

                              style: GoogleFonts.openSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ],
                      ) : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          quiz.difficulty==2 ? Align(alignment: Alignment.center, child:  Image.network(option, height: 60, width:150))
                              : Align(
                            alignment: Alignment.center,
                            child: Text(
                              option,
                              style: GoogleFonts.openSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                    padding: const EdgeInsets.all(20),
                    child:
                    ElevatedButton(
                        onPressed: () async {
                          if(_isPrimary!) {
                            setState(() {
                              submitted = true;
                              _checkAnswer(quiz.correctAnswer);
                              toggleButton();
                              if(_selectedOption == null) _unattempted++;
                            });
                          }
                          else{
                            if(count>7) {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (ctx) => ScoreScreen(score: quiz.score,),
                              ),
                              );
                            }
                            setState(() {
                              submitted = false;
                              toggleButton();
                              updateCurrentQuestion();
                            });
                              ref.read(counterProvider.notifier).state++;
                              ref.read(QuizProvider.notifier)
                                  .fetchNextQuestion(answer_value);

                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isPrimary! ?  Colors.blue : Colors.blue.withOpacity(0.8),
                          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 16),
                        ),
                        child:  Container(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text( _isPrimary! ? AppLocalizations.of(context)!.check_answer : AppLocalizations.of(context)!.next,
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
            ) :  quiz is MatchState ?  Column(
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
                                  offset: const Offset(1,1),
                                  blurRadius: 3,
                                  spreadRadius: 1,
                                  color: Colors.lightBlueAccent.withOpacity(0.3),
                                )
                              ]
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 200,
                                        child: Text(quiz.question, style: GoogleFonts.openSans(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),),
                                      ),
                                      const SizedBox(width: 8,),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20,),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40,
                        left: 19,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              // Background container with curved borders
                              Container(
                                height: 40,
                                width: 300,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              // Foreground container with curved borders showing progress
                              AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                height: 40,
                                width: progress * MediaQuery.of(context).size.width * 0.8,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              // Text to show percentage on top of the progress indicator
                              Center(
                                child: Text(
                                  '  ${(progress * 100).toStringAsFixed(0)}%',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: (quiz.ColumnA).map<Widget>((letter) {
                          bool isFrozenA = _frozenPairs.any((pair) => pair['alphabet'] == letter);
                          bool isIncorrectA = _incorrectPairs.any((pair) => pair['alphabet'] == letter);
                          return GestureDetector(
                            onTap: () {
                              if (!isFrozenA && !isIncorrectA) {
                                setState(() {
                                  _selectedColumnA = letter;
                                  _wrongSelectionB = null; // Reset wrong selection on new Column A selection
                                });
                                if (_selectedColumnB != null) {
                                  checkMatch(_selectedColumnA!, _selectedColumnB!, quiz.correctAnswer);
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isFrozenA
                                    ? Colors.green
                                    : (isIncorrectA ? Colors.red : (_selectedColumnA == letter ? Colors.blueAccent : Colors.white)),
                                border: Border.all(
                                  color: isFrozenA || isIncorrectA
                                      ? (isIncorrectA ? Colors.red : Colors.green)
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                letter,
                                style: const TextStyle(fontSize: 30),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: (quiz.ColumnB).map<Widget>((imageUrl) {
                          bool isFrozenB = _frozenPairs.any((pair) => pair['signImage'] == imageUrl);
                          bool isIncorrectB = _incorrectPairs.any((pair) => pair['signImage'] == imageUrl);
                          return GestureDetector(
                            onTap: () {
                              if (!isFrozenB && !isIncorrectB) {
                                setState(() {
                                  _selectedColumnB = imageUrl;
                                  _wrongSelectionB = null; // Reset wrong selection
                                });
                                if (_selectedColumnA != null) {
                                  checkMatch(_selectedColumnA!, _selectedColumnB!, quiz.correctAnswer);
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                color: isFrozenB
                                    ? Colors.green
                                    : (isIncorrectB
                                    ? Colors.red
                                    : (_selectedColumnB == imageUrl ? Colors.greenAccent : Colors.white)),
                                border: Border.all(
                                  color: isFrozenB || isIncorrectB
                                      ? (isIncorrectB ? Colors.red : Colors.green)
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Image.network(
                                imageUrl,
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    if (hasUserCompletedSelection(quiz.ColumnA.length) && _showMatchAnswer)
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            "Selected Options",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          ..._frozenPairs.map((pair) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(pair['alphabet'], style: const TextStyle(color: Colors.white)),
                                  Image.network(pair['signImage'], height: 30, width: 30),
                                ],
                              ),
                            );
                          }).toList(),
                          ..._incorrectPairs.map((pair) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(pair['alphabet'], style: const TextStyle(color: Colors.white)),
                                  Image.network(pair['signImage'], height: 30, width: 30),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8,),
                    if (hasUserCompletedSelection(quiz.ColumnA.length) && _showMatchAnswer)
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              "Correct Answer",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            ...quiz.correctAnswer.map((answer) {
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(answer['alphabet'], style: const TextStyle(color: Colors.white)),
                                    Image.network(answer['signImage'], height: 30, width: 30),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                  ],
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
                  padding: const EdgeInsets.all(20),
                  child:
                  ElevatedButton(
                      onPressed: () async {
                        checkMatchingAnswer(quiz.correctAnswer);
                          setState(() {
                            if(_frozenPairs == [] && _incorrectPairs == [])  _unattempted++;
                          });
                          if(count>7) {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (ctx) => ScoreScreen(score: score,),
                            ),
                            );
                          }

                          else {
                            setState(() {
                              updateCurrentQuestion();
                              _frozenPairs = [];
                              _incorrectPairs = [];
                              _showMatchAnswer = false;
                            });
                            ref
                                .read(counterProvider.notifier)
                                .state++;
                            ref.read(QuizProvider.notifier)
                                .fetchNextQuestion(answer_value);

                            // }
                          }
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isPrimary! ?  Colors.blue : Colors.blue.withOpacity(0.8),
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 16),
                      ),
                      child:  Container(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(AppLocalizations.of(context)!.next,
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
            ) : null,
          ),
        ),
      ),
    );
  }

}
