import 'package:employee_location_tracking_app/common/widgets/app_text_field.dart';
import 'package:employee_location_tracking_app/utils/theme/font_styles/light_font_style/light_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LabeledTextField extends StatelessWidget {
  final String label;
  final TextStyle? labelStyle;
  final TextEditingController? controller;
  final String hintText;
  final bool isPassword;
  final bool isPasswordVisible;
  final VoidCallback? onTogglePassword;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? maxLength;
  final Widget? prefix;
  final Widget? suffix;
  final bool readOnly;
  final VoidCallback? onTap;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final bool? enabled;
  final String? errorText;
  final TextCapitalization textCapitalization;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final bool autofocus;

  const LabeledTextField({
    Key? key,
    required this.label,
    this.labelStyle,
    this.controller,
    required this.hintText,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.onTogglePassword,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.maxLength,
    this.prefix,
    this.suffix,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.focusNode,
    this.enabled,
    this.errorText,
    this.textCapitalization = TextCapitalization.none,
    this.contentPadding,
    this.textStyle,
    this.hintStyle,
    this.fillColor,
    this.autofocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: (labelStyle ?? bodySmall).copyWith(
            color: theme.hintColor,
          ),
        ),
        SizedBox(height: 8.h),
        AppTextField(
          controller: controller,
          hintText: hintText,
          isPassword: isPassword,
          isPasswordVisible: isPasswordVisible,
          onTogglePassword: onTogglePassword,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          maxLength: maxLength,
          prefix: prefix,
          suffix: suffix,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          focusNode: focusNode,
          enabled: enabled,
          errorText: errorText,
          textCapitalization: textCapitalization,
          contentPadding: contentPadding,
          textStyle: textStyle,
          hintStyle: hintStyle,
          fillColor: fillColor,
          autofocus: autofocus,
        ),
      ],
    );
  }
}
