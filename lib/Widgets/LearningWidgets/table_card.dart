import 'package:flutter/material.dart';

class TableCard extends StatelessWidget {
  final int tableNumber;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const TableCard({
    super.key,
    required this.tableNumber,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : Colors.blue,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 120,
              width: 120,
            ),
            SizedBox(height: 10),
            Text(
              'Table of $tableNumber',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
