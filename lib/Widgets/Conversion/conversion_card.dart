import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nishabdvaani/Screens/sign_to_text.dart';
import 'package:nishabdvaani/Screens/text_to_sign.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConversionCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const ConversionCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          const BoxShadow(
            color: Colors.grey,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(imagePath, height:  90,),
          SizedBox(height: 8.0),
          Text(
            title,
            style: GoogleFonts.openSans(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Align(
            alignment: Alignment.center,
            child: Text(
              description,
              style: GoogleFonts.openSans(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () {
              HapticFeedback.heavyImpact();
              if(title== AppLocalizations.of(context)!.sign_to_text) {
                Navigator.push(context, MaterialPageRoute(
                    builder: (ctx) => SignToText(),
                ),
                );
              }
              else{
                Navigator.push(context, MaterialPageRoute(
                    builder: (ctx) => TextToSign(),
                ),
                );
              }
            },
            child: Text(
              AppLocalizations.of(context)!.start,
              style: GoogleFonts.openSans(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(
                  color: Colors.lightBlueAccent, // Initial border color
                  width: 2,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10 ), // Proper spacing
              textStyle: TextStyle(fontSize: 16),
              elevation: 8, // Adds some shadow to elevate the button
            ).copyWith(
              side: WidgetStateProperty.resolveWith<BorderSide>((Set<WidgetState> states) {
                if (states.contains(WidgetState.pressed)) {
                  return BorderSide(
                    color: Colors.orangeAccent,
                    width: 3,
                  );
                }
                return BorderSide(
                  color: Colors.lightBlueAccent,
                  width: 2,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}