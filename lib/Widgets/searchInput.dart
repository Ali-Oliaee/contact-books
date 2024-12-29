import 'package:flutter/material.dart';

Widget SearchInput(controller) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: TextFormField(
      autofocus: false,
      controller: controller,
      obscureText: false,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        isDense: true,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 0),
        ),
        hintText: 'Search by name or number',
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black12,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: const Color(0xffffffff),
        prefixIcon: const Icon(
          Icons.search_outlined,
        ),
      ),
    ),
  );
}
