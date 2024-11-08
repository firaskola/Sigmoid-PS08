import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';

class HeartRateGraph extends StatelessWidget {
  final List<HealthDataPoint> heartRateData;

  HeartRateGraph({required this.heartRateData});

  @override
  Widget build(BuildContext context) {
    if (heartRateData.isEmpty) {
      return Center(child: Text("No heart rate data available"));
    }

    List<FlSpot> spots = List.generate(
      heartRateData.length,
      (index) => FlSpot(
        index.toDouble(),
        heartRateData[index].value.toDouble(),
      ),
    );

    return Container(
      margin: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width * 0.9,
      height: 400,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Expanded(
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Theme.of(context).colorScheme.primary,
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
                gridData: FlGridData(
                  show: true,
                  getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.2),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                      reservedSize: 40, // Adjust padding if needed
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: (heartRateData.length ~/ 5).toDouble(),
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < heartRateData.length) {
                          String timeLabel = DateFormat('HH:mm')
                              .format(heartRateData[index].dateFrom);
                          return Text(
                            timeLabel,
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                    show: true, border: Border.all(color: Colors.black12)),
                lineTouchData: LineTouchData(enabled: true),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
