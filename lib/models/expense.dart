import 'package:flutter/material.dart'; // Za Icons.
import 'package:uuid/uuid.dart'; // za id cemo koristiti 3rd party library uuid: flutter pub add uuid
import 'package:intl/intl.dart'; //```flutter pub add intl

const uuid = Uuid();
final formatter = DateFormat.yMd(); // intl

/* dodavanje kategorije. mozemo m isad staviti u klasi za promenljive: final String category; ali je to suvise fleksibilno, dozvoljava previse vreednosti. i ako dodje do greske u kucanju, nece nam prijavii gresku, jer ako zelimo "shopping", i slucajno ukucamo "shoping", to ce proci, a ne bi smelo. Umesto toga zelimo fixiran set dozvoljenih vrednosti, tako da moramo da koristimo jednu od tih vrednosti kada kreiramo novi Expense.
To ce nam omoguciti enum keyword koji omogucava kreiranje custom type,  recimo Category, koji ce sadrzati sve predefinisane vrednosti.
! Imaj na umu da ove vrednosti nisu unutar stringa, ".."/'..', ali ce Dart da ih prepozna kaaaaoooo neeeeki string */
enum Category { food, travel, leisure, work }

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

class Expense {
  // zelimo da kreiramo novi id prilikom svakog inicijaliziranja ove klase i za to mozemo koristiti Initializer Lists koje se koriste za inicijalizaciju propertija klase (kao recimo "id") sa vrednostima koje se NE PRIMAJU kao argumenti constructor f-je.
  Expense(
      {required this.title,
      required this.amount,
      required this.date,
      required this.category})
      : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;
  // DAteTime je dart built-in, zato ne treba da importujemo

  // koristicemo 3d party package za formating dates, a to je Intl: flutter pub add intl
  String get formattedDate => formatter.format(date);
}

/* Za kreiranje Charta potrebno nam je vise bucket-a, jedan za svaku kategoriju da bismo mogli da saberemo sve troskove koje imamo za svaku kategoriju i prikazemo to u grafikonu. Za to kreiramo ovu posebnu kalsu koja ce da sadrzi sve te sabrane podatke */
class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenses});

  final Category category;
  final List<Expense> expenses;

  /* nasa alternativna named constructor funkcija koja se kreira koristeci ime klase ExpenseBucket pa stavljamo tacku pa ime nase exra constructor f-je koju zelimo da dodamo u ovu klasu, u nasem slucaju ce to biti forCategory().
  Tako recimo f-nisu i ovde ovi wigeti neki, recimo EdgeInsets.symmetric() 
  - U njoj imamo Listu Expenses-a lkoju cemo nazvali allExpenses, dakle svi troskvi, svih kategorija, i za drugi argument zelimo da njime setujemo kategoriju
  i logika ovoga je da dohvatimo sve troskve koje imamo i onda filtriramo onu koja pripada this.category pa da mozemo da setujemo expenses za ovaj ExpenseBucket u listu svih troskova allExpenses*/
  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  // double je broj sa decimalama. ovde cemo sabirati sve troskove
  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount; // sum = sum + expense.amount
    }

    return sum;
  }
}
