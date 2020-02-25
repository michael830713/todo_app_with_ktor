import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  void _hideDoneTodo({bool hideDone}) {
    setState(() {
      return todoList.hideDoneTodo = hideDone;
    });
    _saveToSharedPref();
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check_circle_outline),
            onPressed: () {
              _hideDoneTodo(hideDone: !todoList.hideDoneTodo);
            },
          )
        ],
        centerTitle: true,
        title: Center(child: Text(widget.title)),
      ),
      body: todoList != null
          ? ReorderableListView(
              children: todoList.todosForDisplay.map((todo) {
                return Dismissible(
                  child: ListTile(
                    leading: Checkbox(
                      onChanged: (bool value) {
                        setState(() {
                          todo.finished = value;
                          _saveToSharedPref();
                        });
                      },
                      value: todo.finished,
                    ),
                    trailing: Icon(Icons.drag_handle),
                    title: Text(
                      todo.content,
                      style: TextStyle(decoration: todo.finished ? TextDecoration.lineThrough : null),
                    ),
                    subtitle: Text(todo.dateTime),
                  ),
                  key: UniqueKey(),
                  onDismissed: (ddd) {
                    setState(() {
                      todoList.todos.remove(todo);
                      _saveToSharedPref();
                    });
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text("${todo.content} dismissed")));
                  },
                  secondaryBackground: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    color: Colors.red,
                  ),
                  background: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    color: Colors.red,
                  ),
                );
              }).toList(),
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  var item = todoList.todos.removeAt(oldIndex);
                  todoList.todos.insert(newIndex, item);
                  _saveToSharedPref();
                });
              },
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
                              todoList.todos.add(Todo(
                                  content: textEditingController.text,
                                  dateTime: DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()).toString()));
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
  bool hideDoneTodo = false;

  List<Todo> get todosForDisplay => hideDoneTodo ? shrinkList : todos;

  List<Todo> get shrinkList => todos.where((todo) => !todo.finished).toList();

  TodoList();

  TodoList.fromJson(Map<String, dynamic> json) {
    if (json['todos'] != null) {
      todos = new List<Todo>();
      json['todos'].forEach((v) {
        todos.add(new Todo.fromJson(v));
      });
    }
    if (json['hideDoneTodo'] != null) {
      hideDoneTodo = json['hideDoneTodo'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.todos != null) {
      data['todos'] = this.todos.map((v) => v.toJson()).toList();
    }
    if (this.hideDoneTodo != null) {
      data['hideDoneTodo'] = hideDoneTodo;
    }
    return data;
  }
}

class Todo {
  String content;
  bool finished;
  String dateTime;

  Todo({this.content, this.finished = false, this.dateTime});

  Todo.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    finished = json['finished'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['finished'] = this.finished;
    data['dateTime'] = this.dateTime;
    return data;
  }
}
