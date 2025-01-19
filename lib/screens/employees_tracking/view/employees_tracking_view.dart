import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class EmployeesTrackingView extends ConsumerStatefulWidget {
  const EmployeesTrackingView({Key? key}) : super(key: key);

  @override
  ConsumerState<EmployeesTrackingView> createState() => _EmployeesTrackingViewState();
}

class _EmployeesTrackingViewState extends ConsumerState<EmployeesTrackingView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Comming Soon'),
      ),
    );
  }
}