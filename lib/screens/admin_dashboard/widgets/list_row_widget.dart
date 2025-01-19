import 'package:employee_location_tracking_app/utils/theme/font_styles/light_font_style/light_font_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class ListRowWidget extends ConsumerWidget {
  final String titie;
  final String body;
  const ListRowWidget({Key? key, required this.titie, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Text(
          '$titie: ',
          style: bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          body,
          style: bodyMedium,
        ),
      ],
    );
  }
}
