import 'package:expense/widgets/expenses_list/expenses_list.dart';
import 'package:expense/models/expense.dart';
import 'package:expense/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget{
  Expenses({super.key});
   @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses>{


  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work
      ),
      Expense(
      title: 'Cinema',
      amount: 15.11,
      date: DateTime.now(),
      category: Category.leisure
      ),
  ];
  
  void _openExpenseOverlay(){
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense,),
      );
  }

  void _addExpense(Expense expense){
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense)
  {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).
      showSnackBar(SnackBar
      (
        action: SnackBarAction(
          label: 'Undo',
           onPressed: (){
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
           }),
        duration: Duration(seconds: 3),
        content: Text('deleted'))
      );
  }


  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(child: Text("No expenses yet! Don't be shy add some"));
    if(_registeredExpenses.isNotEmpty)
    {
      mainContent =  ExpensesList(expenses:_registeredExpenses,onRemoveExpense: _removeExpense,);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Expense Tracker')
        ,actions: [
        IconButton(
          onPressed:_openExpenseOverlay,
          icon: Icon(Icons.add)
        )
      ]),
      body: Column(
        children: [
          const Text('The chart'),
          Expanded(
            child: mainContent)
        ],
      )
    );
  }
}