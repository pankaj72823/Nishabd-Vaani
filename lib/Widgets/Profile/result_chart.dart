import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nishabdvaani/Provider/profile_provider.dart';

class ResultChart extends ConsumerWidget{
   const ResultChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(ProfileProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: LineChart(
          LineChartData(
          minX: 1,
          maxX: 5,
          minY: 0,
          maxY: 7,
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false, // Disable top titles
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                  reservedSize: 30,// Disable right titles
                ),
              ),
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta){
                    if(value==1.0){
                      return Text('Test 1');
                    }
                    else if(value==2.0){
                      return Text('Test 2');
                    }
                    else if(value==3.0){
                      return Text('Test 3');
                    }
                    else if(value==4.0){
                      return Text('Test 4');
                    }
                    else if(value==5.0){
                      return Text('Test 5');
                    }
                    else{
                      return Text('');
                    }

                  },
                  reservedSize: 40,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if(value==1.0){
                      return Text("${1}");
                    }
                    else if(value==2.0){
                      return Text('${2}');
                    }
                    else if(value==3.0){
                      return Text('${3}');
                    }
                    else if(value==4.0){
                      return Text('${4}');
                    }
                    else if(value==5.0){
                      return Text('${5}');
                    }
                    else if(value==6.0){
                      return Text('${6}');
                    }
                    else if(value==7.0){
                      return Text('${7}');
                    }
                    else{
                      return Text('');
                    }
                  }, // Space reserved for labels
                ),
              ),
            ),
            gridData: FlGridData(
              horizontalInterval: 1,
              verticalInterval: 1,
              show: true,
              getDrawingHorizontalLine: (value){
                return FlLine(
                  color: Colors.black.withOpacity(0.2),
                  strokeWidth: 2,
                );
              },
              drawVerticalLine: true,
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.black),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  FlSpot(1,profile.scienceMarks[0] as double),
                  FlSpot(2,profile.scienceMarks[1] as double),
                  FlSpot(3,profile.scienceMarks[2] as double),
                  FlSpot(4,profile.scienceMarks[3] as double),
                  FlSpot(5,profile.scienceMarks[4] as double),
                ],
                barWidth: 5 ,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (FlSpot spot, double xPercentage, LineChartBarData barData, int index) {
                    // Common style for all points
                    return FlDotCirclePainter(
                      radius: 5,
                      color: Colors.blue, // Common color for all points
                      strokeWidth: 1,
                    );
                  },
                ),
                isCurved: true,
                color: Color(0xff23b6e6),
              )
            ]
        ),
        ),
      ),
    );

  }

}

// Gradient:

// gradient: const LinearGradient(
//   colors: [
//     Color(0xff23b6e6),
//      Color(0xffe3d39a),
//   ],
//   begin: Alignment.topLeft,
//   end: Alignment.bottomRight,
// ),
// belowBarData: BarAreaData(
//   show: true,
//   gradient: const LinearGradient(
//     colors: [
//       Color(0xff23b6e6),
//       Color(0xffe3d39a),
//     ],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   ),
// )