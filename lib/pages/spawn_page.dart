import 'dart:async';
import 'dart:isolate';

import 'package:appisolates/data/db.dart';
import 'package:appisolates/data/user.dart';
import 'package:flutter/material.dart';


class IsolateArguments{
  final DB db;
  final SendPort sendPort;
  IsolateArguments(this.db,this.sendPort);
}

void entryPoint(IsolateArguments arguments) async {
  final user = arguments.db.create();
  print('Users ${arguments.db.count}');
 // arguments.db.add(User('Lala', 17));
  arguments.sendPort.send(user);
  // await Future.delayed(const Duration(seconds: 2));
  /*
  Timer.periodic(const Duration(seconds: 1), (_) {
    sendPort.send(DateTime.now().toString());
  });
  */
}

class SpawnPage extends StatefulWidget {
  const SpawnPage({Key? key}) : super(key: key);
  @override
  State<SpawnPage> createState() => _SpawnPageState();
}

class _SpawnPageState extends State<SpawnPage> {
  String text = "HELLO APP";
  Isolate? isolate;
  ReceivePort receivePort = ReceivePort();
  late StreamSubscription subscription;
  DB db = DB();

  @override
  void initState() {
    super.initState();
    subscription = receivePort.listen((message) { 
      if(message is User){
        db.add(message);
          setState(() {});
      }
    
    });
  }

  void onPressed() async{
    try{
      isolate?.kill(); // Kill Isolate
      isolate = await Isolate.spawn<IsolateArguments>(entryPoint,IsolateArguments(db, receivePort.sendPort));
    }on IsolateSpawnException catch(e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    subscription.cancel();
    isolate?.kill();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed:(){}, 
            icon: const Icon(Icons.info_outline)
          )
        ],
      ),
      body:Center(
        child: Text(db.count.toString(),
          style:const TextStyle(fontSize: 20))
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: onPressed,
      ),
    );
  }
}