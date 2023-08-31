import 'dart:io'; // Platform.isIOS

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart'; // da bismo mogli da koristimo formatter koji smo definisali tamo sa: final formatter = DateFormat.yMd(); i ovde, wtf

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;
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
  Category _selectedCategory = Category.leisure;

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

  void _showDialog() {
    //@ Platform.isIOS
    if (Platform.isIOS) {
      // ? showCupertinoDialog() = iOS pop-ip
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, amount, date and categor was entered..'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );
    } else {
      //? showDialog() = prikazuje neku info ili error dialog, neki pop-up
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, amount, date and categor was entered..'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );
    }
  }

  void _submitExpenseData() {
    // moramo pretvoriti amount koju korisnik unosi iz string au broj. to mozemo uraditi sa double.tryParse() koji za argument uzima string, potom vraca DOUBLE ako je uspeo da pretvori taj string u broj ili vraca NULL ako ne moze da konvertuje. reicmo tryParse('Hellooo') bi bilo null, a recimo tryParse('1.21') bi bilo 1.21
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    // trim() moze da se pozovde na textove, a .isEmpty() moze i na String i na List
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      _showDialog();
      return;
    }

    widget.onAddExpense(Expense(
      title: _titleController.text,
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory,
    ));

    // da se zatvori overlay
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    /* ? MediaQuery.of(context).viewInsets
    Kada sm ou landscape mode, keyboard zauzima vise od pola ekrana i ne mogu stvari da se unesu u input. Takodje, title je predugo, bespotrebno zauzima toliko mesta. Pa cemo staviti dinamicki padding onoliko koliko zauzima tastatura.
    viewInsets omogucava informacije o UI elementima koji mozda overlapuju neke delove UI-a. Ako recimo koristimo .viewInsets.bottom, dobijemo bilo koji extra UI element koji overlapuje UI od dole, a to je ono sto recimo keyboard radi, slajduje od dole i prekriva UI.
    ! Pa tako ovim dobijamo kolicinu prostora koju ta tastatura zauzima.
    Pa cemo na ovih 16 padding od dole, dodati i onaj extra prostor koji tastatura zauzima. Medjutim, ne desava se nista.
    ! Treba zapravo i ovaj widget tree koji je returned by a NewExpense widget, SCROLLABLE. Pa cemo Padding widget da wrapujemo u SingleChildScrollView widget sa Refactor...
    
    Medjutim, sada jos primecujemo da ModalSheet ne zauzima full height odnosno ne ide skroz do gore, ikao ajd, nije strasno, ali mi mozda zelimo da zauzima prostor skroz do gore. Pa cemo sad ovaj SingleChildScrollView da wrapujemo u novi widget SizedBox jer na njemu mozemo da stavimo height koji cemo staviti da bude double.infinity da bismo bili sigurnoi da ovo zauzima maximalno prostora koliko moze  */
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    /* ? LayoutBuilder
    Elem, mi u lanscape sad zelimo da title i amount budu jedno pored drugog u jednom row, a ispod d au durgom row budu datum i buttons. Mozemo to raditi peske kao sa grafikonom i listom troskova sa MediaQuery, a mozemo i koristiti flutter built-in widget LayoutBuilder koji pomaze u kreiranju UI layout-a koji automatski prilagodjava slobodan prostor???
    LayoutBuilder za parametar uzima builder koji ustvari zeli fn za argument koja ce automatski dohvatiti context object i constraints object, i tu cemo vratiti nas SizedBox widget tree.
    Sa constraints tacno znamo koliko imamo slobodnog prostora na osnovu cega onda mozemo da odlicimo koji kad layout treba da prikazemo.
    I ovo nam omogucava da kreiramo widget koji moze da se koristi bilo gde u nasem widget tree i ne mari za avaible width ili height of the screen, niti ga briga za orientation, vec samo brine koliko width i height je slobodno u ovom specific widgetu ovde.
    Recimo za NewExpense Widget, posto je on unutar model-a, dostupan prostor je screen dimensions posto on zauzima mesta od edge-to edge.
    Ali nam ovo omogucava da koristimo NewExpense widget bilo gde unutar naseg widget tree i on samo brine o constraints svog parenta, i ne zanima ga slobodan prostor width-a i height-a ekrana. I to onda mozemo da koristimo da dinamicki promenimo nas layout */
    return LayoutBuilder(builder: (ctx, constraints) {
      /*  print(constraints.minWidth);
      print(constraints.maxWidth);
      print(constraints.minHeight);
      print(constraints.maxHeight); */
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
              // padding: const EdgeInsets.all(16),
              //* da kontent ne bi se overlapovao sa gore kamerom i sl, ali posle cemo dodati useSafeArea: true u expenses.dart za showModalBottomSheet(), pa cemo ovaj padding top od 48 da vratimo na 16
              // padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
              padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
              child: Column(
                //? TextField widget
                /* Omogucava korisniku da unese text. Ima mnooogo propertyja */
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            // onChanged: _saveTitleInput, // NACIN I
                            controller: _titleController, // NACIN II
                            maxLength: 50,
                            decoration:
                                const InputDecoration(label: Text('Title')),
                          ),
                        ),
                        const SizedBox(width: 24),
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
                      ],
                    )
                  else
                    TextField(
                      // onChanged: _saveTitleInput, // NACIN I
                      controller: _titleController, // NACIN II
                      maxLength: 50,
                      decoration: const InputDecoration(
                        label: Text('Title'),
                      ),
                    ),
                  if (width >= 600)
                    Row(
                      children: [
                        DropdownButton(
                          // s ovim value se uveravamo da ce neki item da bude difoltno selektovan, a nece biti prazno (leisure je inicijalno)
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    // category.name.toString(),
                                    category.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }

                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        ),
                        const SizedBox(width: 24),
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
                      ],
                    )
                  else
                    Row(
                      children: [
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
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  const SizedBox(height: 16),
                  if (width >= 600)
                    Row(
                      children: [
                        const Spacer(),
                        TextButton(
                            onPressed: () {
                              /* pop property zeli context onaj iz Widget build(BuildContext context). pop() uklanja ovaj overlays sa skrina */
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel')),
                        ElevatedButton(
                          // onPressed: () {
                          //   // print(_enteredTitle); // NACIN I
                          //   print(_titleController.text); // NACIN II
                          //   print(_amountController.text);
                          // },
                          onPressed: _submitExpenseData,
                          child: const Text('Save Expense'),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        /* Category.values, .values je lista enum-a tj lista kategorija, a items zeli listu Dropdown menu itema, zato cemo koristiti .map() da transformisemo jedan tip podataka u drugi.
                          DropdownMenuItem je widget gde moramo da setujemo child parametar u drugi widget sto predstavlja ono sto ce biti prikazano na ekranu. category je enum a nama treba string posto koristimo u Text-u. pa cemo pretvoriti ovaj category u text sa flutter propertijme name na kog zovemo toString().
                          - Ovaj value property u DropdownMenuItem nije vidljiv korisniku, vec se cuva interno za svaki DMI, dakle ono sto je vidljivo je ovo child: Text. I to value predstvlja vrednost onog onChanged parametra koje se menja svaki x kad korisnik izabere neki od ovih DMI */
                        DropdownButton(
                          // s ovim value se uveravamo da ce neki item da bude difoltno selektovan, a nece biti prazno (leisure je inicijalno)
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    // category.name.toString(),
                                    category.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }

                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        ),
                        const Spacer(),
                        TextButton(
                            onPressed: () {
                              /* pop property zeli context onaj iz Widget build(BuildContext context). pop() uklanja ovaj overlays sa skrina */
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel')),
                        ElevatedButton(
                          // onPressed: () {
                          //   // print(_enteredTitle); // NACIN I
                          //   print(_titleController.text); // NACIN II
                          //   print(_amountController.text);
                          // },
                          onPressed: _submitExpenseData,
                          child: const Text('Save Expense'),
                        ),
                      ],
                    )
                ],
              )),
        ),
      );
    });
  }
}
