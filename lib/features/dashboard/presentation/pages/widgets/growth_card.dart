import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../models/revenue_growth_model.dart';

class GrowthCard extends StatefulWidget {
  final RevenueGrowthResponse data;
  final String period;
  final ValueChanged<String> onPeriodChanged;

  const GrowthCard({
    super.key,
    required this.data,
    required this.period,
    required this.onPeriodChanged,
  });

  @override
  State<GrowthCard> createState() => _GrowthCardState();
}

class _GrowthCardState extends State<GrowthCard> {
  late String selectedPeriod;

  @override
  void initState() {
    super.initState();
    selectedPeriod = widget.period;
  }

  @override
  void didUpdateWidget(covariant GrowthCard oldWidget) {
    if (oldWidget.period != widget.period) {
      setState(() => selectedPeriod = widget.period);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.data.data;
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => width > 600 ? v * 1.3 : v;

    double maxY = items.map((e) => e.totalRevenue).fold(0.0, (a, b) => a > b ? a : b);
    if (maxY == 0) maxY = 1000;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.symmetric(vertical: scale(10)),
      elevation: 0.4,
      child: Padding(
        padding: EdgeInsets.all(scale(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F0FE),
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(scale( 6)),
                    child: SvgPicture.asset(
                      'assets/icons/dollar.svg',
                      width: scale(18),
                      height: scale(18),
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF3B82F6),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text("Growth",
                      style: TextStyle(fontSize: scale(15), fontWeight: FontWeight.w700)),
                ]),

                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedPeriod,
                    items: const [
                      DropdownMenuItem(value: "weekly", child: Text("Week",)),
                      DropdownMenuItem(value: "monthly", child: Text("Month")),
                      DropdownMenuItem(value: "yearly", child: Text("Year")),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => selectedPeriod = value);
                      widget.onPeriodChanged(value);
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: scale(20)),

            // BAR GRAPH
            // BAR GRAPH
            SizedBox(
              height: scale(220),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: items.length * 60, // dynamic width → scrollable
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BarChart(
                      BarChartData(
                        groupsSpace: 22, // <<< NEW: spacing between bars

                        borderData: FlBorderData(show: false),

                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: maxY / 4,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: Colors.grey.shade300,
                            strokeWidth: 1,
                          ),
                        ),

                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: maxY / 4,
                              reservedSize: scale(40),
                              getTitlesWidget: (value, _) => Text(
                                value.toInt().toString(),
                                style: TextStyle(fontSize: scale(9), color: Colors.black54),
                              ),
                            ),
                          ),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, _) {
                                int index = value.toInt();
                                if (index >= items.length) return const SizedBox();

                                String label =
                                items[index].period.replaceAll("Week ", "W");

                                return Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(label, style: TextStyle(fontSize: scale(9))),
                                );
                              },
                            ),
                          ),
                        ),

                        maxY: maxY + (maxY * 0.2),

                        barGroups: [
                          for (int i = 0; i < items.length; i++)
                            BarChartGroupData(
                              x: i,
                              barRods: [
                                BarChartRodData(
                                  toY: items[i].totalRevenue.toDouble(),
                                  width: 20,
                                  borderRadius: BorderRadius.circular(6),
                                  gradient: LinearGradient(
                                    colors: selectedPeriod == "weekly"
                                        ? [Colors.orange, Colors.yellow.shade300]
                                        : selectedPeriod == "monthly"
                                        ? [Colors.red, Colors.pink]
                                        : [Colors.purple, Colors.deepPurpleAccent],
                                  ),
                                ),
                              ],
                            ),
                        ],

                        barTouchData: BarTouchData(
                          enabled: true,
                          handleBuiltInTouches: true,
                          touchTooltipData: BarTouchTooltipData(
                            tooltipPadding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            tooltipMargin: 8,
                            fitInsideVertically: true,
                            fitInsideHorizontally: true,
                            getTooltipColor: (spot) => Colors.white,
                            tooltipBorder: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final item = widget.data.data[group.x.toInt()];

                              return BarTooltipItem(
                                "${item.period}\n",
                                const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: "● ",
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "₹${item.totalRevenue.toStringAsFixed(0)}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
