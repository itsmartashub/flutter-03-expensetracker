import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';

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
    //! Kada koristimo isScrollControlled parametar showModalBottomSheet() metoda, i stavimo da bude true, kada otvorimo modal overlay on ce zauzimati full-height, tako da tastatura nece prekrivati ovaj modal. Medjutim,a sada kontent prekriva neke stvari gde je kamera recimo za neke uredjaje. Da se to ne bi desavalao idemo u new_expanses.dart i tamo cemo dodati padding, tj editovacemo vec postojeci iz .symmetric u .fromLTRB)(16, 48, 16, 16)
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      // builder: (ctx) => Text('Modal botom sheet'),
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    // mora unutar setState da se uverim  oda je UI apdejtovan
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);

    setState(() {
      _registeredExpenses.remove(expense);
    });

    /*  ? ScaffoldMessenger.of().clearSnackBars()
    kada se uklanja vise itema iz liste odjedno, tj jedan za drugim, ovo omogucava da se snackbar dole ocisti ubrzo, a ne da jedan ceka 3s od prethodnog, pa se prikaze on */
    ScaffoldMessenger.of(context).clearSnackBars();

    /* ? ScaffoldMessenger.of().showSnackBar()
    obavezan of metod koji za parametar uzima context koji nam je dostupan u ovoj klasi jer je bazirana na State klasi */
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense removed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => {
            setState(() {
              //! insert kao i add dodaje item u listu sa razlikom ad dodaje na specificnoj poziciji jer zelimo da item koji je uklonjen (slucajno recimo) vratimo na isto mesto gde je bio. Zato moramo da kreiramo expenseIndex promenljivu koja ce cuvati poziciju tog indexa sa _registeredExpenses.indexOf(expense),i to cemo staviti za prvi parametar u ovog insert metoda, a za drugi cemo staviti expense tj item koji smo obrisali
              _registeredExpenses.insert(expenseIndex, expense);
            })
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //? MediaQuery.of(context)
    /*  Za to mozemo koristiit MediaQuery klasu koja ima .of constructor fn koja prihvata context za argument koji sadrzi bitne meta informacije o widgetu u kom se ovaj kod izvrsava i o inace  njegovoj poziciji u widget tree. I kada se MediaQuery konektuje sa contextom mozemo pristupiti mnostvo informacijama na tom kreiranom MediaQuery objektu.
    Npr, postoji size property koji daje pristup objektu koji daje jos vise informacija o svim dostupnim velicinama na uredjaju, tipa aspectRatio, height, width, itd
    - Inace, kada rotiramo ekran, flutter ponovo executuje ovaj build metod pa dobijamo apdejtovane vrednosti za width i height */
    // print(MediaQuery.of(context).size.width);
    // print(MediaQuery.of(context).size.height);
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      //? AppBar() widget
      /* actions parametar zeli listu widgeta koji se inace koristi za prikazivanje buttonsa u ovom top baru. I sada kada smo dodali AppBar, Flutter je automatski bolje fitovao sadrzaj, tipa vise The Chart nije na mestu gde je notch, vec app pocinje takoreci posle statusne traake one na telefonu */
      appBar: AppBar(
        title: const Text('Flutter Expense tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _openAddExpenseOverlay,
          ),
        ],
      ),

      /* ovde hocemo da promenimo layut kada je tel u portrait modu a kada je u landscape. kad je ulandscape zelimo da Chart i Expanded tj lista troskova budu prikazani jedno pored drugog, dakle u tom slucaju bi trebalo koristiti Row umesto Column, zar ne. Zato treba da gore u Widget buildu proverimo koliko width-a imamo dostupno, i ako nemamo dovoljno onda zelimo da switchujemo u Row.
      Za to mozemo koristiit MediaQuery klasu koja ima .of constructor fn koja prihvata context za argument  */
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                /* ! I mi bismo sad trebali da vidimo ovu ExpenseListu ali je ne vidimo, jer su ovi Expenses widget u Column()-u, i u toj Column sada imamo Listu (ExpensesList), takoreci imamo Column unutar Columna, kada imamo kombinaciju kao ova, uvek cemo biti u nekom problemu jer Flutter ne zna kako da size-uje ili kako da restrict inner Column. I ovaj tip problema se resava tako sto ExpensesList wrapujemo unutar Expanded() widgeta, i setujemo ovu ExpesesListu za njegov child */
                // ExpensesList(expenses: _registeredExpenses),
                Expanded(child: mainContent),
                // Text('Expenses list... '),
              ],
            )
          /* Medjutim ovde sad posytoji problem sto Row zauzima width koliko god moze, ali i njegov child Chart isto (jer ima width: double.infinity), a to izaziva gresku u dartu i sadrzaj ne moze da se prikaze kako treba. Zato kada imamo parenta koji zauzima width koliko moze, i child-a koji isto zauzima koliko moze, treba child da metnemo u Expanded */
          : Row(
              children: [
                Expanded(child: Chart(expenses: _registeredExpenses)),
                Expanded(child: mainContent),
              ],
            ),
    );
  }
}
