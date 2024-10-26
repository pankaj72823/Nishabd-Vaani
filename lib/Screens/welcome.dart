import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nishabdvaani/Screens/signin.dart';
import 'package:nishabdvaani/Screens/signup.dart';
import 'package:nishabdvaani/Widgets/HomeScreen/welcome_widget.dart';

class Welcome extends StatelessWidget{
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return WelcomeWidget(
      child: Column(
        children: [
          Flexible(
            flex: -2,
            child: Center(
              child: Column(
                children: [
                  Image.asset('assets/Home_Screen/temp_logo.png', height: 90,),

                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (e) => SignIn(),
                          ),
                        );
                      },
                      child: Container(
                        child: Text(
                          'Sign in',
                          style:
                          GoogleFonts.openSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (e) => Signup(),
                        ),
                      );
                    },
                    child: Container(
                      height: 100,
                      width: 180,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                        child: Text(
                          'Signup',
                          style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 28),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

}