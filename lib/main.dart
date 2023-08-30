import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/expenses.dart';

// k je kao neki convenient i precutni dogovor da se koristi za globalne promenljive, pogotovo za teme. ali ne moramo, tho
var kColorScheme =
    ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 18, 215, 140));

void main() {
  runApp(
    MaterialApp(
      /* kada koristimo copyWith() na neki nacin overwritujemo originalnu material 3 temu, dakle koristimo original default flutter md temu, ali je overvritujemo sa svojim vrednostima */
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.primaryContainer,
        ),
        // svi skrins ce imati ovaj bg
        // scaffoldBackgroundColor: Color.fromARGB(255, 193, 171, 241),
      ),
      home: const Expenses(),
    ),
  );
}
