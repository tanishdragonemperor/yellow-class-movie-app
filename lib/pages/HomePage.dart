// @dart=2.9

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_app/Custom/ColoredButton.dart';
import 'package:movie_app/Service/Auth_Service.dart';

import 'package:movie_app/model/transaction.dart';
import 'package:movie_app/pages/SignUpPage.dart';
import 'package:movie_app/pages/transaction_dialog.dart';
import 'package:movie_app/widgets/navigation_drawer_widgets.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  AuthClass authClass=AuthClass();
  File _image;
  Future pickImage1() async{

      var image= (await ImagePicker().pickImage(source: ImageSource.gallery));


      setState(() {
        _image = File(image.path) ;
        print('$_image');
      });

  }
  @override
  void dispose() {
    Hive.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: AppBar(
          toolbarHeight: 100,

          backgroundColor: Colors.transparent,
          title: Text('Movie 🎥 App'),
          centerTitle: true,
          actions: [IconButton(icon: Icon(Icons.logout),onPressed: () async {
            await authClass.logout();
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>SignUpPage()), (route) => false);
          },)],
        ),
      ),
      body: ValueListenableBuilder<Box<Transaction>>(
        valueListenable: Boxes.getTransactions().listenable(),
        builder: (context, box, _) {
          final transactions = box.values.toList().cast<Transaction>();
          return buildContent(transactions);

        },
      ),
      // backgroundColor: Colors.black,
      backgroundColor: Color(0xFF1a2f45),


      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        child: Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => TransactionDialog(
            onClickedDone: addTransaction,
          ),
        ),
      ),
    ),
  );


  Widget buildContent(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return Center(
        child: Text(
          'No Seen Movies yet! 🎥 \n\nClick + To Add in List',
          style: TextStyle(fontSize: 24,color: Colors.yellowAccent),

        ),
      );
    } else {
      final netExpense = transactions.fold<double>(
        0,
            (previousValue, transaction) => transaction.isExpense
            ? previousValue - transaction.amount
            : previousValue + transaction.amount,
      );
      final newExpenseString = '\$${netExpense.toStringAsFixed(2)}';
      final color = netExpense > 0 ? Colors.green : Colors.red;

      return Column(
        children: [
          SizedBox(height: 24),
          Text(
            'Seen Movies 🎥',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: color,
            ),
          ),
          // SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: transactions.length,
              itemBuilder: (BuildContext context, int index) {
                final transaction = transactions[index];

                return buildTransaction(context, transaction);
              },
            ),
          ),

        ],
      );
    }
  }


  Widget buildTransaction(
      BuildContext context,
      Transaction transaction,
      ) {
    final color = transaction.isExpense ? Colors.red : Colors.green;

    final amount = transaction.amount.toStringAsFixed(2);
    final dn=transaction.directorName;

    return Column(
      children: [
        SizedBox(height: 30,),
        Card(


          shadowColor: Colors.black,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40)
          ),

          color: Colors.grey,
          child: Column(

            children: [

              InkWell(


                focusColor: Colors.yellowAccent,
                onTap:pickImage1,
                child: Container(


                  height: 200,
                  width: MediaQuery.of(context).size.width,





                  child: Container(
                    width: 50,
                    height: 50,

                    // color: Colors.red,
                    // decoration: BoxDecoration(
                    //   // borderRadius: BorderRadius.circular(20)
                    //
                    //   // image: DecorationImage(
                    //   //   // image:AssetImage('assets/a1.jpg'),
                    //   //   //
                    //   //   // fit: BoxFit.fill,
                    //   //
                    //   // )
                    // ),
                    child: _image ==null ? Icon(FontAwesomeIcons.plus):Image.file(this._image),


                  ),
                ),
              ),
              SizedBox(height: 10,),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40)
                  ),
                  // color: Colors.white,
                  child: ExpansionTile(

                    tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),

                    title: Text(
                      transaction.name,
                      maxLines: 2,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text(dn??"null"),
                    trailing: Text(
                      amount,

                      style: TextStyle(
                          color: color, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    children: [
                      buildButtons(context, transaction),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],

    );



  }


  Widget buildButtons(BuildContext context, Transaction transaction) => Row(
    children: [
      Expanded(
        child: TextButton.icon(
          label: Text('Edit'),
          icon: Icon(Icons.edit),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(

              builder: (context) => TransactionDialog(
                transaction: transaction,
                onClickedDone: (name, amount, isExpense,directorName) =>
                    editTransaction(transaction, name, amount, isExpense,directorName,
                    ),
              ),
            ),
          ),
        ),
      ),
      Expanded(
        child: TextButton.icon(
          label: Text('Delete'),
          icon: Icon(Icons.delete),
          onPressed: () => deleteTransaction(transaction),
        ),
      )
    ],
  );

  Future addTransaction(String name, double amount, bool isExpense,String directorName) async {
    final transaction = Transaction()
      ..name = name


      ..amount = amount
      ..directorName=directorName
      ..isExpense = isExpense;



    final box = Boxes.getTransactions();
    box.add(transaction);
    //box.put('mykey', transaction);

    // final mybox = Boxes.getTransactions();
    // final myTransaction = mybox.get('key');
    // mybox.values;
    // mybox.keys;
  }

  void editTransaction(
      Transaction transaction,
      String name,
      double amount,
      bool isExpense,
      String directorName
      ) {
    transaction.name = name;
    transaction.amount = amount;
    transaction.isExpense = isExpense;
    transaction.directorName=directorName;

    // final box = Boxes.getTransactions();
    // box.put(transaction.key, transaction);

    transaction.save();
  }

  void deleteTransaction(Transaction transaction) {
    // final box = Boxes.getTransactions();
    // box.delete(transaction.key);

    transaction.delete();
    //setState(() => transactions.remove(transaction));
  }


}
class Boxes {
  static Box<Transaction> getTransactions() =>
      Hive.box<Transaction>('transactions');
}