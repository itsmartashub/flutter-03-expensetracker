import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key});
  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
/* //? NACIN I
   var _enteredTitle = '';

  void _saveTitleInput(String inputValue) {
    _enteredTitle = inputValue;
  }
*/

  // ? NACIN II - TextEditingController() klasa
  /* TextEditingController je klasa provided by flutter. Ovo kreira object za hendlovanje user inputa. Objectc koji moze biti prosledjen kao vrednost TextField-a i onda ostavljamo flutter-u da hendluje storing tih podataka, itd.
  ! - Kada koristimo TextEditingController, treba imati na umu jednu vaznu stvar: kada ovde kreiramo TextEditingController, takodje treba i da kazemo flutter-u da obrise taj controller kada nam widget vise nije potreban, npr kada je model overlay closed. Inace ce zauzimati memoriju iako widget vise nije vidljiv!!!
  ? DISPOSE
  - zato koristimo dispose() method i pozivamo super.dispose(), i pre nego sto pozovemo super.dispose(), treba da reachoutujemo nas _titleController i da na njemu pozovemo dispose() metod, cime govorimo flutteru da nam ovaj controller vise nije potreban
  
  - Sada sa NACIN II mozemo da idemo u TextField i obrisemo onChanged parametar, vise nam ne treba, i umesto toga dodajemo controller parametar da on sad bude zaduzen za ovo TextField */
  final _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          //? TextField widget
          /* Omogucava korisniku da unese text. Ima mnooogo propertyja */
          children: [
            TextField(
              // onChanged: _saveTitleInput, // NACIN I
              controller: _titleController, // NACIN II
              maxLength: 50,
              decoration: const InputDecoration(
                label: Text('Title'),
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // print(_enteredTitle); // NACIN I
                    print(_titleController.text); // NACIN II
                  },
                  child: const Text('Save Expense'),
                )
              ],
            )
          ],
        ));
  }
}
