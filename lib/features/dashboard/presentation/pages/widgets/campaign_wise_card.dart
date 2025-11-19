import 'package:crm_maximise/features/dashboard/models/campaign_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CampaignWiseCard extends StatefulWidget {
  final CampaignResponse data;

  const CampaignWiseCard({super.key, required this.data});

  @override
  State<CampaignWiseCard> createState() => _CampaignWiseCardState();
}

class _CampaignWiseCardState extends State<CampaignWiseCard> {
  String selectedSource = "all";

  // ⭐ UNIVERSAL RESPONSIVE SCALE
  double scale(BuildContext context, double value) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 900) return value * 1.35;
    if (width >= 600) return value * 1.15;
    if (width <= 340) return value * 0.9;

    return value;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.data.campaigns
        .where((c) => selectedSource == "all" || c.source == selectedSource)
        .toList();

    final summary = widget.data.summary;
    final totalCampaigns = summary['totalCampaigns'] ?? 0;
    final totalLeads = summary['totalLeads'] ?? 0;
    final bestCampaign = summary['bestCampaign']?['displayName'] ?? "-";

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0.4,
      margin: EdgeInsets.symmetric(vertical: scale(context, 6)),
      child: Padding(
        padding: EdgeInsets.all(scale(context, 16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            SizedBox(height: scale(context, 14)),
            _buildFilterChips(context),
            SizedBox(height: scale(context, 20)),
            _buildChart(context, filtered),
            _buildSummary(context, totalCampaigns, totalLeads, bestCampaign),
          ],
        ),
      ),
    );
  }

  // ---------------- HEADER ----------------
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFE8F0FE),
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(scale(context, 6)),
          child: SvgPicture.asset(
            'assets/icons/mouse-pointer.svg',
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
          "Campaign Wise Segregation",
          style: TextStyle(
            fontSize: scale(context, 16),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // ---------------- FILTER TABS ----------------
  Widget _buildFilterChips(BuildContext context) {
    return Row(
      children: [
        _filterChip(context, "All", "all"),
        SizedBox(width: scale(context, 8)),
        _filterChip(context, "Facebook", "facebook"),
        SizedBox(width: scale(context, 8)),
        _filterChip(context, "Website", "website"),
      ],
    );
  }

  Widget _filterChip(BuildContext context, String label, String key) {
    final active = key == selectedSource;
    return GestureDetector(
      onTap: () => setState(() => selectedSource = key),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: scale(context, 14),
          vertical: scale(context, 6),
        ),
        decoration: BoxDecoration(
          color: active ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: scale(context, 11),
          ),
        ),
      ),
    );
  }

  // ---------------- BAR CHART ----------------
  Widget _buildChart(BuildContext context, List<CampaignItem> filtered) {
    final double maxY = _calculateMaxY(filtered);

    // Width per bar
    final double barWidth = scale(context, 20); // adjust for spacing
    final double chartWidth = filtered.length * barWidth;

    return SizedBox(
      height: scale(context, 260),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: chartWidth < MediaQuery.of(context).size.width
              ? MediaQuery.of(context).size.width
              : chartWidth, // never smaller than screen
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: BarChart(
              BarChartData(
                maxY: maxY,
                minY: 0,

                // ⬇ Grid lines
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _cleanInterval(maxY),
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.shade300,
                    strokeWidth: 1,
                  ),
                ),

                borderData: FlBorderData(show: false),

                // ⬇ Axis & labels
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: _cleanInterval(maxY),
                      reservedSize: 20,
                      getTitlesWidget: (value, _) => Text(
                        value.toInt().toString(),
                        style: TextStyle(fontSize: scale(context, 10)),
                      ),
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, _) {
                        int index = value.toInt();
                        if (index >= filtered.length) return const SizedBox();

                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            filtered[index].displayName.length > 4
                                ? filtered[index].displayName.substring(0, 4)
                                : filtered[index].displayName,
                            style: TextStyle(fontSize: scale(context, 10)),
                          ),
                        );
                      },
                    ),
                  ),

                ),

                // ⬇ Bars
                barGroups: [
                  for (int i = 0; i < filtered.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: filtered[i].count.toDouble(),
                          width: scale(context, 18),
                          color: _parseColor(filtered[i].color),
                          borderRadius: BorderRadius.circular(6),
                        )
                      ],
                    )
                ],
                barTouchData: BarTouchData(
                  enabled: true,
                  handleBuiltInTouches: true,

                  touchTooltipData: BarTouchTooltipData(
                    tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    tooltipMargin: 10,
                    fitInsideVertically: true,
                    fitInsideHorizontally: true,
                    getTooltipColor: (spot) => Colors.white,
                    tooltipBorder: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),

                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final item = filtered[group.x.toInt()];
                      return BarTooltipItem(
                        "${item.displayName}\n",
                        const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: "● ",
                            style: TextStyle(
                              color: _parseColor(item.color),
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text: "${item.count} leads",
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 13,
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
    );
  }

  // ---------------- SUMMARY SECTION ----------------
  Widget _buildSummary(
      BuildContext context,
      int totalCampaigns,
      int totalLeads,
      String bestCampaign,
      ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _summaryItem(context, "Total Campaigns", "$totalCampaigns"),
            _summaryItem(context, "Total Leads", "$totalLeads"),
          ],
        ),
        SizedBox(height: scale(context, 4)),
        Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _summaryItem(context, "Best Campaign", bestCampaign),
            ],
          ),
        ),
      ],
    );
  }

  Widget _summaryItem(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
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
                title,
                style: TextStyle(
                  fontSize: scale(context, 11),
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- UTILITIES ----------------

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xff')));
    } catch (_) {
      return Colors.blueGrey;
    }
  }

  // double _calculateMaxY(List<CampaignItem> data) {
  //   if (data.isEmpty) return 10;
  //
  //   final int maxValue =
  //   data.map((e) => e.count).reduce((a, b) => a > b ? a : b);
  //
  //   return (maxValue + (maxValue * 0.3)).clamp(6, 200).toDouble();
  // }

  double _calculateMaxY(List<CampaignItem> data) {
    if (data.isEmpty) return 1;

    int maxValue = data.map((e) => e.count).reduce((a, b) => a > b ? a : b);

    if (maxValue <= 2) return 2;
    if (maxValue <= 4) return 4;
    if (maxValue <= 6) return 6;
    if (maxValue <= 8) return 8;
    if (maxValue <= 10) return 10;
    if (maxValue <= 15) return 15;
    if (maxValue <= 20) return 20;

    return maxValue.toDouble() + 5; // fallback for higher numbers
  }


  double _cleanInterval(double maxY) {
    if (maxY <= 4) return 1;
    if (maxY <= 8) return 2;
    if (maxY <= 15) return 3;
    if (maxY <= 20) return 5;
    return maxY / 4;
  }



}
