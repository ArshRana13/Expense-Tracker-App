import 'package:expense/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();
class NewExpense extends StatefulWidget{
  NewExpense({super.key, required this.onAddExpense});

  final Function(Expense expense) onAddExpense;

  @override
  State<StatefulWidget> createState() {
    return _NewExpenseState();
  }
}


class _NewExpenseState extends State<NewExpense>{
 
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _submitExpenseData(){
    final enteredAmount = double.tryParse(_amountController.text) ;
    final amountIsInavlid = enteredAmount == null || enteredAmount<=0;
    if(_titleController.text.trim().isEmpty || amountIsInavlid || _selectedDate == null)
    {
      //show error 
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: Text('Please make sure a valid title, amount and date was entered'),
          actions: [
            TextButton(onPressed: 
            (){
              Navigator.pop(context);
              },
             child: Text('Okay'))
          ],
        )
        );
        return;
    }

    widget.onAddExpense(Expense(
      title: _titleController.text,
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory
      )
       );

       Navigator.pop(context);

  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate:  now,
      firstDate: firstDate,
      lastDate: now
       );
       setState(() {
         _selectedDate = pickedDate;
       });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16,48,16,16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 25,
            decoration: const InputDecoration(
              label: Text('Title')
              ),
          ),
          Row(
            children: [
             Expanded(child: TextField(
            keyboardType: TextInputType.number,
            controller: _amountController,
            decoration: const InputDecoration(
              prefixText: '₹ ',
              label: Text('Amount')
            ),
          )
             ),
          SizedBox(width: 16,),
          Expanded(child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
            Text(_selectedDate == null ? 'No date selected' : formatter.format(_selectedDate!)),
            IconButton(
              onPressed: _presentDatePicker,
             icon: Icon(Icons.calendar_month))
          ],)
          )
          ],
          
          ),
          SizedBox(height: 16,)
          ,
          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                items: Category.values.map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e.name.toUpperCase()))
                    ).toList(),
                 onChanged: (value){
                  if(value == null)
                  {
                  return;
                  }
                  setState(() {

                    _selectedCategory = value;
                  });
                 }
                 ),
              Spacer(),

              ElevatedButton(onPressed: _submitExpenseData,
              child: const Text('Save Expense')),
              Spacer(),
              ElevatedButton(onPressed: (){
                Navigator.pop(context);
              },
              child: const Text('Cancel'))
            ],
          )

        ],
      ),
      );
  }
}