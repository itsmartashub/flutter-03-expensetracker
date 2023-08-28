import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key});
  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          //? TextField widget
          /* Omogucava korisniku da unese text. Ima mnooogo propertyja */
          children: [
            TextField(
              maxLength: 50,
              decoration: InputDecoration(
                label: Text('Title'),
              ),
              //   keyboardType: TextInputType.text,
            )
          ],
        ));
  }
}
