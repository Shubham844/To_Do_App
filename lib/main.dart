import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';
import 'task_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TaskScreen(),
    );
  }
}
