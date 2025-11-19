import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../models/integrations_status_model.dart';

class ChannelReportCard extends StatelessWidget {
  final IntegrationsStatusResponse data;

  const ChannelReportCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double scale(double v) => width > 600 ? v * 1.2 : v;

    return Card(
      elevation: 0.4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(scale(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F0FE),
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(scale(4)),
                    child: SvgPicture.asset(
                      'assets/icons/settings-svgrepo-com.svg',
                      width: scale(20),
                      height: scale(20),
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF3B82F6),
                        BlendMode.srcIn,
                      ),
                    )

                ),
                SizedBox(width: 10),
                Text(
                  "Channel Report",
                  style: TextStyle(
                    fontSize: scale(16),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            SizedBox(height: scale(16)),

            // Column Headers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "PLATFORM",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "STATUS",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            SizedBox(height: scale(6)),
            Divider(),

            // Integration List
            Column(
              children: data.integrations.map((item) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: scale(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.platform,
                        style: TextStyle(
                          fontSize: scale(14),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      _statusBadge(item.isActive, item.status),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Status Badge
  Widget _statusBadge(bool isActive, String apiStatus) {
    String label;
    Color bg;
    Color text;

    if (isActive) {
      label = "Active";
      bg = Colors.green.shade100;
      text = Colors.green.shade700;
    } else {
      // API returns: not_configured / disconnected / connected
      if (apiStatus == "not_configured") {
        label = "Not Configured";
        bg = Colors.yellow.shade100;
        text = Colors.orange.shade700;
      } else {
        label = "Disconnected";
        bg = Colors.red.shade100;
        text = Colors.red.shade700;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
