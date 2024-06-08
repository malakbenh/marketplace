import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../tools.dart';

class CustomTextFormFieldChat extends StatelessWidget {
  const CustomTextFormFieldChat({
    super.key,
    this.label,
    this.hintText,
    this.errorText,
    this.errorColor,
    this.initialValue,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.readOnly = false,
    this.enabled = true,
    this.border,
    this.fillColor,
    this.prefixColor,
    this.focusNode,
    this.maxLength,
    this.keyboardType,
    this.maxLines = 1,
    this.obscureText = false,
    this.autofocus = false,
    this.contentPadding,
    this.margin,
    this.isHeightFixed = true,
    this.textCapitalization,
    this.validator,
    this.prefixOnTap,
    this.suffixOnTap,
    this.onChanged,
    this.onEditingComplete,
    this.textInputAction,
    this.onSaved,
    this.inputFormatters,
    this.colorBorderOnFocus = true,
  }) : assert(
          ((prefixOnTap == null || prefixIcon != null) &&
              (suffixOnTap == null || suffixIcon != null)),
        );

  final String? label;
  final String? hintText;
  final String? errorText;
  final Color? errorColor;
  final String? initialValue;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final void Function()? onTap;
  final bool readOnly;
  final bool enabled;
  final InputBorder? border;
  final Color? fillColor;
  final Color? prefixColor;
  final FocusNode? focusNode;
  final bool isHeightFixed;
  final int? maxLength;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool obscureText;
  final bool autofocus;
  final bool colorBorderOnFocus;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? margin;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final String? Function(String?)? validator;
  final void Function()? prefixOnTap;
  final void Function()? suffixOnTap;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function(String?)? onSaved;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    InputBorder outlineInputBorder = border ??
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.sp),
          borderSide: BorderSide(
            color: fillColor ?? context.b3,
          ),
        );
    Widget textFormField = TextFormField(
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      autofocus: autofocus,
      initialValue: initialValue,
      controller: controller,
      style: context.h5b1,
      onTap: onTap,
      readOnly: readOnly,
      enabled: enabled,
      onChanged: onChanged,
      focusNode: focusNode,
      validator: validator,
      maxLength: maxLength,
      textCapitalization: textCapitalization ??
          ([TextInputType.emailAddress, TextInputType.visiblePassword]
                  .contains(keyboardType)
              ? TextCapitalization.none
              : TextCapitalization.sentences),
      keyboardType: keyboardType,
      maxLines: maxLines,
      textInputAction: textInputAction,
      onEditingComplete: onEditingComplete,
      onSaved: onSaved,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        fillColor: fillColor,
        filled: fillColor != null,
        constraints: keyboardType != TextInputType.multiline
            ? BoxConstraints(
                minHeight: 50.sp,
                maxHeight: 50.sp,
              )
            : BoxConstraints(
                minHeight: 50.sp,
              ),
        alignLabelWithHint: false,
        label: label != null
            ? Text(
                label!,
                style: context.h3b1,
              )
            : null,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: hintText,
        errorText: errorText,
        errorStyle: !isHeightFixed
            ? Styles.poppins(
                fontSize: 0,
                height: 0.3,
                color: errorColor,
              )
            : Styles.poppins(
                fontSize: 12.sp,
                height: 0.6,
                color: errorColor,
              ),
        hintStyle: context.h5b4,
        contentPadding: prefixIcon == null
            ? EdgeInsets.symmetric(
                horizontal: 14.sp,
                vertical: 14.sp,
              )
            : EdgeInsets.symmetric(
                horizontal: 8.sp,
                vertical: 0,
              ),
        border: outlineInputBorder,
        focusedBorder: colorBorderOnFocus
            ? outlineInputBorder.copyWith(
                borderSide: BorderSide(
                  color: context.primary,
                  width: 2.sp,
                ),
              )
            : outlineInputBorder,
        enabledBorder: outlineInputBorder,
        errorBorder: outlineInputBorder.copyWith(
          borderSide: BorderSide(
            color: errorColor ?? Styles.red,
          ),
        ),
        disabledBorder: outlineInputBorder.copyWith(
          borderSide: BorderSide(
            color: context.b3,
          ),
        ),
        suffixIcon: suffixIcon != null
            ? InkResponse(
                onTap: suffixOnTap,
                child: Padding(
                  padding: EdgeInsets.all(12.sp),
                  child: Icon(
                    suffixIcon,
                    size: 18.sp,
                    color: prefixColor ?? context.b2,
                  ),
                ),
              )
            : null,
        prefixIcon: prefixIcon != null
            ? InkResponse(
                onTap: prefixOnTap,
                child: Padding(
                  padding: EdgeInsets.all(12.sp),
                  child: Icon(
                    prefixIcon,
                    size: 18.sp,
                    color: prefixColor ?? context.b2,
                  ),
                ),
              )
            : null,
        errorMaxLines: 1,
      ),
    );
    if (keyboardType == TextInputType.multiline) {
      textFormField = SizedBox(
        height: 250.sp,
        child: textFormField,
      );
    } else {
      if ((validator != null && isHeightFixed) &&
          maxLines == 1 &&
          keyboardType != TextInputType.multiline) {
        textFormField = SizedBox(
          height: 75.sp,
          child: textFormField,
        );
      }
    }
    if (margin != null) {
      textFormField = Padding(
        padding: margin!,
        child: textFormField,
      );
    }
    return textFormField;
  }
}
