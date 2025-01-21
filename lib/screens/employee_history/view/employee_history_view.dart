import 'package:employee_location_tracking_app/common/widgets/app_bar/app_bar_widget.dart';
import 'package:employee_location_tracking_app/screens/admin_dashboard/widgets/list_row_widget.dart';
import 'package:employee_location_tracking_app/screens/employee_history/provider/employee_history_provider.dart';
import 'package:employee_location_tracking_app/utils/theme/font_styles/light_font_style/light_font_style.dart';
import 'package:employee_location_tracking_app/utils/theme/light_base_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class EmployeeHistoryView extends ConsumerStatefulWidget {
  final String userId;
  final String employeeName;
  const EmployeeHistoryView(
      {Key? key, required this.userId, required this.employeeName})
      : super(key: key);

  @override
  ConsumerState<EmployeeHistoryView> createState() =>
      _EmployeeHistoryViewState();
}

class _EmployeeHistoryViewState extends ConsumerState<EmployeeHistoryView> {
  final employeeHistoryProvider = ChangeNotifierProvider(
    (ref) => EmployeeHistoryProvider(),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(employeeHistoryProvider).loadHistories(userId: widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(employeeHistoryProvider);
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: CustomAppBar(
        color: Colors.white,
        userName: widget.employeeName,
        showBackIcon: true,
        // scaffoldKey: _scaffoldKey,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          color: theme.scaffoldBackgroundColor,
          boxShadow: [
            // BoxShadow(
            //   color: const Color(0xFF161B1D).withOpacity(0.25),
            //   offset: const Offset(-2, -1),
            // ),
            BoxShadow(
              color: Color(0xffACA8A84).withOpacity(0.25),
              // spreadRadius: 2.0,
              blurRadius: 15,
              offset: const Offset(0, -15),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Row(
                children: [
                  SvgPicture.asset('assets/images/timeline_icon.svg'),
                  12.horizontalSpace,
                  Text('Timeline',
                      style: bodyLarge.copyWith(fontWeight: FontWeight.w500)),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.calendar_month,
                      size: 24.sp,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      _selectDate(notifier: notifier);
                    },
                  ),
                ],
              ),
            ),
            Container(
              color: dividerColor,
              height: 1.h,
            ),
            14.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(notifier.targetDate,
                  style: bodyLarge.copyWith(
                      fontWeight: FontWeight.w600, color: Colors.black)),
            ),
            3.verticalSpace,
            Expanded(
              child: (notifier.filterLocationsByDate.isEmpty)
                  ? Center(
                      child: Text(
                      'No history found',
                      style: bodyLarge.copyWith(fontWeight: FontWeight.w600),
                    ))
                  : ListView.separated(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24.w, vertical: 24),
                      itemCount: notifier.filterLocationsByDate.length,
                      itemBuilder: (context, index) {
                        final location = notifier.filterLocationsByDate[index];
                        return Row(
                          children: [
                            Container(
                              // color: Colors.red,
                              width: 55,
                              child: Text(
                                  notifier
                                      .formatDateTimeToTime(location.timestamp),
                                  style: headingSmall.copyWith(fontSize: 11)),
                            ),
                            5.horizontalSpace,
                            Container(
                              height: 11,
                              width: 11,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: onlineGreenColor,
                              ),
                            ),
                            9.horizontalSpace,
                            Container(
                              // color: Colors.red,
                              width: 230,
                              child: Text(
                                location.address ?? 'No address available',
                                style: headingSmall.copyWith(fontSize: 12),
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            73.horizontalSpace,
                            Container(
                              width: 2,
                              height: 33.h,
                              color: Color(0xffACACAC),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate({required EmployeeHistoryProvider notifier}) async {
    // Get the current date
    final DateTime now = DateTime.now();

    // Calculate the range: 1 month before and today
    final DateTime firstDate = DateTime(now.year, now.month - 1, now.day);
    final DateTime lastDate = now;

    // Show the date picker with a custom theme
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now, // Start at today
      firstDate: firstDate, // 1 month ago
      lastDate: lastDate, // Today
      helpText: 'Select a date', // Optional title for the picker
      builder: (BuildContext context, Widget? child) {
        // Apply the theme
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary:
                  Theme.of(context).primaryColor, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    Theme.of(context).primaryColor, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      // Format the date as YYYY-MM-DD
      var selectedDate = pickedDate.toIso8601String().split('T')[0];
      notifier.filterLocations(selectedDate: selectedDate);
      // setState(() {
      print('selected date is $pickedDate');
      // });
    }
  }
}
