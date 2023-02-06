import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


  class FibonacciArguments{
    final String message;
    final int n;
    FibonacciArguments(this.n,this.message);

    FibonacciArguments copyWith(int n){
      return FibonacciArguments( n, message);
    }
  
  }

  int fibonacci(FibonacciArguments arguments){
    final n = arguments.n;
    final message = arguments.message;
    //debugPrint(message);
    if(n<2){
      return n;
    }
    return fibonacci(arguments.copyWith(n-2)) + fibonacci(arguments.copyWith(n-1));
  }


class ComputePage extends StatefulWidget {
  const ComputePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ComputePage> createState() => _ComputePageState();
}

class _ComputePageState extends State<ComputePage> {
  int num = 0;
  
  void onPressed() async {
    // <entry (int), exit (int) >
    final result = await compute<FibonacciArguments,int>(
      fibonacci,
      FibonacciArguments(40,'print jr')
    );
    num = result;
    setState(() { });
  }



   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("$num",
          textAlign: TextAlign.center)
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>onPressed(),
        child: const Icon(Icons.add),
      ),
    );

  }
}
