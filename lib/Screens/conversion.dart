import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nishabdvaani/Widgets/Conversion/conversion_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Conversion extends StatelessWidget {
  const Conversion({super.key});
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      title: Align(
        alignment: Alignment.center,
        child: Text(AppLocalizations.of(context)!.conversion_tool, style: GoogleFonts.openSans(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,),
            ),
      ),
    backgroundColor: Colors.lightBlue[100],
    ),
    body: Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ConversionCard(
            imagePath: 'assets/Conversion/signtotext.gif',
            title: AppLocalizations.of(context)!.sign_to_text,
            description: AppLocalizations.of(context)!.convert_sign_language,
          ),
          const SizedBox(height: 40.0),
          ConversionCard(
            imagePath: 'assets/Conversion/texttosign.gif',
            title: AppLocalizations.of(context)!.text_to_sign,
            description:AppLocalizations.of(context)!.text_to_sign,
          ),
        ],
      ),
    ),
  );
}
}


