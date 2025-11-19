// import 'package:flutter/material.dart';
// import '../../dashboard/presentation/pages/dashboard_page.dart';
// import '../../leads/presentation/pages/leads_page.dart';
// import '../../teams/presentation/pages/teams_page.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;
//
//   final List<Widget?> _pages = [null, null, null];
//
//   Widget _buildPage(int index) {
//     if (_pages[index] != null) return _pages[index]!;
//     switch (index) {
//       case 0:
//         _pages[index] = const DashboardPage();
//         break;
//       case 1:
//         _pages[index] = const LeadsPage();
//         break;
//       case 2:
//         _pages[index] = const TeamsPage();
//         break;
//     }
//     return _pages[index]!;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: IndexedStack(
//           index: _selectedIndex,
//           children: List.generate(3, (i) => _buildPage(i)),
//         ),
//       ),
//       bottomNavigationBar: NavigationBar(
//         selectedIndex: _selectedIndex,
//         onDestinationSelected: (index) {
//           setState(() => _selectedIndex = index);
//         },
//         destinations: const [
//           NavigationDestination(
//             icon: Icon(Icons.dashboard_outlined),
//             selectedIcon: Icon(Icons.dashboard),
//             label: 'Dashboard',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.people_outline),
//             selectedIcon: Icon(Icons.people),
//             label: 'Leads',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.group_outlined),
//             selectedIcon: Icon(Icons.group),
//             label: 'Teams',
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:crm_maximise/features/ai/presentation/pages/aihome.dart';
// import 'package:flutter/material.dart';
// import '../../dashboard/presentation/pages/dashboard_page.dart';
// import '../../leads/presentation/pages/leads_page.dart';
// import '../../teams/presentation/pages/teams_page.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;
//
//   final List<Widget?> _pages = [null, null, null, null];
//
//   @override
//   void initState() {
//     super.initState();
//     // Load only the first page on startup
//     _pages[0] = const DashboardPage();
//
//     // Smart preload: quietly load the next tab after 2s
//     Future.delayed(const Duration(seconds: 2), () {
//       if (mounted && _pages[1] == null) {
//         _pages[1] = const LeadsPage();
//       }
//     });
//   }
//
//   Widget _buildPage(int index) {
//     if (_pages[index] != null) return _pages[index]!;
//     switch (index) {
//       case 0:
//         _pages[index] = const DashboardPage();
//         break;
//       case 1:
//         _pages[index] = const LeadsPage();
//         break;
//       case 2:
//         _pages[index] = const TeamsPage();
//         break;
//       case 3:
//         _pages[index] = const Aihome();
//         break;
//     }
//     return _pages[index]!;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: IndexedStack(
//           index: _selectedIndex,
//           children: List.generate(4, (i) => _buildPage(i)),
//         ),
//       ),
//       extendBody: true,
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//         child: Row(
//           children: [
//             // Main navigation bar with 3 items
//             Expanded(
//               child: Container(
//                 height: 75,
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.95),
//                   borderRadius: BorderRadius.circular(40),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.15),
//                       blurRadius: 30,
//                       offset: const Offset(0, 10),
//                       spreadRadius: 5,
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     _buildNavItem(
//                       icon: Icons.dashboard_outlined,
//                       activeIcon: Icons.dashboard,
//                       label: 'Dashboard',
//                       index: 0,
//                     ),
//                     _buildNavItem(
//                       icon: Icons.people_outline,
//                       activeIcon: Icons.people,
//                       label: 'Leads',
//                       index: 1,
//                     ),
//                     _buildNavItem(
//                       icon: Icons.group_outlined,
//                       activeIcon: Icons.group,
//                       label: 'Teams',
//                       index: 2,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             // Separate AI button
//             GestureDetector(
//               onTap: () {
//                 setState(() => _selectedIndex = 3);
//               },
//               child: Container(
//                 width: 75,
//                 height: 75,
//                 decoration: BoxDecoration(
//                   color: _selectedIndex == 3
//                       ? const Color(0xFFD84315)
//                       : Colors.white.withOpacity(0.95),
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.15),
//                       blurRadius: 30,
//                       offset: const Offset(0, 10),
//                       spreadRadius: 5,
//                     ),
//                   ],
//                 ),
//                 child: Stack(
//                   clipBehavior: Clip.none,
//                   alignment: Alignment.center,
//                   children: [
//                     Icon(
//                       _selectedIndex == 3
//                           ? Icons.psychology
//                           : Icons.psychology_outlined,
//                       color: _selectedIndex == 3 ? Colors.white : Colors.grey,
//                       size: 28,
//                     ),
//                     Positioned(
//                       right: 8,
//                       top: 8,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 4,
//                           vertical: 2,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.red,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: const Text(
//                           'New',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 8,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNavItem({
//     required IconData icon,
//     required IconData activeIcon,
//     required String label,
//     required int index,
//   }) {
//     final isSelected = _selectedIndex == index;
//     return InkWell(
//       onTap: () {
//         setState(() => _selectedIndex = index);
//       },
//       borderRadius: BorderRadius.circular(15),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               isSelected ? activeIcon : icon,
//               color: isSelected ? const Color(0xFFD84315) : Colors.grey,
//               size: 28,
//             ),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: TextStyle(
//                 color: isSelected ? const Color(0xFFD84315) : Colors.grey,
//                 fontSize: isSelected ? 13 : 12,
//                 fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../auth/domain/entities/user_entity.dart';
import '../../dashboard/presentation/pages/dashboard_page.dart';
import '../../leads/presentation/pages/leads_page.dart';
import '../../search/presentation/pages/searchpage.dart';
import '../../teams/presentation/pages/teams_page.dart';
import '../../ai/presentation/pages/aihome.dart';

// class HomePage extends StatefulWidget {
//   final UserEntity user;
//   const HomePage({super.key, required this.user});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;
//   final List<Widget?> _pages = [null, null, null, null];
//
//   @override
//   void initState() {
//     super.initState();
//     _pages[0] = DashboardPage(orgId: widget.user.id);
//   }
//
//   Widget _buildPage(int index) {
//     if (_pages[index] != null) return _pages[index]!;
//     switch (index) {
//       case 0:
//         _pages[index] = DashboardPage(orgId: widget.user.id);
//         break;
//       case 1:
//         _pages[index] = const LeadsPage();
//         break;
//       case 2:
//         _pages[index] = const TeamsPage();
//         break;
//       case 3:
//         _pages[index] = const Aihome();
//         break;
//     }
//     return _pages[index]!;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true,
//       backgroundColor: Colors.grey[50],
//       body: Stack(
//         children: [
//           // 🔹 Main Page Content
//           IndexedStack(
//             index: _selectedIndex,
//             children: List.generate(
//               4,
//                   (i) => _pages[i] ?? (_selectedIndex == i ? _buildPage(i) : const SizedBox()),
//             ),
//           ),
//
//           // 🔹 Floating Bottom Bar
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: 0,
//             child: SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 child: Row(
//                   children: [
//                     // 🔹 Separate AI button
//                     GestureDetector(
//                       onTap: () {
//                         setState(() => _selectedIndex = 3);
//                       },
//                       child: Container(
//                         width: 75,
//                         height: 75,
//                         decoration: BoxDecoration(
//                           color: _selectedIndex == 3
//                               ? const Color(0xFFD84315)
//                               : Colors.white.withOpacity(0.95),
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.15),
//                               blurRadius: 30,
//                               offset: const Offset(0, 10),
//                               spreadRadius: 5,
//                             ),
//                           ],
//                         ),
//                         child: Stack(
//                           clipBehavior: Clip.none,
//                           alignment: Alignment.center,
//                           children: [
//                             Icon(
//                               _selectedIndex == 3
//                                   ? Icons.psychology
//                                   : Icons.psychology_outlined,
//                               color: _selectedIndex == 3 ? Colors.white : Colors.grey,
//                               size: 28,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     // Main navigation bar with 3 items
//                     Expanded(
//                       child: Container(
//                         height: 75,
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.95),
//                           borderRadius: BorderRadius.circular(40),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.15),
//                               blurRadius: 30,
//                               offset: const Offset(0, 10),
//                               spreadRadius: 5,
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             _buildNavItem(
//                               icon: Icons.dashboard_outlined,
//                               activeIcon: Icons.dashboard,
//                               label: 'Dashboard',
//                               index: 0,
//                             ),
//                             _buildNavItem(
//                               icon: Icons.people_outline,
//                               activeIcon: Icons.people,
//                               label: 'Leads',
//                               index: 1,
//                             ),
//                             _buildNavItem(
//                               icon: Icons.group_outlined,
//                               activeIcon: Icons.group,
//                               label: 'Teams',
//                               index: 2,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(width: 12),
//
//                     // 🔹 Separate AI button
//                     GestureDetector(
//                       onTap: () {
//                         setState(() => _selectedIndex = 3);
//                       },
//                       child: Container(
//                         width: 75,
//                         height: 75,
//                         decoration: BoxDecoration(
//                           color: _selectedIndex == 3
//                               ? const Color(0xFFD84315)
//                               : Colors.white.withOpacity(0.95),
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.15),
//                               blurRadius: 30,
//                               offset: const Offset(0, 10),
//                               spreadRadius: 5,
//                             ),
//                           ],
//                         ),
//                         child: Stack(
//                           clipBehavior: Clip.none,
//                           alignment: Alignment.center,
//                           children: [
//                             Icon(
//                               _selectedIndex == 3
//                                   ? Icons.psychology
//                                   : Icons.psychology_outlined,
//                               color: _selectedIndex == 3 ? Colors.white : Colors.grey,
//                               size: 28,
//                             ),
//                             Positioned(
//                               right: 8,
//                               top: 8,
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 4,
//                                   vertical: 2,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.red,
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: const Text(
//                                   'New',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 8,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildNavItem({
//     required IconData icon,
//     required IconData activeIcon,
//     required String label,
//     required int index,
//   }) {
//     final isSelected = _selectedIndex == index;
//     return InkWell(
//       onTap: () {
//         setState(() => _selectedIndex = index);
//       },
//       borderRadius: BorderRadius.circular(15),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               isSelected ? activeIcon : icon,
//               color: isSelected ? const Color(0xFFD84315) : Colors.grey,
//               size: 28,
//             ),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: TextStyle(
//                 color: isSelected ? const Color(0xFFD84315) : Colors.grey,
//                 fontSize: isSelected ? 13 : 12,
//                 fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../auth/domain/entities/user_entity.dart';
import '../../dashboard/presentation/pages/dashboard_page.dart';
import '../../leads/presentation/pages/leads_page.dart';
import '../../teams/presentation/pages/teams_page.dart';
import '../../ai/presentation/pages/aihome.dart';
import '../../search/presentation/pages/searchpage.dart';

class HomePage extends StatefulWidget {
  final UserEntity user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late PageController _pageController;

  // Lazy loading flags
  final Set<int> _loadedPages = {0}; // Dashboard loads first

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
      _loadedPages.add(index); // Mark page as loaded
    });
  }

  void _onNavItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildPage(int index) {
    // Only build the page if it's been loaded
    if (!_loadedPages.contains(index)) {
      return const SizedBox.shrink();
    }

    switch (index) {
      case 0:
        return DashboardPage(orgId: widget.user.id);
      case 1:
        return const LeadsPage();
      case 2:
        return const TeamsPage();
      case 3:
        return const TeamsPage();
      case 4:
        return const Searchpage();
      case 5:
        return const Aihome();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          // Main content
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: 5,
            itemBuilder: (context, index) => _buildPage(index),
          ),

          // Floating bottom navigation bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 8,
            child: _buildFloatingBottomBar(context),
          ),
        ],
      ),
    );
  }

  // Widget _buildFloatingBottomBar(BuildContext context) {
  //   final screenWidth = MediaQuery.of(context).size.width;
  //   final screenHeight = MediaQuery.of(context).size.height;
  //
  //   // Responsive sizing
  //   final isSmallScreen = screenWidth < 360;
  //   final isMediumScreen = screenWidth >= 360 && screenWidth < 400;
  //   final barHeight = isSmallScreen ? 60.0 : (isMediumScreen ? 65.0 : 68.0);
  //   final aiButtonSize = isSmallScreen ? 56.0 : (isMediumScreen ? 60.0 : 64.0);
  //   final iconSize = isSmallScreen ? 22.0 : 24.0;
  //   final labelSize = isSmallScreen ? 10.0 : 11.0;
  //   final spacing = isSmallScreen ? 8.0 : 10.0;
  //
  //   return SafeArea(
  //     child: Padding(
  //       padding: EdgeInsets.fromLTRB(
  //         screenWidth * 0.04,
  //         0,
  //         screenWidth * 0.04,
  //         screenHeight < 700 ? 8 : 12,
  //       ),
  //       child: Row(
  //         children: [
  //           // Search button (left side)
  //           _buildCircleButton(
  //             index: 4,
  //             icon: Icons.search,
  //             activeIcon: Icons.search,
  //             size: aiButtonSize,
  //             iconSize: iconSize,
  //           ),
  //
  //           SizedBox(width: spacing),
  //
  //           // Main navigation bar with 3 items
  //           Expanded(
  //             child: Container(
  //               height: barHeight,
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(barHeight / 2),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.black.withOpacity(0.1),
  //                     blurRadius: 15,
  //                     offset: const Offset(0, 4),
  //                   ),
  //                 ],
  //               ),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                 children: [
  //                   _buildCompactNavItem(
  //                     icon: Icons.home_filled,
  //                     activeIcon: Icons.home_filled,
  //                     label: 'Home',
  //                     index: 0,
  //                     iconSize: iconSize,
  //                     labelSize: labelSize,
  //                   ),
  //                   _buildCompactNavItem(
  //                     icon: Icons.people_outline,
  //                     activeIcon: Icons.people,
  //                     label: 'Leads',
  //                     index: 1,
  //                     iconSize: iconSize,
  //                     labelSize: labelSize,
  //                   ),
  //                   _buildCompactNavItem(
  //                     icon: Icons.menu_outlined,
  //                     activeIcon: Icons.menu,
  //                     label: 'Menu',
  //                     index: 2,
  //                     iconSize: iconSize,
  //                     labelSize: labelSize,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //
  //           SizedBox(width: spacing),
  //
  //           // AI button (right side)
  //           _buildCircleButton(
  //             index: 3,
  //             icon: Icons.psychology_outlined,
  //             activeIcon: Icons.psychology,
  //             size: aiButtonSize,
  //             iconSize: iconSize,
  //             isSmallScreen: isSmallScreen,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget _buildFloatingBottomBar(BuildContext context) {
    final double barHeight = 54;
    final double pillPadding = 10;    // pill inner padding
    final double iconSize = 24;
    final double circleSize = 52;     // search & AI button size

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LEFT SEARCH CIRCLE BUTTON
          _circleButton(
            index: 5,
            iconSvg: 'assets/icons/whatsapp-fill-svgrepo-com.svg',
            activeIconSvg: 'assets/icons/whatsapp-fill-svgrepo-com.svg',
            size: 60,
            iconSize: 26,
          ),

          const SizedBox(width: 12),

            // CENTER PILL NAVIGATION
            Container(
              height: barHeight,
              padding: EdgeInsets.symmetric(
                horizontal: pillPadding,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min, // VERY IMPORTANT
                children: [
                  _pillNavItem(Icons.home_filled, Icons.home_filled, 0, iconSize),
                  const SizedBox(width: 12), // small gap like Shopify
                  _pillNavItem(Icons.folder_copy_outlined, Icons.folder_copy, 1, iconSize),
                  const SizedBox(width: 12),
                  _pillNavItem(Icons.people_outline, Icons.people, 2, iconSize),
                  const SizedBox(width: 12),
                  _pillNavItem(Icons.menu_outlined, Icons.menu, 3, iconSize),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // RIGHT AI BUTTON
            _circleButton(
              index: 5,
              iconSvg: 'assets/icons/robot.svg',
              activeIconSvg: 'assets/icons/robot.svg',
              size: 60,
              iconSize: 26,
            ),
        ],
        ),
      ),
    );
  }



  Widget _circleButton({
    required int index,
    required String iconSvg,        // inactive SVG path
    required String activeIconSvg,  // active SVG path
    required double size,
    required double iconSize,
  }) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onNavItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              isSelected ? activeIconSvg : iconSvg,
              width: iconSize,
              height: iconSize,
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.black : Colors.grey.shade600,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }



  // Widget _buildCompactNavItem({
  //   required IconData icon,
  //   required IconData activeIcon,
  //   required String label,
  //   required int index,
  //   required double iconSize,
  //   required double labelSize,
  // }) {
  //   final isSelected = _selectedIndex == index;
  //
  //   return Expanded(
  //     child: InkWell(
  //       onTap: () => _onNavItemTapped(index),
  //       borderRadius: BorderRadius.circular(20),
  //       child: Container(
  //         padding: const EdgeInsets.symmetric(vertical: 6),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             AnimatedSwitcher(
  //               duration: const Duration(milliseconds: 200),
  //               transitionBuilder: (child, animation) => ScaleTransition(
  //                 scale: animation,
  //                 child: child,
  //               ),
  //               child: Icon(
  //                 isSelected ? activeIcon : icon,
  //                 key: ValueKey(isSelected),
  //                 color: isSelected ? const Color(0xFF0B0A0A) : Colors.grey[600],
  //                 size: iconSize,
  //               ),
  //
  //             ),
  //             // const SizedBox(height: 3),
  //             // Text(
  //             //   label,
  //             //   style: TextStyle(
  //             //     color: isSelected ? const Color(0xFF0B0A0A) : Colors.grey[600],
  //             //     fontSize: labelSize,
  //             //     fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
  //             //   ),
  //             // ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _pillNavItem(
      IconData icon,
      IconData activeIcon,
      int index,
      double iconSize,
      ) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onNavItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.shade200 : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isSelected ? activeIcon : icon,
          size: iconSize,
          color: isSelected ? Colors.black : Colors.grey[600],
        ),
      ),
    );
  }



}