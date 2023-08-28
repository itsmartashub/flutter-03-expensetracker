import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart'; // da bismo mogli da koristimo formatter koji smo definisali tamo sa: final formatter = DateFormat.yMd(); i ovde, wtf

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
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();

    super.dispose();
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    //? showDatePicker() flutter built-in method
    /* Ova fn koju prosledjujemo u then ce se izvrsiti by flutter kada vrednost bude dostupna tj kada korisnik izabere datum. Future Object. Zelimo da zadrzimo neku vrednost, neki event koji ce se desiti u buducnosti. Umesto then mozemo korisititi async */
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    // .then((value) => print(value));

    setState(() {
      _selectedDate = pickedDate;
    });
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
            Row(children: [
              /* * takodje mora Expanded jer se ispostavilo da TextField widget ima problema kada je unutar row-a ovako, jer takodje zeli horizontalno da zauze sto je vise psrostora moguce, a Row difoltno ne ogranicava prostor koji sme da se zauzme, i to izaziva probleme kada flutter treba da renderuje ovu kombinaciju na ekranu. A ako ovde budemo koristili Expanded ovde on ce se pobrinuti da TextField zauzme koliko mesa mu je potrebno za kontent, a ne vise */
              Expanded(
                child: TextField(
                  // onChanged: _saveTitleInput, // NACIN I
                  controller: _amountController, // NACIN II
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: '\$ ',
                    label: Text('Amount'),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              //! posto je Row unutar Row-a, moramo koristiti Expanded!
              Expanded(
                child: Row(
                  // da pushuje kontent na kraj (desno)
                  mainAxisAlignment: MainAxisAlignment.end,
                  // centrira verticalno
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // sa ! govorimo dartu da vrednost nece biti null, a buni se jer smo stavili gore DateTime? _selectedDate; sto znaci ili da bude date ili null, ali smo ovim ternarnim operatorom rekli da nece biti null
                    Text(_selectedDate == null
                        ? 'No date selected'
                        : formatter.format(_selectedDate!)),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: const Icon(Icons.calendar_month),
                    )
                  ],
                ),
              )
            ]),
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      /* pop property zeli context onaj iz Widget build(BuildContext context). pop() uklanja ovaj overlays sa skrina */
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    // print(_enteredTitle); // NACIN I
                    print(_titleController.text); // NACIN II
                    print(_amountController.text);
                  },
                  child: const Text('Save Expense'),
                ),
              ],
            )
          ],
        ));
  }
}
