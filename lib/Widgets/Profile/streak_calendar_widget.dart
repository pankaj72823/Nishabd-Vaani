import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StreakCalendarWidget extends StatefulWidget {
  const StreakCalendarWidget({super.key});

  @override
  State<StreakCalendarWidget> createState() => _StreakCalendarWidgetState();
}

class _StreakCalendarWidgetState extends State<StreakCalendarWidget> {


  final List<bool> streakData = List.generate(30, (index) => index % 2 == 0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset('assets/Profile/consistency.png', height: 30, width: 30,),
              const SizedBox(width: 10,),
              Text(
                'August Month Streak',
                style: GoogleFonts.openSans(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              itemCount: streakData.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return StreakDayWidget(
                  day: index + 1,
                  isStreak: streakData[index],
                );
              },
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class StreakDayWidget extends StatelessWidget {
  final int day;
  final bool isStreak;

  StreakDayWidget({super.key, required this.day, required this.isStreak});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        color: isStreak ? Colors.green : Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isStreak ? Icons.local_fire_department : Icons.circle_outlined,
              color: isStreak ? Colors.white : Colors.grey,
              size: 18,
            ),
            SizedBox(height: 4),
            Text(
              '$day',
              style: TextStyle(
                fontSize: 12,
                color: isStreak ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
