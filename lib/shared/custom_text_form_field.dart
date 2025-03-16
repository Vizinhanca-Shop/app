import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vizinhanca_shop/theme/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.inputFormatters,
    this.onChanged,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
    this.focusedBorder,
    this.enabledBorder,
    this.disabledBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.maxLength,
    this.floatingLabelBehavior = FloatingLabelBehavior.auto,
    this.hintStyle,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final bool? enabled;
  final bool readOnly;
  final void Function()? onTap;
  final int maxLines;
  final OutlineInputBorder? focusedBorder;
  final OutlineInputBorder? enabledBorder;
  final OutlineInputBorder? disabledBorder;
  final OutlineInputBorder? errorBorder;
  final OutlineInputBorder? focusedErrorBorder;
  final int? maxLength;
  final FloatingLabelBehavior floatingLabelBehavior;
  final TextStyle? hintStyle;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: AppColors.primary,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText ?? false,
      validator: validator,
      onTap: onTap,
      enabled: enabled,
      readOnly: readOnly,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: onChanged,
      style: GoogleFonts.lato(
        color: Colors.grey[800],
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        floatingLabelBehavior: floatingLabelBehavior,
        labelStyle: GoogleFonts.lato(
          color: Colors.grey[800],
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        counterText: '',
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintText: hintText,
        hintStyle:
            hintStyle ??
            GoogleFonts.lato(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
        alignLabelWithHint: true,
        errorStyle: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        focusedBorder:
            focusedBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary),
            ),
        enabledBorder:
            enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
        disabledBorder:
            disabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
        errorBorder:
            errorBorder ??
            OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10.0),
            ),
        focusedErrorBorder:
            focusedBorder ??
            OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(10.0),
            ),
        prefixIcon: prefixIcon,
        suffixIcon: enabled == true ? suffixIcon : null,
      ),
    );
  }
}
