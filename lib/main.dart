import 'package:flutter/material.dart';
import 'Screens/welcome.dart';
import 'package:provider/provider.dart';
import 'data/data_manager.dart';

void main() {
  runApp(MyBookShelf());
}

class MyBookShelf extends StatelessWidget {
  const MyBookShelf({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataManager(),
      child: MaterialApp(
        title: "Book_Shelf",
        home: Welcome(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
