import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BankrollChart extends StatelessWidget {
  final List<double> bankrollHistory;
  final String title;

  const BankrollChart({
    Key? key,
    required this.bankrollHistory,
    this.title = 'Bankroll History',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: bankrollHistory.length < 2
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.show_chart, color: Colors.grey, size: 40),
                  SizedBox(height: 10),
                  Text(
                    title,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  Text(
                    'Complete a round to start tracking',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
                SizedBox(height: 8),
                Expanded(
                  child: LineChart(
                    LineChartData(
                      gridData: GridData(
                        show: true,
                        color: Colors.grey[800]!,
                        drawVerticalLine: false,
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 25,
                            getTitlesWidget: (value, meta) {
                              int rounds = bankrollHistory.length;
                              if (value % (rounds ~/ 10 + 1) == 0) {
                                return Text(
                                  value.toInt().toString(),
                                  style: TextStyle(color: Colors.grey[600], fontSize: 10),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                'N\$${value.toInt()}',
                                style: TextStyle(color: Colors.grey[600], fontSize: 10),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: bankrollHistory.asMap().entries.map((entry) {
                            return FlSpot(entry.key.toDouble(), entry.value);
                          }).toList(),
                          isCurved: true,
                          color: _getLineColor(),
                          barWidth: 3,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: _getLineColor().withOpacity(0.2),
                          ),
                        ),
                      ],
                      minY: 0,
                      maxY: (bankrollHistory.reduce((a, b) => a > b ? a : b) * 1.2),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Color _getLineColor() {
    if (bankrollHistory.isEmpty) return Colors.grey;
    double start = bankrollHistory.first;
    double end = bankrollHistory.last;
    if (end > start) return Colors.green;
    if (end < start) return Colors.red;
    return Colors.orange;
  }
}