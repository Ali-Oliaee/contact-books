import 'package:flutter/material.dart';

PreferredSizeWidget InnerAppbar(title, context, {actionButton}) {
  return AppBar(
    automaticallyImplyLeading: false,
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back_rounded,
        size: 30,
      ),
      onPressed: () async {
        Navigator.pop(context);
      },
    ),
    title: Text(
      title,
    ),
    centerTitle: false,
    elevation: 2,
    actions: [actionButton ?? Container()],
  );
}
