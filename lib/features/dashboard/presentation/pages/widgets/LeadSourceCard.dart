import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../models/lead_sources_model.dart';

class LeadSourceCard extends StatefulWidget {
  final LeadSourcesResponse data;
  const LeadSourceCard({super.key, required this.data});

  @override
  State<LeadSourceCard> createState() => _LeadSourceCardState();
}

class _LeadSourceCardState extends State<LeadSourceCard> {
  LeadSourceItem? _selectedSource;

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xff')));
    } catch (_) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final totalLeads = widget.data.summary['totalLeads'] ?? 0;
    final sources = widget.data.sources;
    final isTablet = width > 600;

    double scale(double v) => isTablet ? v * 1.2 : v;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0.6,
      child: Padding(
        padding: EdgeInsets.only(
          left: scale(20),
          right: scale(20),
          top: scale(22),
          bottom: scale(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- HEADER ----------
            Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F0FE),
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(scale(6)),
                  child: SvgPicture.asset(
                    'assets/icons/trendingup.svg',
                    width: scale(18),
                    height: scale(18),
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF3B82F6),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Channel Wise Lead Quantity",
                  style: TextStyle(
                    fontSize: scale(16),
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade900,
                  ),
                ),
              ],
            ),

            SizedBox(height: scale(10)),

            // =============================================================
            //                 CHART + FLOATING LABEL (CLIPPED)
            // =============================================================
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRect(
                  child: Align(
                    alignment: Alignment.topCenter,
                    heightFactor: 0.6, // <<< removes extra bottom padding
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: SizedBox(
                        height: scale(230),
                        child: SfCircularChart(
                          margin: EdgeInsets.zero,
                          tooltipBehavior: TooltipBehavior(enable: false),

                          onSelectionChanged: (args) {
                            if (args.pointIndex != null &&
                                args.pointIndex! < sources.length) {
                              setState(() => _selectedSource = sources[args.pointIndex!]);
                              Future.delayed(const Duration(seconds: 2), () {
                                if (mounted) setState(() => _selectedSource = null);
                              });
                            }
                          },

                          series: [
                            DoughnutSeries<LeadSourceItem, String>(
                              dataSource: sources,
                              xValueMapper: (d, _) => d.displayName,
                              yValueMapper: (d, _) => d.count,
                              pointColorMapper: (d, _) => _parseColor(d.color),

                              startAngle: 270,
                              endAngle: 90,
                              innerRadius: '62%',
                              radius: '105%',

                              strokeColor: Colors.white,
                              strokeWidth: 6,

                              selectionBehavior: SelectionBehavior(
                                enable: true,
                                selectedOpacity: 1.0,
                                unselectedOpacity: 1.0,
                              ),

                              enableTooltip: false,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),


                // CENTER LABEL
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: scale(20),),
                    Text(
                      "$totalLeads",
                      style: TextStyle(
                        fontSize: scale(34),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Total Leads",
                      style: TextStyle(
                        fontSize: scale(13),
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                // FLOATING WHITE LABEL
                if (_selectedSource != null)
                  Positioned(
                    top: scale(10),
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
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        "${_selectedSource!.displayName} : ${_selectedSource!.count} leads",
                        style: TextStyle(
                          fontSize: scale(14),
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // =============================================================
            //                         LEGEND (NO EXTRA SPACE)
            // =============================================================
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: sources.map((s) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: scale(10)),
                    child: Row(
                      children: [
                        Container(
                          width: scale(10),
                          height: scale(10),
                          decoration: BoxDecoration(
                            color: _parseColor(s.color),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "${s.displayName} (${s.count})",
                          style: TextStyle(
                            fontSize: scale(13),
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
