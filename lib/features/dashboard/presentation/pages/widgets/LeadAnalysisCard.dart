import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../models/daily_generation_model.dart';

class LeadAnalysisCard extends StatefulWidget {
  final LeadAnalysisResponse data;
  final Function(String) onViewChange;
  final String view;

  const LeadAnalysisCard({
    super.key,
    required this.data,
    required this.onViewChange,
    required this.view,
  });

  @override
  State<LeadAnalysisCard> createState() => _LeadAnalysisCardState();
}

class _LeadAnalysisCardState extends State<LeadAnalysisCard> {
  late String selectedView;

  // ⭐ UNIVERSAL SCALE FUNCTION
  double scale(BuildContext context, double value) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 900) return value * 1.35;
    if (width >= 600) return value * 1.15;
    if (width <= 340) return value * 0.9;

    return value;
  }

  @override
  void initState() {
    super.initState();
    selectedView = widget.view;
  }

  @override
  void didUpdateWidget(covariant LeadAnalysisCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.view != widget.view) selectedView = widget.view;
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.data.data;
    final summary = widget.data.summary;

    final totalLeads = (summary["totalLeads"] ?? 0).toInt();
    final avg = (summary["avgLeadsPerPeriod"] ?? 0.0).toDouble();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0.3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(scale(context, 16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            SizedBox(height: scale(context, 18)),
            _buildChart(context, items),
            SizedBox(height: scale(context, 16)),
            _buildSummary(context, totalLeads, avg),
          ],
        ),
      ),
    );
  }

  // ---------------- HEADER ----------------
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFE8F0FE),
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(scale(context, 6)),
              child: SvgPicture.asset(
                'assets/icons/bar.svg',
                width: scale(context, 18),
                height: scale(context, 18),
                colorFilter: const ColorFilter.mode(
                  Color(0xFF3B82F6),
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(width: scale(context, 8)),
            Text(
              "Lead Analysis",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: scale(context, 16),
              ),
            ),
          ],
        ),

        // View Switcher
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedView,
            items: const [
              DropdownMenuItem(value: "24h", child: Text("Daily",style: TextStyle(fontSize: 10),)),
              DropdownMenuItem(value: "weekly", child: Text("Weekly",style: TextStyle(fontSize: 10))),
              DropdownMenuItem(value: "monthly", child: Text("Monthly",style: TextStyle(fontSize: 10))),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() => selectedView = value);
              widget.onViewChange(value);
            },
          ),
        )
      ],
    );
  }

  // ---------------- DYNAMIC MAX Y ----------------
  double getMaxY(List<LeadAnalysisItem> items) {
    final maxValue = items.isEmpty
        ? 10
        : items.map((e) => e.count).reduce((a, b) => a > b ? a : b);

    return (maxValue + 2).toDouble();
  }

  // ---------------- CHART ----------------
  Widget _buildChart(BuildContext context, List<LeadAnalysisItem> items) {
    final double maxY = getMaxY(items);

    return SizedBox(
      height: scale(context, 220),
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: maxY,


          // GRID LINES (Y only)
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (maxY / 5).ceilToDouble(),
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.shade300,
              strokeWidth: 1,
            ),
          ),

          borderData: FlBorderData(show: false),


          // TITLES
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: (maxY / 5).ceilToDouble(),
                reservedSize: 32,
                getTitlesWidget: (value, _) => Text(
                  "${value.toInt()}",
                  style: TextStyle(fontSize: scale(context, 11)),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  int i = value.toInt();
                  if (i >= items.length) return const SizedBox();
                  return Padding(
                    padding: EdgeInsets.only(top: scale(context, 6)),
                    child: Text(
                      items[i].period,
                      style: TextStyle(fontSize: scale(context, 11)),
                    ),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),

          // LINE DATA
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: Colors.blue,
              barWidth: scale(context, 2),
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withOpacity(0.15),
              ),
              spots: [
                for (int i = 0; i < items.length; i++)
                  FlSpot(
                    i.toDouble(),
                    items[i].count.toDouble(),
                  ),
              ],
            ),
          ],
          lineTouchData: LineTouchData(
            enabled: true,
            handleBuiltInTouches: true,

            touchTooltipData: LineTouchTooltipData(
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipColor: (spot) => Colors.white,
              tooltipBorder: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final index = spot.spotIndex;

                  return LineTooltipItem(
                    "${items[index].period}\n",
                    const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: "● ",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: "${items[index].count} leads",
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- SUMMARY ----------------
  Widget _buildSummary(BuildContext context, int total, double avg) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _summaryBlock(
          context,
          total.toString(),
          "Total Leads This Period",
        ),
        _summaryBlock(
          context,
          avg.toStringAsFixed(0),
          selectedView == "24h"
              ? "Avg per Hour"
              : selectedView == "monthly"
              ? "Avg per Month"
              : "Avg per Day",
        ),
      ],
    );
  }

  Widget _summaryBlock(
      BuildContext context, String value, String label) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: scale(context, 22),
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: scale(context, 4)),
            Text(
              label,
              style: TextStyle(
                fontSize: scale(context, 12),
                color: Colors.grey.shade600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
