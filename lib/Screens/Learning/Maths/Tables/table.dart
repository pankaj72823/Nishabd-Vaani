import 'dart:async';
import 'package:flutter/material.dart';

class NumberTable extends StatefulWidget {
  final int multiplier;

  NumberTable({super.key, required this.multiplier});

  @override
  _NumberTableState createState() => _NumberTableState();
}

class _NumberTableState extends State<NumberTable> {
  late List<int> tableElements;
  int currentIndex = -1;
  bool showHand = false;
  bool isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    tableElements = List.generate(10, (index) => widget.multiplier * (index + 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Table of ${widget.multiplier}"),
        backgroundColor: Colors.purple[300],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: tableElements.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${widget.multiplier} * ${index + 1} = ',
                              style: TextStyle(fontSize: 28, color: Colors.black87),
                            ),
                            AnimatedOpacity(
                              opacity: currentIndex >= index ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 500),
                              child: Text(
                                '${tableElements[index]}',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey[900],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _startTableAnimation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isButtonPressed ? Colors.purple[200]: Colors.purple,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      elevation: 10,
                    ),
                    child: Text(
                      "Start Table",
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            if (showHand)
              AnimatedPositioned(
                duration: Duration(milliseconds: 700),
                top: 15 + (currentIndex * 60), // Adjust this to match the position
                right: 60,
                child: Image.asset('assets/Tables/left_arrow.png', height: 50,),
                ),
          ],
        ),
      ),
    );
  }

  void _startTableAnimation() {
    setState(() {
      isButtonPressed = true;
    });

    Timer.periodic(Duration(seconds: 2), (timer) {
      if (currentIndex < tableElements.length - 1) {
        setState(() {
          currentIndex++;
          showHand = true;
        });

        Timer(Duration(milliseconds: 500), () {
          setState(() {
            showHand = false;
          });
        });
      } else {
        timer.cancel();
        setState(() {
          isButtonPressed = false;
        });
      }
    });
  }
}
