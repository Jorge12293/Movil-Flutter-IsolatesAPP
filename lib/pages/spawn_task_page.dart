import 'dart:async';
import 'dart:isolate';

import 'package:appisolates/data/db.dart';
import 'package:appisolates/data/user.dart';
import 'package:flutter/material.dart';

class IsolateTask{
  final Completer<User> completer;
  final Isolate isolate;
  IsolateTask(this.completer, this.isolate); 
}

class IsolateResponse{
  final int taskId;
  final User user;
  IsolateResponse(this.taskId, this.user);
  void printName(){
    debugPrint('Hello Jorge');
  }
}


class IsolateArguments{
  final int taskId;
  final DB db;
  final SendPort sendPort;
  IsolateArguments(this.taskId,this.db,this.sendPort);
}

void entryPoint(IsolateArguments arguments) async {
  await Future.delayed(const Duration(seconds: 3));
  final user = arguments.db.create();
  debugPrint('Users ${arguments.db.count}');
  arguments.sendPort.send(IsolateResponse(arguments.taskId, user));
}

class SpawnTaskPage extends StatefulWidget {
  const SpawnTaskPage({Key? key}) : super(key: key);
  @override
  State<SpawnTaskPage> createState() => _SpawnTaskPageState();
}

class _SpawnTaskPageState extends State<SpawnTaskPage> {
  String text = "HELLO APP";
  DB db = DB();
  int _taskId=0;

  ReceivePort receivePort = ReceivePort();
  late StreamSubscription subscription;
  final Map<int,IsolateTask> _tasks = {};


  @override
  void initState() {
    super.initState();
    subscription = receivePort.listen((data) { 
      if(data is IsolateResponse){
        data.printName();
        final task = _tasks[data.taskId];
        if(task != null){
          task.isolate.kill();
          task.completer.complete(data.user);
          _tasks.remove(data.taskId);
        }
      }
    });
  }

  void onPressed() async{
    final user = await _addUser();
    if(user != null){
      db.add(user);
      setState(() {});
    }
  }

  Future<User?> _addUser() async{
    try{
      _taskId++;
      final isolate = await Isolate.spawn<IsolateArguments>(
        entryPoint,
        IsolateArguments(_taskId,db, receivePort.sendPort)
      );
      final Completer<User> completer = Completer(); 
      _tasks[_taskId] = IsolateTask(completer, isolate);
      return completer.future;
      
    }on IsolateSpawnException catch(e) {
      debugPrint(e.toString());
      return null;
    }
  }



  @override
  void dispose() {
    subscription.cancel();
    _tasks.forEach((key, value) {
      value.isolate.kill();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed:(){
              debugPrint("Tasks: ${_tasks.length}");
            }, 
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