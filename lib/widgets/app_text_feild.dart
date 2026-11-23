import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Text box used on every form, styled like the login field in the class project.
/// Set [isPassword] to get the eye button that shows or hides the text (US-003).
class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? icon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final String? helperText;
  final void Function(String)? onChanged;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.icon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.helperText,
    this.onChanged,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool hidden = true;

  OutlineInputBorder _border(Color color, [double width = 1]) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: color, width: width),
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword && hidden,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onChanged: widget.onChanged,
      autocorrect: !widget.isPassword,
      enableSuggestions: !widget.isPassword,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        helperText: widget.helperText,
        helperMaxLines: 2,
        errorMaxLines: 2,
        prefixIcon: widget.icon == null ? null : Icon(widget.icon, color: AppColors.textSecondary),
        suffixIcon: widget.isPassword
            ? IconButton(
          tooltip: hidden ? 'Show password' : 'Hide password',
          onPressed: () => setState(() => hidden = !hidden),
          icon: Icon(hidden ? Icons.visibility : Icons.visibility_off),
        )
            : null,
        filled: true,
        fillColor: AppColors.card,
        enabledBorder: _border(AppColors.border),
        focusedBorder: _border(AppColors.blue, 2),
        errorBorder: _border(AppColors.error),
        focusedErrorBorder: _border(AppColors.error, 2),
      ),
    );
  }
}