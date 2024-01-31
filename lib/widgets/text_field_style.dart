import 'package:flutter/material.dart';

class TextFieldStyle extends InputDecoration {
  const TextFieldStyle({required String hint}): super(
    labelText: hint,
    border: const OutlineInputBorder()
  );
}