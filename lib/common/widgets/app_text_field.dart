import 'package:employee_location_tracking_app/utils/theme/font_styles/light_font_style/light_font_style.dart';
import 'package:employee_location_tracking_app/utils/theme/light_base_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool isPassword;
  bool isPasswordVisible;
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

  AppTextField({
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
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword && !widget.isPasswordVisible,
      style: widget.textStyle ?? bodyMedium,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      textCapitalization: widget.textCapitalization,
      autofocus: widget.autofocus,
      decoration: AppInputDecoration.getInputDecoration(
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        errorText: widget.errorText,
        fillColor: widget.fillColor,
        contentPadding: widget.contentPadding,
        prefix: widget.prefix,
        suffix: widget.isPassword
            ? IconButton(
                icon: Icon(
                  widget.isPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: theme.hintColor,
                ),
                onPressed: () {
                  setState(() {
                    widget.isPasswordVisible = !widget.isPasswordVisible;
                  });
                },
              )
            : widget.suffix,
      ),
    );
  }
}

class AppInputDecoration {
  static InputDecoration getInputDecoration({
    required String hintText,
    TextStyle? hintStyle,
    String? errorText,
    Color? fillColor,
    EdgeInsetsGeometry? contentPadding,
    Widget? prefix,
    Widget? suffix,
  }) {
    final theme = ThemeData();

    return InputDecoration(
      hintText: hintText,
      hintStyle: (hintStyle ?? bodyMedium).copyWith(
        color: theme.hintColor.withOpacity(0.5),
      ),
      errorText: errorText,
      filled: true,
      fillColor: fillColor ?? whiteColor,
      contentPadding: contentPadding ??
          EdgeInsets.symmetric(
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
      suffixIcon: suffix,
    );
  }
}

// import 'package:employee_location_tracking_app/utils/theme/font_styles/light_font_style/light_font_style.dart';
// import 'package:employee_location_tracking_app/utils/theme/light_base_theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class AppTextField extends StatefulWidget {
//   final TextEditingController? controller;
//   final String hintText;
//   final bool isPassword;
//    bool isPasswordVisible;
//   final VoidCallback? onTogglePassword;
//   final String? Function(String?)? validator;
//   final TextInputType? keyboardType;
//   final List<TextInputFormatter>? inputFormatters;
//   final int? maxLines;
//   final int? maxLength;
//   final Widget? prefix;
//   final Widget? suffix;
//   final bool readOnly;
//   final VoidCallback? onTap;
//   final void Function(String)? onChanged;
//   final FocusNode? focusNode;
//   final bool? enabled;
//   final String? errorText;
//   final TextCapitalization textCapitalization;
//   final EdgeInsetsGeometry? contentPadding;
//   final TextStyle? textStyle;
//   final TextStyle? hintStyle;
//   final Color? fillColor;
//   final bool autofocus;

//    AppTextField({
//     Key? key,
//     this.controller,
//     required this.hintText,
//     this.isPassword = false,
//     this.isPasswordVisible = false,
//     this.onTogglePassword,
//     this.validator,
//     this.keyboardType,
//     this.inputFormatters,
//     this.maxLines = 1,
//     this.maxLength,
//     this.prefix,
//     this.suffix,
//     this.readOnly = false,
//     this.onTap,
//     this.onChanged,
//     this.focusNode,
//     this.enabled,
//     this.errorText,
//     this.textCapitalization = TextCapitalization.none,
//     this.contentPadding,
//     this.textStyle,
//     this.hintStyle,
//     this.fillColor,
//     this.autofocus = false,
//   }) : super(key: key);

//   @override
//   State<AppTextField> createState() => _AppTextFieldState();
// }

// class _AppTextFieldState extends State<AppTextField> {
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return TextFormField(
//       controller: widget.controller,
//       obscureText: widget.isPassword && !widget.isPasswordVisible,
//       style: widget.textStyle ?? bodyMedium,
//       validator: widget.validator,
//       keyboardType: widget.keyboardType,
//       inputFormatters: widget.inputFormatters,
//       maxLines: widget.maxLines,
//       maxLength: widget.maxLength,
//       readOnly: widget.readOnly,
//       onTap: widget.onTap,
//       onChanged: widget.onChanged,
//       focusNode: widget.focusNode,
//       enabled: widget.enabled,
//       textCapitalization: widget.textCapitalization,
//       autofocus: widget.autofocus,
//       decoration: InputDecoration(
//         hintText: widget.hintText,
//         hintStyle: (widget.hintStyle ?? bodyMedium).copyWith(
//           color: theme.hintColor.withOpacity(0.5),
//         ),
//         errorText: widget.errorText,
//         filled: true,
//         fillColor: widget.fillColor ?? whiteColor,
//         contentPadding: widget.contentPadding ??
//             EdgeInsets.symmetric(
//               horizontal: 16.w,
//               vertical: 16.h,
//             ),
//         isDense: true,
//         prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
//         prefixIcon: widget.prefix,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.r),
//           borderSide: BorderSide.none,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.r),
//           borderSide: BorderSide.none,
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.r),
//           borderSide: BorderSide(
//             color: theme.primaryColor,
//             width: 1.w,
//           ),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.r),
//           borderSide: BorderSide(
//             color: theme.colorScheme.error,
//             width: 1.w,
//           ),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.r),
//           borderSide: BorderSide(
//             color: theme.colorScheme.error,
//             width: 1.w,
//           ),
//         ),
//         suffixIcon: widget.isPassword
//             ? IconButton(
//                 icon: Icon(
//                   widget.isPasswordVisible
//                       ? Icons.visibility_outlined
//                       : Icons.visibility_off_outlined,
//                   color: theme.hintColor,
//                 ),
//                 onPressed:() {
//                   setState(() {
//                     widget.isPasswordVisible = !widget.isPasswordVisible;
//                   });
//                 },
//               )
//             : widget.suffix,
//       ),
//     );
//   }
// }
