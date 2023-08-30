import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/expenses.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData().copyWith(
          useMaterial3: true,
          // svi skrins ce imati ovaj bg
          scaffoldBackgroundColor: Color.fromARGB(255, 193, 171, 241)),
      home: const Expenses(),
    ),
  );
}
