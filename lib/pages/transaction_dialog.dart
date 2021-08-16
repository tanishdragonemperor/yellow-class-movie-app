// @dart=2.9
import 'package:flutter/material.dart';

import '../model/transaction.dart';

class TransactionDialog extends StatefulWidget {
  final Transaction transaction;
  final Function(String name, double amount, bool isExpense,String directorName) onClickedDone;

  const TransactionDialog({
    Key key,
    this.transaction,
    this.onClickedDone,
  }) : super(key: key);

  @override
  _TransactionDialogState createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  final directorNameController=TextEditingController();

  bool isExpense = true;


  @override
  void initState() {
    super.initState();

    if (widget.transaction != null) {
      final transaction = widget.transaction;

      nameController.text = transaction.name;
      amountController.text = transaction.amount.toString();
      directorNameController.text=transaction.directorName;
      isExpense = transaction.isExpense;

    }
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    directorNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transaction != null;
    final title = isEditing ? 'Edit Movie Details' : 'Add Movie Details';

    return AlertDialog(

      title: Text(title),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 8),
              buildName(),
              SizedBox(height: 8),
              buildAmount(),
              SizedBox(height: 8),
              buildDirectorName(),
              SizedBox(height: 8,),
              buildRadioButtons(),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        buildCancelButton(context),
        buildAddButton(context, isEditing: isEditing),
      ],
    );
  }

  Widget buildName() => TextFormField(
    controller: nameController,
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      hintText: 'Enter Movie Name',
    ),
    validator: (name) =>
    name != null && name.isEmpty ? 'Enter a name' : null,
  );

  Widget buildAmount() => TextFormField(
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      hintText: 'Enter Movie Rating ',
    ),
    keyboardType: TextInputType.number,
    validator: (amount) => amount != null && double.tryParse(amount) == null
        ? 'Enter a valid number'
        : null,
    controller: amountController,
  );
  Widget buildDirectorName()=>TextFormField(
    controller: directorNameController,
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      hintText: 'Enter Movie Director Name',
    ),
    // validator: (directorName) =>
    // directorName != null && directorName.isEmpty ? 'Enter a name' : null,
  );

  Widget buildRadioButtons() => Column(
    children: [
      RadioListTile<bool>(
        title: Text('Not Liked ⭐⭐'),
        value: true,
        groupValue: isExpense,
        onChanged: (value) => setState(() => isExpense = value),
      ),
      RadioListTile<bool>(
        title: Text('Liked ⭐⭐⭐⭐⭐'),
        value: false,
        groupValue: isExpense,
        onChanged: (value) => setState(() => isExpense = value),
      ),
    ],
  );

  Widget buildCancelButton(BuildContext context) => TextButton(
    child: Text('Cancel'),
    onPressed: () => Navigator.of(context).pop(),
  );

  Widget buildAddButton(BuildContext context, {bool isEditing}) {
    final text = isEditing ? 'Save' : 'Add';

    return TextButton(
      child: Text(text),
      onPressed: () async {
        final isValid = formKey.currentState.validate();

        if (isValid) {
          final name = nameController.text;
          final amount = double.tryParse(amountController.text) ?? 0;
          final directorName=directorNameController.text ??"Null value aa rhi h";

          widget.onClickedDone(name, amount, isExpense,directorName);

          Navigator.of(context).pop();
        }
      },
    );
  }
}