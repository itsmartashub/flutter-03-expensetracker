import 'package:flutter/material.dart';
import 'package:expense_tracker/expenses_list.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
