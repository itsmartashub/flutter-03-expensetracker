import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});
  final Expense expense;

  @override
  Widget build(BuildContext context) {
    // ? Card widget
    /* Uglavvnom se koristi iz styling razloga, stavice kontent u Card koji je vise elevated, ima slide shadow behind itself, itd. Takodje dodaje top i bottom margin. Card nema padding parametar. Ali mozemo ovaj TExt widgte da refactorujemo sa wrap u Padding widget*/
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        // child: Text(expense.title),
        child: Column(children: [
          Text(expense.title),
          const SizedBox(height: 4),
          Row(
            children: [
              /* //! 12.3433 => 12.34
              expense.amount je double pa konvertujemo u string sa toString() tj u ovom slucaju sa toStringAsFixed( ) jer hocemo da zaokruzimo na dve decimale. I zelimo da stavimo $ dollar sign ispred vrednosti, zato moramo dodati ${} (injected syntax) i ispred \$ (zapravo dollar sign) */
              Text('\$${expense.amount.toStringAsFixed(2)}'),

              /* ? Spacer widget
              widget koji moze da se koristi i u Row i u Column da kaze Flutter-u da kreira widget koji treba da zauzme koliko god prostora moze izmedju widgeta pre i posle Spacer()-a */
              const Spacer(),
              /* category i date wrapujemo u Row, i zelimo da ih pushujemo skroz udesno, na kraj Card-a */
              Row(
                children: [
                  Icon(categoryIcons[expense.category]),
                  const SizedBox(width: 8),
                  Text(expense.formattedDate),
                ],
              ),
            ],
          )
        ]),
      ),
    );
  }
}
