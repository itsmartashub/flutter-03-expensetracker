import 'package:uuid/uuid.dart'; // za id cemo koristiti 3rd party library uuid: flutter pub add uuid

const uuid = Uuid();

/* dodavanje kategorije. mozemo m isad staviti u klasi za promenljive: final String category; ali je to suvise fleksibilno, dozvoljava previse vreednosti. i ako dodje do greske u kucanju, nece nam prijavii gresku, jer ako zelimo "shopping", i slucajno ukucamo "shoping", to ce proci, a ne bi smelo. Umesto toga zelimo fixiran set dozvoljenih vrednosti, tako da moramo da koristimo jednu od tih vrednosti kada kreiramo novi Expense.
To ce nam omoguciti enum keyword koji omogucava kreiranje custom type,  recimo Category, koji ce sadrzati sve predefinisane vrednosti.
! Imaj na umu da ove vrednosti nisu unutar stringa, ".."/'..', ali ce Dart da ih prepozna kaaaaoooo neeeeki string */
enum Category {
  food,
  travel,
  leisure,
  work,
}

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
}
