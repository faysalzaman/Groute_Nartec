import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final bool? enabled;
  final int? maxLines;
  final int? maxLength;
  final double? height;
  final double? width;
  final double? hintTextSize;
  final double? lableTextSize;
  final double? fontSize;
  final FocusNode? focusNode;
  final void Function()? onCompleted;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText = '',
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.height,
    this.width,
    this.hintTextSize,
    this.lableTextSize,
    this.fontSize,
    this.focusNode,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        enabled: enabled,
        maxLines: maxLines,
        maxLength: maxLength,
        focusNode: focusNode,
        style: TextStyle(fontSize: fontSize ?? 14),
        onEditingComplete: onCompleted,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: hintTextSize ?? 12),
          labelStyle: TextStyle(fontSize: lableTextSize ?? 12),
          labelText: labelText.isNotEmpty ? labelText : null,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon:
              suffixIcon != null
                  ? IconButton(
                    icon: Icon(suffixIcon),
                    onPressed: onSuffixIconPressed,
                  )
                  : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ), // Better padding
        ),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}
