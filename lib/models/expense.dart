import 'package:uuid/uuid.dart'; // za id cemo koristiti 3rd party library uuid: flutter pub add uuid

const uuid = Uuid();

class Expense {
  // zelimo da kreiramo novi id prilikom svakog inicijaliziranja ove klase i za to mozemo koristiti Initializer Lists koje se koriste za inicijalizaciju propertija klase (kao recimo "id") sa vrednostima koje se NE PRIMAJU kao argumenti constructor f-je.
  Expense({required this.title, required this.amount, required this.date})
      : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  // DAteTime je dart built-in, zato ne treba da importujemo
}
