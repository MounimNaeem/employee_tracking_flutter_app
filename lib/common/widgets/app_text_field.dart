import 'package:employee_location_tracking_app/utils/theme/font_styles/light_font_style/light_font_style.dart';
import 'package:employee_location_tracking_app/utils/theme/light_base_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatelessWidget {
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

  const AppTextField({
    Key? key,
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

    return TextFormField(
      controller: controller,
      obscureText: isPassword && !isPasswordVisible,
      style: textStyle ?? bodyMedium,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      maxLength: maxLength,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      focusNode: focusNode,
      enabled: enabled,
      textCapitalization: textCapitalization,
      autofocus: autofocus,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: (hintStyle ?? bodyMedium).copyWith(
          color: theme.hintColor.withOpacity(0.5),
        ),
        errorText: errorText,
        filled: true,
        fillColor: fillColor ?? whiteColor,
        contentPadding: contentPadding ?? EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        isDense: true,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        prefixIcon: prefix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: theme.primaryColor,
            width: 1.w,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: theme.colorScheme.error,
            width: 1.w,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: theme.colorScheme.error,
            width: 1.w,
          ),
        ),
        suffixIcon: isPassword 
            ? IconButton(
                icon: Icon(
                  isPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: theme.hintColor,
                ),
                onPressed: onTogglePassword,
              )
            : suffix,
      ),
    );
  }
}
