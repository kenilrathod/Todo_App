// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:todo_app/databasehelper.dart';

void main() {
  runApp(myapp());
}

class myapp extends StatelessWidget {
  const myapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(accentColor: Colors.green),
      home: const homepage(),
    );
  }
}

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  String task = "";
  final dbhelper = Databasehelper.instance;

  final texteditcontroller = TextEditingController();
  bool validate = true;
  String errmsg = "";

  var mylist = <String>[];
  List<Widget> children = [];

  void insertdata() async {
    Map<String, Object?> row = {Databasehelper.columntask: task};

    final id = await dbhelper.insertTodo(row);
    print(id);
    Navigator.pop(context);
    task = "";
    setState(() {
      validate = true;
    });
  }

  Future<bool> query() async {
    children = [];
    mylist = [];

    var alltask = await dbhelper.getallTodo();
    alltask.forEach((element) {
      mylist.add(element.toString());
      children.add(Card(
        elevation: 3.0,
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        child: Container(
          child: ListTile(
              title: Text(element["task"],
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold)),
              trailing: InkWell(
                splashColor: Colors.blueGrey,
                onTap: () {
                  dbhelper.deleteTodo(element["id"]);
                  setState(() {});
                },
                borderRadius: BorderRadius.circular(5),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                  size: 28.0,
                  semanticLabel: "delete",
                ),
              ),
              onTap: () {}),
        ),
      ));
    });
    return Future.value(true);
  }

  void showBox(BuildContext context) {
    texteditcontroller.text = "";
    showDialog(
        context: context,
        builder: (_) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              title: const Text(
                "Add Item",
                style: TextStyle(color: Colors.blue),
              ),
              content: TextField(
                controller: texteditcontroller,
                onChanged: (_value) {
                  setState(() {
                    task = _value;
                  });
                },
                decoration: InputDecoration(
                  errorText: validate ? null : errmsg,
                  errorStyle: TextStyle(color: Colors.red, fontSize: 17),
                  hintText: "TODO item",
                ),
                style: const TextStyle(
                  fontSize: 20,
                  decoration: TextDecoration.none,
                ),
                autofocus: true,
              ),
              actions: [
                Center(
                    child: RaisedButton(
                  onPressed: () {
                    if (texteditcontroller.text.isEmpty) {
                      setState(() {
                        errmsg = "it can't be empty";
                        validate = false;
                      });
                    } else
                      insertdata();
                  },
                  child: Text(
                    "ADD",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ))
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: (context, snap) {
          if (snap.hasData == null) {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.blue,
                  title: Text("TODO APP"),
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        showBox(context);
                      },
                    )
                  ],
                ),
                body: Center(child: CircularProgressIndicator()));
          } else {
            if (mylist.length != 0) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.blue,
                  centerTitle: true,
                  title: Text(
                    "TODO",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.blue,
                  onPressed: () {
                    showBox(context);
                  },
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: children,
                  ),
                ),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  backgroundColor: Colors.blue,
                  title: Text(
                    "TODO",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Icon(Icons.menu, color: Colors.white),
                  actions: [
                    IconButton(
                      padding: EdgeInsets.all(0),
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.blue,
                  onPressed: () {
                    showBox(context);
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
                body: const Center(
                  child: Text("No Todo item is available",
                      style: TextStyle(color: Colors.grey, fontSize: 18)),
                ),
              );
            }
          }
        },
        future: query());
  }
}
