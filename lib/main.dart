import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/expenses.dart';

// k je kao neki convenient i precutni dogovor da se koristi za globalne promenljive, pogotovo za teme. ali ne moramo, tho
var kColorScheme =
    ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 18, 215, 140));

void main() {
  runApp(
    MaterialApp(
      /* kada koristimo copyWith() na neki nacin overwritujemo originalnu material 3 temu, dakle koristimo original default flutter md temu, ali je overvritujemo sa svojim vrednostima.
      
      Inace postoji neka inkonzistentnost kada se koristi .copyWith(), a kada .styleFrom() kao recimo sa buttons */
      theme: ThemeData().copyWith(
          useMaterial3: true,
          colorScheme: kColorScheme,
          appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kColorScheme.onPrimaryContainer,
            foregroundColor: kColorScheme.primaryContainer,
          ),
          cardTheme: const CardTheme().copyWith(
            color: kColorScheme.secondaryContainer,
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: kColorScheme.primaryContainer),
          ),
          // textTheme: TextTheme()
          textTheme: ThemeData().textTheme.copyWith(
                // txt koji se korisi u AppBar-u
                // titleLarge: ThemeData().textTheme.copyWith(),
                //! inace ono gore foregroundColor za AppBarTheme OVERWRITUJE OVO OVDE SETOVANO ZA TEXT COLOR kad je AppBar u pitanju, ali ofc, za na drugim nekim mestima gde koristimo titleLarge nece overwritovati!!!
                titleLarge: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: kColorScheme.onSecondaryContainer,
                  fontSize: 20,
                ),
              )
          // svi skrins ce imati ovaj bg
          // scaffoldBackgroundColor: Color.fromARGB(255, 193, 171, 241),
          ),
      home: const Expenses(),
    ),
  );
}
