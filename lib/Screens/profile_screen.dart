import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nishabdvaani/Provider/cookie_provider.dart';
import 'package:nishabdvaani/Provider/tokenProvider.dart';
import 'package:nishabdvaani/Screens/Profile/language_toggle.dart';
import 'package:nishabdvaani/Screens/welcome.dart';
import 'package:nishabdvaani/Widgets/Profile/result_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../Widgets/Profile/streak_calendar_widget.dart';
import 'package:nishabdvaani/Provider/profile_provider.dart';


class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {

  void _openStreakOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return const FractionallySizedBox(
            heightFactor: 0.75,
            child: StreakCalendarWidget(),
          );
        });
  }

  void _openScoreCardOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return FractionallySizedBox(
            heightFactor: 0.75,
            child: ResultChart(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // final lang = ref.read(languageProvider);
    final profile = ref.watch(ProfileProvider);
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Align(
            alignment: Alignment.center,
            child: Text(AppLocalizations.of(context)!.profile, style: GoogleFonts.openSans(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black,),
            ),
          ),
          backgroundColor: Colors.lightBlue[100],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/Home_Screen/card.png'),
              ),
              const SizedBox(height: 15),
              // Name
              Text(
                 profile.name,
                style: GoogleFonts.openSans(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              // Phone or Email
              Text(
                profile.email,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 30),

              profileWidgets(Icons.history, AppLocalizations.of(context)!.streaks, _openStreakOverlay),
              profileWidgets(Icons.format_list_numbered_sharp,AppLocalizations.of(context)!.scorecard, _openScoreCardOverlay),
              LanguageToggle(),
              // profileWidgets(Icons.settings, 'Settings', _openLanguageChangeOverlay),


              const SizedBox(height: 54,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(onPressed:  () async {
                          await ref.read(cookieProvider.notifier).clearCookie();
                          ref.read(tokenProvider.notifier).state = null;
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (ctx) => Welcome(),
                            ),
                          );
                         },
                        icon: const Icon(Icons.logout, color: Colors.red, size: 30,),
                      ),
                        const SizedBox(width: 10),
                        Text(
                          AppLocalizations.of(context)!.logout,
                          style: GoogleFonts.openSans(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }


  Widget profileWidgets(IconData icon, String title,VoidCallback overlaymain) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      child: Row(

          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue[600], size: 30,),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            IconButton(onPressed: overlaymain, icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey,))
          ],
        ),
    );
  }
}
