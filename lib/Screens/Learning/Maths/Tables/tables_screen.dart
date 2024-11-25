import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nishabdvaani/Screens/Learning/Maths/Tables/table.dart';

import '../../../../Widgets/LearningWidgets/table_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TablesScreen extends StatefulWidget {
  const TablesScreen({super.key});

  @override
  _TablesScreenState createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  int? selectedTable;

  final List<Map<String, String>> tableCards = [
    {'number': '2', 'image': 'assets/Tables/2.jpg'},
    {'number': '3', 'image': 'assets/Tables/3.jpg'},
    {'number': '4', 'image': 'assets/Tables/4.jpg'},
    {'number': '5', 'image': 'assets/Tables/5.jpg'},
    {'number': '6', 'image': 'assets/Tables/6.jpg'},
    {'number': '7', 'image': 'assets/Tables/7.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(
              AppLocalizations.of(context)!.tables,
              style: GoogleFonts.openSans(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),
            ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 4, // Adjust the aspect ratio as needed
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
              ),
              itemCount: tableCards.length,
              itemBuilder: (context, index) {
                final tableNumber = int.parse(tableCards[index]['number']!);
                final imagePath = tableCards[index]['image']!;
                return TableCard(
                  tableNumber: tableNumber,
                  imagePath: imagePath,
                  isSelected: selectedTable == tableNumber,
                  onTap: () {
                    setState(() {
                      selectedTable = selectedTable == tableNumber ? null : tableNumber;
                    });
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: selectedTable != null
                  ? () {
                if(selectedTable == 2){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (ctx) => NumberTable(multiplier: 2),
                  ),
                  );

                }
                if(selectedTable == 3){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (ctx) => NumberTable(multiplier: 3),
                  ),
                  );

                }
                if(selectedTable == 4){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (ctx) => NumberTable(multiplier: 4),
                  ),
                  );

                }
                if(selectedTable == 5){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (ctx) => NumberTable(multiplier: 5),
                  ),
                  );

                }
                if(selectedTable == 6){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (ctx) => NumberTable(multiplier: 6),
                  ),
                  );

                }
                if(selectedTable == 7){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (ctx) => NumberTable(multiplier: 7),
                  ),
                  );

                }
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedTable != null ? Colors.orange : Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
              ),
              child: Text(
                AppLocalizations.of(context)!.continue_text,
                style: GoogleFonts.openSans(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
