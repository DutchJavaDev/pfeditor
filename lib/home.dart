import 'package:flutter/material.dart';
import 'package:pfeditor/create.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  List<Widget> createChildren(double containerWidth) {
    var children = List<Widget>.empty(growable: true);
    double padding = 1;
    for (var i = 0; i < 50; i++) {
      children.add(Row(
        children: [
          SizedBox(
            width: containerWidth / 2,
            height: containerWidth / 4,
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Container(
                  width: containerWidth / 2 - padding,
                  height: containerWidth / 4 - padding,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: Center(child: Text("$i")),
                ),
            ),
          ),
          SizedBox(
           width: containerWidth / 2,
            height: containerWidth / 4,
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Container(
                  width: containerWidth / 2 - padding,
                  height: containerWidth / 4 - padding,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: Text("${i*2}"),
                )
            ),
          )
        ],
      ));
    }

    return children;
  }

  @override
  Widget build(BuildContext context) {
    var appWidth = MediaQuery.of(context).size.width;
    var containerWidth = appWidth;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bonjour"),
      ),
      body: Center(
        child: Hero(
            tag: "landing",
            child: SizedBox(
              width: containerWidth,
              child: ListView(
                children: createChildren(containerWidth),
                
              ),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context){
              return const CreatePage();
          }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
