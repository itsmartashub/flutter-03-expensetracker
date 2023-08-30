import 'package:flutter/material.dart';
/* services.dart je fajl koji nam omogucava f-sti koje mozemo koristiti recimo za lockovanje screen orientation, da korisnik ne moze da rotira skrin na telefonu */
import 'package:flutter/services.dart';

import 'package:expense_tracker/widgets/expenses.dart';

// k je kao neki convenient i precutni dogovor da se koristi za globalne promenljive, pogotovo za teme. ali ne moramo, tho
var kColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 18, 215, 140));

// brightness govori dartu da napravi color scheme za dark mode
var kDarkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 7, 77, 50));

void main() {
/*   /* ? SystemChrome.setPreferredOrientations() i WidgetsFlutterBinding.ensureInitialized();
  uzima listu svih orijentacija uredjaja koje zelimo da dozvolimo. Ova fn ima Future tj then(), then za argument ima fn koju samo unesemo za parametar al ne kor, i u nju stavljamo nasu runApp fn, dakle mozemo da pokrenemo app tek kad lockujemo orientation.
  Ali zaj sa tim moramo da dodamo WidgetsFlutterBinding.ensureInitialized(); jer ono kao garantuje da locking app i runApp rade kako treba */
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((fn) { */
  runApp(
    MaterialApp(
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: kDarkColorScheme,
        cardTheme: const CardTheme().copyWith(
          color: kDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.primaryContainer,
            foregroundColor: kDarkColorScheme.onPrimaryContainer,
          ),
        ),
      ),

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
                  fontSize: 18,
                ),
              )
          // svi skrins ce imati ovaj bg
          // scaffoldBackgroundColor: Color.fromARGB(255, 193, 171, 241),
          ),

      //* koji mode da bude defaultni, ThemeMode.light | ThemeMode.dark | ThemeMode.system. Medjutim ,defaultni by flutter je ThemeMode.system tako da to mi ne moramo da setujemo
      // themeMode: ThemeMode.system,
      home: const Expenses(),
    ),
  );
  // });
}
