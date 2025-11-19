import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../models/lead_quality_model.dart';

class LeadStatusSection extends StatefulWidget {
  final List<LeadQualityItem> quality;
  final Map<String, dynamic> summary;

  const LeadStatusSection({
    super.key,
    required this.quality,
    required this.summary,
  });

  @override
  State<LeadStatusSection> createState() => _LeadStatusSectionState();
}

class _LeadStatusSectionState extends State<LeadStatusSection> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    double scale(double v) {
      if (width >= 600) return v * 1.3;
      if (width <= 340) return v * 0.9;
      return v;
    }

    final totalLeads = (widget.summary['totalLeads'] ?? 0) as int;

    final chartData = widget.quality
        .where((q) => q.count > 0)
        .map((q) => _PieData(
      name: q.displayName,
      value: q.count.toDouble(),
      color: _parseColor(q.color),
    ))
        .toList();

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(scale(16)),
      ),
      margin: EdgeInsets.symmetric(vertical: scale(8)),
      elevation: 0.4,
      child: Padding(
        padding: EdgeInsets.all(scale(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------- HEADER -------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F0FE),
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(scale(6)),
                      child: SvgPicture.asset(
                        'assets/icons/tick.svg',
                        width: scale(18),
                        height: scale(18),
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF3B82F6),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    SizedBox(width: scale(8)),
                    Text(
                      'Lead Status',
                      style: TextStyle(
                        fontSize: scale(16),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.more_horiz, color: Colors.grey),
              ],
            ),

            SizedBox(height: scale(16)),

            // ------- Donut Chart (SMOOTH VERSION) -------
            LeadStatusDonut(
              chartData: chartData,
              totalLeads: totalLeads,
              scale: scale,
            ),

            SizedBox(height: scale(16)),

            // ------- Breakdown Section -------
            SizedBox(
              height: scale(100),
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: GridView.count(
                  controller: _scrollController,
                  crossAxisCount: 2,
                  childAspectRatio: 3.8,
                  crossAxisSpacing: scale(8),
                  mainAxisSpacing: scale(6),
                  padding: EdgeInsets.all(scale(3)),
                  children: widget.quality.map((q) {
                    final percent =
                    totalLeads == 0 ? 0.0 : (q.count / totalLeads) * 100;

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: scale(4)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: scale(8),
                                height: scale(8),
                                decoration: BoxDecoration(
                                  color: _parseColor(q.color),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: scale(6)),
                              Expanded(
                                child: Text(
                                  q.displayName,
                                  style: TextStyle(
                                    fontSize: scale(11),
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade800,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                q.count.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: scale(11),
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: scale(4)),

                          ClipRRect(
                            borderRadius: BorderRadius.circular(scale(4)),
                            child: LinearProgressIndicator(
                              value: percent / 100,
                              backgroundColor: Colors.grey.shade200,
                              color: _parseColor(q.color),
                              minHeight: scale(3),
                            ),
                          ),

                          SizedBox(height: scale(2)),

                          Text(
                            '${percent.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: scale(11),
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) return Colors.grey;
    return Color(int.parse(hexColor.replaceAll('#', '0xFF')));
  }
}

class LeadStatusDonut extends StatefulWidget {
  final List<_PieData> chartData;
  final int totalLeads;
  final double Function(double) scale;

  const LeadStatusDonut({
    super.key,
    required this.chartData,
    required this.totalLeads,
    required this.scale,
  });

  @override
  State<LeadStatusDonut> createState() => _LeadStatusDonutState();
}

class _LeadStatusDonutState extends State<LeadStatusDonut> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final scale = widget.scale;
    final chartData = widget.chartData;

    return SizedBox(
      height: scale(200),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SfCircularChart(
            margin: EdgeInsets.zero,
            tooltipBehavior: TooltipBehavior(enable: false),

            onSelectionChanged: (args) {
              if (args.pointIndex != null &&
                  args.pointIndex! < chartData.length) {
                setState(() => touchedIndex = args.pointIndex!);

                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) setState(() => touchedIndex = -1);
                });
              }
            },

            series: <DoughnutSeries<_PieData, String>>[
              DoughnutSeries<_PieData, String>(
                dataSource: chartData,
                xValueMapper: (d, _) => d.name,
                yValueMapper: (d, _) => d.value,
                pointColorMapper: (d, _) => d.color,

                radius: '105%',
                innerRadius: '62%',
                strokeColor: Colors.white,
                strokeWidth: 6,

                selectionBehavior: SelectionBehavior(
                  enable: true,
                  selectedOpacity: 1.0,
                  unselectedOpacity: 1.0,
                ),

              ),
            ],
          ),

          // Center Label
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${widget.totalLeads}',
                style: TextStyle(
                  fontSize: scale(34),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text('Total Leads', style: TextStyle(color: Colors.grey)),
            ],
          ),

          // Floating Tooltip (Same as LeadSourceCard)
          if (touchedIndex != -1)
            Positioned(
              top: scale(10),
              child: AnimatedOpacity(
                opacity: touchedIndex != -1 ? 1 : 0,
                duration: const Duration(milliseconds: 180),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: scale(16),
                    vertical: scale(10),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    "${chartData[touchedIndex].name} : ${chartData[touchedIndex].value.toInt()} leads",
                    style: TextStyle(
                      fontSize: scale(14),
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PieData {
  final String name;
  final double value;
  final Color color;

  _PieData({
    required this.name,
    required this.value,
    required this.color,
  });
}
