import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nishabdvaani/Provider/profile_provider.dart';
import 'package:nishabdvaani/Screens/Learning/learning_screen.dart';
import 'package:nishabdvaani/Screens/conversion.dart';
import 'package:nishabdvaani/Screens/home_screen.dart';
import 'package:nishabdvaani/Screens/practice_quiz.dart';
import 'package:nishabdvaani/Screens/profile_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TabsScreen extends ConsumerStatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 2; // Start with HomeScreen selected

  final List<Widget> _pages = [
    const LearningScreen(),
    const Conversion(),
    const HomeScreen(),
    const PracticeQuiz(),
    // EnglishBoard(),

   const ProfileScreen(),
  ];

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }
  @override
  void initState()  {
    super.initState();
     ref.read(ProfileProvider.notifier).profileDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: _pages[_selectedPageIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: _selectedPageIndex == 2 ? Colors.blue : Colors.white,
        onPressed: () => _selectPage(2),
        child: Icon(Icons.home, color: _selectedPageIndex == 2 ? Colors.white : Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed, // Ensures all labels are shown
        onTap: (index) {
          if (index != 2) {
            _selectPage(index);
          }
        },
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.school, size: 35),
            label:  AppLocalizations.of(context)!.learning,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.change_circle, size: 35),
            label: AppLocalizations.of(context)!.conversion,
          ),
          BottomNavigationBarItem(
            icon: SizedBox.shrink(), // Empty to maintain layout, FAB handles the Home icon
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment, size: 35),
            label: AppLocalizations.of(context)!.practice,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 35),
            label: AppLocalizations.of(context)!.profile,
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true, // Show all labels, even if not selected
      ),
    );
  }
}
