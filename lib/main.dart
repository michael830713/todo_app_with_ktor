import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());
Logger logger = Logger();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: MyHomePage(title: 'TODO List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _fetchSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => todoList =
        prefs.getString('todoList') != null ? TodoList.fromJson(jsonDecode(prefs.getString('todoList'))) : TodoList());
  }

  void _saveToSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('todoList', jsonEncode(todoList.toJson()));
  }

  TodoList todoList;

  @override
  void didChangeDependencies() {
    _fetchSharedPref();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Center(child: Text(widget.title)),
      ),
      body: todoList != null
          ? ListView.builder(
              itemBuilder: (context, index) {
                Todo todoItems = todoList.todos[index];
                return Dismissible(
                  child: ListTile(
                    leading: Checkbox(
                      onChanged: (bool value) {
                        setState(() {
                          todoItems.finished = value;
                          _saveToSharedPref();
                        });
                      },
                      value: todoItems.finished,
                    ),
                    title: Text(
                      todoItems.content,
                      style: TextStyle(decoration: todoItems.finished ? TextDecoration.lineThrough : null),
                    ),
                  ),
                  key: UniqueKey(),
                  onDismissed: (ddd) {
                    setState(() {
                      todoList.todos.removeAt(index);
                      _saveToSharedPref();
                    });
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text("${todoItems.content} dismissed")));
                  },
                  background: Container(
                    color: Colors.red,
                  ),
                );
              },
              itemCount: todoList.todos.length,
            )
          : Center(
              child: Text('Loading...'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          TextEditingController textEditingController = TextEditingController();
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    title: Text('new TODO'),
                    content: TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(hintText: 'Enter here'),
                    ),
                    actions: <Widget>[
                      new FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: new Text(
                          "取消",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      new RaisedButton(
                        color: Colors.yellow,
                        onPressed: () {
                          setState(() {
                            if (textEditingController.text.isNotEmpty) {
                              todoList.todos.add(Todo(content: textEditingController.text));
                              _saveToSharedPref();
                            }
                          });
                          Navigator.of(context).pop();
                        },
                        child: new Text(
                          "確認",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ]);
              });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class TodoList {
  List<Todo> todos = [];

  TodoList();

  TodoList.fromJson(Map<String, dynamic> json) {
    if (json['todos'] != null) {
      todos = new List<Todo>();
      json['todos'].forEach((v) {
        todos.add(new Todo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.todos != null) {
      data['todos'] = this.todos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Todo {
  String content;
  bool finished;

  Todo({this.content, this.finished = false});

  Todo.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    finished = json['finished'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['finished'] = this.finished;
    return data;
  }
}
