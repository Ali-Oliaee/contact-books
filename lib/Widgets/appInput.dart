import 'package:flutter/material.dart';

Widget AppInput(placeholder, icon, controller, validator) {
  return Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(16, 30, 16, 0),
    child: TextFormField(
      autofocus: false,
      validator: validator,
      obscureText: false,
      controller: controller,
      decoration: InputDecoration(
        isDense: true,
        labelText: placeholder,
        hintText: placeholder,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFF3A3636),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0x00000000),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        prefixIcon: Icon(icon),
      ),
    ),
  );
}
