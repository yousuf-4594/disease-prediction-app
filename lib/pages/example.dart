import 'package:flutter/material.dart';

class Ishtiaq extends StatefulWidget {
  const Ishtiaq({super.key});

  @override
  State<Ishtiaq> createState() => _IshtiaqState();
}

class _IshtiaqState extends State<Ishtiaq> {
  int count =4;
  @override

  Widget build(BuildContext context) {

    print('build');
    return Scaffold(
      appBar: AppBar(
        title: const Text('ishtiaq'),
      ),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Center(
              child: Text(count.toString(), style: const TextStyle(fontSize: 50),),
            ),
          )
        ],
      ),
        floatingActionButton: FloatingActionButton(
        onPressed: (){
          count++;
          print(count);
          setState(() {

          });

    },
    child: const Icon(Icons.add),
    ),
    );
  }
}
