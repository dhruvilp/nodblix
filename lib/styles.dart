import 'package:flutter/material.dart';

class NodblixStyles {
  static const primaryColor = Color(0xFF17FF8E);

  static final buttonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(primaryColor),
    padding: MaterialStateProperty.all(
      const EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 30.0,
      ),
    ),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
    elevation: MaterialStateProperty.all(6.5),
  );
}
