// import 'package:employee_location_tracking_app/screens/employee_dashboard/provider/employee_provider.dart';
// import 'package:employee_location_tracking_app/utils/theme/font_styles/light_font_style/light_font_style.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class StatusToggleSwitch extends ConsumerStatefulWidget {
//   const StatusToggleSwitch({super.key});

//   @override
//   ConsumerState<StatusToggleSwitch> createState() => _StatusToggleSwitchState();
// }

// class _StatusToggleSwitchState extends ConsumerState<StatusToggleSwitch>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _animation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeInOut,
//       ),
//     );

//     final employeeNotifier = ref.read(employeeProvider);
//     if (employeeNotifier.isOnline) {
//       _controller.value = 1.0;
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _handleDragUpdate(DragUpdateDetails details) {
//     final dragValue = details.primaryDelta! / 150.0;
//     _controller.value = (_controller.value + dragValue).clamp(0.0, 1.0);
//   }

//   void _handleDragEnd(DragEndDetails details) async {
//     final employeeNotifier = ref.read(employeeProvider);
//     final isCurrentlyOnline = employeeNotifier.isOnline;

//     if (_controller.value >= 0.99 && !isCurrentlyOnline) {
//       await employeeNotifier.toggleOnlineStatus();
//     } else if (_controller.value <= 0.01 && isCurrentlyOnline) {
//       await employeeNotifier.toggleOnlineStatus();
//     } else {
//       _controller.value = isCurrentlyOnline ? 1.0 : 0.0;
//     }
//   }

//   Widget _buildDirectionalIndicator({
//     required bool isOnline,
//     required int index,
//     required int totalIndicators,
//   }) {
//     double calculateOpacity() {
//       if (!isOnline) {
//         return 0.3 + (index / (totalIndicators - 1)) * 0.7;
//       }
//       return 0.3 +
//           ((totalIndicators - 1 - index) / (totalIndicators - 1)) * 0.7;
//     }

//     return Opacity(
//       opacity: calculateOpacity(),
//       child: Icon(
//         isOnline ? Icons.chevron_right : Icons.chevron_left,
//         size: 16,
//         color: isOnline ? const Color(0xFF2E7D32) : Colors.grey[400],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final employeeNotifier = ref.watch(employeeProvider);
//     final isOnline = employeeNotifier.isOnline;

//     return GestureDetector(
//       onHorizontalDragUpdate: _handleDragUpdate,
//       onHorizontalDragEnd: _handleDragEnd,
//       child: Container(
//         width: MediaQuery.sizeOf(context).width * 0.75,
//         height: 45,
//         padding: EdgeInsets.all(8.r),
//         decoration: BoxDecoration(
//           color: Theme.of(context).cardColor,
//           borderRadius: BorderRadius.circular(32.r),
//         ),
//         child: Stack(
//           children: [
//             Positioned.fill(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 10.w),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     AnimatedDefaultTextStyle(
//                       duration: const Duration(milliseconds: 200),
//                       style: TextStyle(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 14.sp,
//                         color: !isOnline ? Colors.black87 : Colors.grey[400],
//                       ),
//                       child: Text(
//                         isOnline ? 'Offline' : "",
//                         style: bodyMedium,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     Spacer(flex: isOnline ? 1 : 2),
//                     ...List.generate(
//                       6,
//                       (index) => _buildDirectionalIndicator(
//                         isOnline: !isOnline,
//                         index: index,
//                         totalIndicators: 6,
//                       ),
//                     ),
//                     Spacer(flex: isOnline ? 2 : 1),
//                     AnimatedDefaultTextStyle(
//                       duration: const Duration(milliseconds: 200),
//                       style: bodyMedium.copyWith(
//                         color: isOnline ? const Color(0xFF2E7D32) : Colors.grey[400],
//                       ),
//                       child: Text(
//                         isOnline ? "" : "Online",
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             AnimatedBuilder(
//               animation: _animation,
//               builder: (context, child) {
//                 return Align(
//                   alignment: Alignment.lerp(
//                     Alignment.centerLeft,
//                     Alignment.centerRight,
//                     _controller.value,
//                   )!,
//                   child: child,
//                 );
//               },
//               child: Container(
//                 width: 70.w,
//                 height: 45.h,
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).cardColor,
//                   borderRadius: BorderRadius.circular(32.r),
//                   boxShadow: [
//                     BoxShadow(
//                       color: const Color(0xFF161B1D).withOpacity(0.25),
//                       offset: const Offset(-2, -1),
//                     ),
//                     BoxShadow(
//                       color: Theme.of(context).scaffoldBackgroundColor,
//                       spreadRadius: 2.0,
//                       blurRadius: 7.0,
//                       offset: const Offset(2, 2),
//                     ),
//                   ],
//                 ),
//                 child: Center(
//                   child: Text(
//                     isOnline ? 'Online' : 'Offline',
//                     style: TextStyle(
//                       color: isOnline ? const Color(0xFF2E7D32) : Colors.black,
//                       fontWeight: FontWeight.w500,
//                       fontSize: 14.sp,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
