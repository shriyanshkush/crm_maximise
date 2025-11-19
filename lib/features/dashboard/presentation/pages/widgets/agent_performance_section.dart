// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import '../../../models/agent_performance_model.dart';
//
// class AgentPerformanceSection extends StatefulWidget {
//   final List<AgentUser> users;
//
//   const AgentPerformanceSection({
//     super.key,
//     required this.users,
//   });
//
//   @override
//   State<AgentPerformanceSection> createState() =>
//       _AgentPerformanceSectionState();
// }
//
// class _AgentPerformanceSectionState extends State<AgentPerformanceSection> {
//   String _selectedPeriod = 'Last 30 days';
//   final List<String> _periodOptions = [
//     'Last 7 days',
//     'Last 30 days',
//     'Last 90 days'
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//
//     double scale(double v) {
//       if (width >= 600) return v * 1.3; // tablet
//       if (width <= 340) return v * 0.9; // small phone
//       return v;
//     }
//
//     return Card(
//       elevation: 0.4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(scale(16)),
//       ),
//       margin: EdgeInsets.symmetric(vertical: scale(8)),
//       child: Padding(
//         padding: EdgeInsets.all(scale(16)),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 🔹 Header Row
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       decoration: const BoxDecoration(
//                         color: Color(0xFFE8F0FE),
//                         shape: BoxShape.circle,
//                       ),
//                       padding: EdgeInsets.all(scale(6)),
//                       child: SvgPicture.asset(
//                         'assets/icons/bar.svg',
//                         width: scale(18),
//                         height: scale(18),
//                         colorFilter: const ColorFilter.mode(
//                           Color(0xFF3B82F6),
//                           BlendMode.srcIn,
//                         ),
//                       )
//
//                     ),
//                     SizedBox(width: scale(8)),
//                     Text(
//                       'Agent Performance',
//                       style: TextStyle(
//                         fontSize: scale(16),
//                         fontWeight: FontWeight.w700,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: scale(10)),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade100,
//                     borderRadius: BorderRadius.circular(scale(8)),
//                     border: Border.all(color: Colors.grey.shade300),
//                   ),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton<String>(
//                       value: _selectedPeriod,
//                       isDense: true,
//                       borderRadius: BorderRadius.circular(12),
//                       icon: const Icon(Icons.keyboard_arrow_down_rounded),
//                       items: _periodOptions.map((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(
//                             value,
//                             style: TextStyle(
//                               fontSize: scale(10),
//                               color: Colors.grey.shade800,
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                       onChanged: (String? newValue) {
//                         if (newValue != null) {
//                           setState(() => _selectedPeriod = newValue);
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: scale(16)),
//
//             // 🔹 Agent List
//             if (widget.users.isEmpty)
//               Padding(
//                 padding: EdgeInsets.only(top: scale(20)),
//                 child: Center(
//                   child: Text(
//                     'No agent performance data available',
//                     style: TextStyle(
//                       fontSize: scale(13),
//                       color: Colors.grey.shade500,
//                     ),
//                   ),
//                 ),
//               )
//             else
//               Column(
//                 children: widget.users.asMap().entries.map((entry) {
//                   final index = entry.key + 1;
//                   final user = entry.value;
//                   return Padding(
//                     padding: EdgeInsets.only(bottom: scale(12)),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(scale(12)),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.05),
//                             blurRadius: 8,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       padding: EdgeInsets.all(scale(14)),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Rank, Name, Revenue
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 children: [
//                                   Text(
//                                     '#$index',
//                                     style: TextStyle(
//                                       fontSize: scale(13),
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.grey.shade700,
//                                     ),
//                                   ),
//                                   SizedBox(width: scale(8)),
//                                   Text(
//                                     user.name,
//                                     style: TextStyle(
//                                       fontSize: scale(14),
//                                       fontWeight: FontWeight.w700,
//                                       color: Colors.black87,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Text(
//                                 '+₹${user.totalRevenue.toStringAsFixed(0)}',
//                                 style: TextStyle(
//                                   fontSize: scale(13),
//                                   color: user.totalRevenue > 0
//                                       ? Colors.green.shade700
//                                       : Colors.grey.shade500,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: scale(6)),
//                           Divider(height: scale(12), color: Colors.grey.shade200),
//
//                           // Leads + Score
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 children: [
//                                   Text(
//                                     'LEADS ',
//                                     style: TextStyle(
//                                       fontSize: scale(11),
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.grey.shade600,
//                                     ),
//                                   ),
//                                   Text(
//                                     '${user.leadCount}',
//                                     style: TextStyle(
//                                       fontSize: scale(12),
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black87,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 children: [
//                                   Text(
//                                     'SCORE ',
//                                     style: TextStyle(
//                                       fontSize: scale(11),
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.grey.shade600,
//                                     ),
//                                   ),
//                                   Text(
//                                     '${user.performanceScore.toStringAsFixed(0)}%',
//                                     style: TextStyle(
//                                       fontSize: scale(12),
//                                       fontWeight: FontWeight.bold,
//                                       color: _getScoreColor(
//                                           user.performanceScore),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Color _getScoreColor(double score) {
//     if (score >= 70) return Colors.green;
//     if (score >= 40) return Colors.orange;
//     return Colors.redAccent;
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../models/agent_performance_model.dart';

class AgentPerformanceSection extends StatefulWidget {

  final List<AgentUser> users;

  const AgentPerformanceSection({
    super.key,
    required this.users,
  });

  @override
  State<AgentPerformanceSection> createState() =>
      _AgentPerformanceSectionState();
}

class _AgentPerformanceSectionState extends State<AgentPerformanceSection> {
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

  String _selectedPeriod = 'Last 30 days';

  final List<String> _periodOptions = [
    'Last 7 days',
    'Last 30 days',
    'Last 90 days'
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    double scale(double v) {
      if (width >= 600) return v * 1.3;
      if (width <= 345) return v * 0.9;
      return v;
    }

    return Card(
      elevation: 0.4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(scale(16)),
      ),

      child: Padding(
        padding: EdgeInsets.all(scale(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, scale),
            SizedBox(height: scale(16)),
            _buildFullGrid(context, scale),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------
  // HEADER
  // ----------------------------------------------------------------------
  Widget _buildHeader(BuildContext context, double Function(double) scale) {
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
              padding: EdgeInsets.all(scale(6)),
              child: SvgPicture.asset(
                'assets/icons/bar.svg',
                width: scale(18),
                height: scale(18),
                colorFilter:
                const ColorFilter.mode(Color(0xFF3B82F6), BlendMode.srcIn),
              ),
            ),
            SizedBox(width: scale(10)),
            Text(
              "Agent Performance",
              style: TextStyle(
                fontSize: scale(16),
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),

        // Dropdown
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedPeriod,
            isDense: true,
            elevation: 0,
            icon: const Icon(
              Icons.arrow_drop_down,
              size: 18,
              color: Colors.grey,
            ),
            style: TextStyle(
              fontSize: scale(12),
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            items: _periodOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: scale(12),
                    color: Colors.black87,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedPeriod = value);
              }
            },
          ),
        )
      ],
    );
  }

// ----------------------------------------------------------------------
//       FULL GRID WITH HORIZONTAL + VERTICAL SCROLL
// ----------------------------------------------------------------------
  Widget _buildFullGrid(BuildContext context, double Function(double) scale) {
    final rows = widget.users;

    if (rows.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 10),
        child: Text("No agent performance data."),
      );
    }

    // Extra controller for vertical scrolling
    final ScrollController verticalController = ScrollController();

    final headers = ["Agent", "Leads", "Revenue", "Score"];

    return Container(
      height: 240,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          // ------------------- FIXED HEADER -------------------
          Container(
            color: Colors.grey.shade100,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: headers.map((h) {
                  return Container(
                    width: 120,
                    padding: EdgeInsets.symmetric(
                      vertical: scale(12),
                      horizontal: scale(8),
                    ),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                    ),
                    child: Text(
                      h,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: scale(12),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          Divider(height: 1, color: Colors.grey.shade400),

          // ------------------ BODY (SCROLL BOTH) ------------------
          Expanded(
            child: Scrollbar(
              controller: _scrollController,          // HORIZONTAL SCROLLBAR
              thumbVisibility: true,
              notificationPredicate: (notif) => notif.metrics.axis == Axis.horizontal,
              child: SingleChildScrollView(
                controller: _scrollController,       // horizontal scroll
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 120.0 * headers.length,
                  child: Scrollbar(
                    controller: verticalController,   // VERTICAL SCROLLBAR
                    thumbVisibility: true,
                    notificationPredicate: (notif) => notif.metrics.axis == Axis.vertical,
                    child: ListView.builder(
                      controller: verticalController,
                      itemCount: rows.length,
                      itemBuilder: (context, i) {
                        final u = rows[i];

                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.shade300, width: 1),
                            ),
                          ),
                          child: Row(
                            children: [
                              _cell(u.name, scale),
                              _cell("${u.leadCount}", scale),
                              _cell(
                                "₹${u.totalRevenue.toStringAsFixed(0)}",
                                scale,
                                color: Colors.green.shade700,
                              ),
                              _cell(
                                "${u.performanceScore.toStringAsFixed(0)}%",
                                scale,
                                color: _getScoreColor(u.performanceScore),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  // ----------------------------------------------------------------------
  // CELL WIDGET
  // ----------------------------------------------------------------------
  Widget _cell(String text, double Function(double) scale,
      {Color? color}) {
    return Container(
      width: 120,
      padding: EdgeInsets.symmetric(
        vertical: scale(10),
        horizontal: scale(8),
      ),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: scale(11),
          fontWeight: FontWeight.w500,
          color: color ?? Colors.black87,
        ),
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 70) return Colors.green;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }
}

