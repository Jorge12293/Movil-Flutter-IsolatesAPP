import 'package:appisolates/pages/compute_page.dart';
import 'package:appisolates/pages/spawn_page.dart';
import 'package:appisolates/pages/spawn_task_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:const SpawnTaskPage(),
     // home: const ComputePage(title: 'Flutter Demo Home Page'),
    );
  }
}
