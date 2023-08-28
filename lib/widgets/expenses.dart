import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
//   _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Flutter Course',
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Cinema',
        amount: 15.99,
        date: DateTime.now(),
        category: Category.leisure),
  ];

  // ? showModalBottomSheet je flutter fn
  /* Ova fn kada god se izvrsi dinamicno dodaje novi UI element poput modal overlay-a. On ima dva obavezna parametra: context i builder context parametar zeli vrednost BuildContext parametra, ovog dole recimo u Widget build(BuildContext context koji dobijamo automatski
  Posto smo  u widgetu koji extenduje State, flutter automatski dodaje context property tvojoj klasi, i onda se taj context provided by flutter moze koristiti ovde za vrednost ovog ovde context parametra
  //? Context
  Svaki widget uma svoj context object koji sadrzi metadata informacije u skladu sa tim widgetom i VRLO VAZNO, u skladu za pozicijom widgeta u celokupnom UI, u celokupnom widget tree
  //? Builder
  Njemu treba fn kao vrednost koja vraca Widget, i uatomatski dobija 1 input value passed by flutter koji poziva ovu builder fn buk kada pokusava da prikaze showModalBottomSheet.
  Ovde koristmo ctx, a ne context, jer je to drugaciji context ustv pa das e ne clashaju, i onda u return vracamo nas widget koji zelimo da se renderuje kada se klikne na add btn */
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Text('Modal botom sheet'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //? AppBar() widget
      /* actions parametar zeli listu widgeta koji se inace koristi za prikazivanje buttonsa u ovom top baru. I sada kada smo dodali AppBar, Flutter je automatski bolje fitovao sadrzaj, tipa vise The Chart nije na mestu gde je notch, vec app pocinje takoreci posle statusne traake one na telefonu */
      appBar: AppBar(
        title: Text('Flutter Expense tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _openAddExpenseOverlay,
          ),
        ],
      ),
      body: Column(
        children: [
          const Text('The chart'),
          /* ! I mi bismo sad trebali da vidimo ovu ExpenseListu ali je ne vidimo, jer su ovi Expenses widget u Column()-u, i u toj Column sada imamo Listu (ExpensesList), takoreci imamo Column unutar Columna, kada imamo kombinaciju kao ova, uvek cemo biti u nekom problemu jer Flutter ne zna kako da size-uje ili kako da restrict inner Column. I ovaj tip problema se resava tako sto ExpensesList wrapujemo unutar Expanded() widgeta, i setujemo ovu ExpesesListu za njegov child */
          // ExpensesList(expenses: _registeredExpenses),
          Expanded(child: ExpensesList(expenses: _registeredExpenses)),
          // Text('Expenses list... '),
        ],
      ),
    );
  }
}
