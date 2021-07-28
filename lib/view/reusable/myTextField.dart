import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hint, label, prefix;
  final Function whileChange, validate, onSubmit;
  final int max;
  final TextInputType textInputType;
  final Icon preicon;
  final Icon suffixicon;
  MyTextField(
      {@required this.hint,
      @required this.label,
      @required this.whileChange,
      @required this.validate,
      this.prefix,
      this.max,
      this.textInputType,
      this.preicon,
      this.suffixicon,
      this.onSubmit});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      validator: validate,
      onChanged: whileChange,
      maxLength: max,
      onFieldSubmitted: onSubmit,
      decoration: InputDecoration(
        prefixText: prefix,
        hintText: hint,
        labelText: label,
        prefixIcon: preicon,
        suffixIcon: suffixicon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Color(0xff347CE0))),
      ),
    );
  }
}
