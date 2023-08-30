import 'package:expense_tracker/widgets/expenses_list/expense_item.dart'; // ExpenseItem()
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart'; // this.expenses

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expenses, required this.onRemoveExpense});

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    //? ListView.builder
    /* Kada imamo listu ciju duzinu, tj size ne znam unapred, kao recimo ovde gde ne znamo ni koliko ce biti itema u listi pa tako ni kolika ona rteba da bude, sta ako ona bude suvise duga, ne mozemo bas korisiti Column() kao do sad. Jer kad koristimo Column(), svi widgeti koje dodamo u njega ce se u Dartu u pozadini kreirati kada god ovaj widget (ExpensesList) koji outputuje ovaj Column() postane aktivan, sto znaci, ako imamo na hiljat itema u listi, svi ovi itemi ce se kreirati u pozadini by Flutter u trenutku kada ovaj List weidgte ExpensesList bude prikazan na ekranu. Problem sa ovim je taj sto nam je samo mala kolicina ovih itema potrebna, jer je samo malo njih zapravo vidljivo na ekranu u datom trenutku. Imacemo scrollable listu, i vecina ovih itema nece biti vidljiva inicijalno.
    - Za to cemo koristiti ListView(), a ne Column(). Medjutim, ako napisemo ListView(children: []), nista se nece to razlikovati od Column(), samo ce biti scrollable, ali on u pozadini isto renderuje sve, a ne samo vidljivo. zato treba koristiti specijalno ListView constructor builder:
    ```    ListView.builder(itemBuilder: itemBuilder)
    Dakle on ce da builduje list item samo kada treba da postane vidljiv, neposredno pre nego sto skrolujemo tu, tako da kazem.
    builder za parametar ima itemBuilder sto je funkcija koja ce imati input value sama po sebi, to se kreira bu Flutter i onda bi trebalo da vrati widget, tj list item koji bi trebalo da se kreira
    - itemBulder je required, ali imammo mnogo parametara, nama treba itemCount.
    - Ova anonimna fn, itemBulder, ce se pozvati onoliko x koliko ima itema u listi */
    // return ListView(children: [])
    return ListView.builder(
      itemCount: expenses.length,
      // itemBuilder: (ctx, index) => Text(expenses[index].title),
      // itemBuilder: (ctx, index) => ExpenseItem(expenses[index]),
      /* ? Dismissible() widget
        ! za remove swipovanje koji za parametar ima widget koji ce da bude removable, i key da bi flutter znao koji widget treba da ukloni (to je onaj key iz super.key)
        ```   ValueKey(expenses[index]) 
        ! Medjutim ovo uklanja widget samo vizuelno, iz UI, ali moramo ukloniti i iz data liste zapravo jer dodje do greske kada krenemo da kreiramo novi expense.  koristimo onDismissed Dismissible parametar za to, a fn _removeExpense() idemo da kreiramo u expenses.dart. Medjutim, onDismissed zeli FUNKCIJU za value koja uzima DismissDirection za input sto govori da li svajpujemo s leva na desno ili s desna na levo */
      itemBuilder: (ctx, index) => Dismissible(
        onDismissed: (direction) {
          onRemoveExpense(expenses[index]);
        },
        key: ValueKey(expenses[index]),
        child: ExpenseItem(expenses[index]),
      ),
    );
  }
}
