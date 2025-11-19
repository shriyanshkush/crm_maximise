import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../../auth/services/auth_local_storage.dart';

class DashboardHeader extends StatefulWidget {
  final VoidCallback onDownload; // 👈 ADD THIS
  final VoidCallback onFilterTap;


  const DashboardHeader({
    super.key,
    required this.onDownload,
    required this.onFilterTap,
  });

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final authStorage = AuthLocalStorage();
    final user = await authStorage.getUser();
    setState(() {
      _userName = user?.name ?? 'User';
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(now);
    final greeting = _getGreeting(now.hour);

    // Responsive handling
    final width = MediaQuery.of(context).size.width;
    final isTablet = width > 600;
    final isSmall = width < 360;

    // Adaptive sizes
    final padding = EdgeInsets.all(isTablet ? 24 : 16);
    final greetingFont = isTablet ? 20.0 : (isSmall ? 14.0 : 16.0);
    final nameFont = isTablet ? 28.0 : (isSmall ? 18.0 : 22.0);
    final dateFont = isTablet ? 16.0 : (isSmall ? 12.0 : 13.0);

    return Container(
      color: const Color(0xFFF8F9FB),
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Greeting Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$greeting,',
                    style: TextStyle(
                      fontSize: greetingFont,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _userName ?? '',
                    style: TextStyle(
                      fontSize: nameFont,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: dateFont,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),

            // Action Buttons (Download + Filter)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _iconButton(
                  'assets/icons/download.svg',
                  24,
                  widget.onDownload, // 👈 CALL CALLBACK
                ),
                const SizedBox(width: 8),
                _iconButton(
                  'assets/icons/filter.svg',
                  24,
                  widget.onFilterTap,   // 👈 CALL THE FILTER ACTION
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButton(String svgPath, double size, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: SvgPicture.asset(
          svgPath,
          width: size,
          height: size,
          colorFilter: const ColorFilter.mode(
            Color(0xFF3B82F6),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  String _getGreeting(int hour) {
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}
