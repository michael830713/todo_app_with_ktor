import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_with_ktor/custom_listtile.dart';
import 'package:todo_app_with_ktor/todo.dart';

import 'delete_background.dart';

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
  TodoList todoList;

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

  void _reorderList(int newIndex, int oldIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    var item = todoList.todos.removeAt(oldIndex);
    todoList.todos.insert(newIndex, item);
    _saveToSharedPref();
  }

  void _addNewTodo(BuildContext context) {
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
                  onPressed: () => Navigator.of(context).pop(),
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
  }

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
            onPressed: () => _hideDoneTodo(hideDone: !todoList.hideDoneTodo),
          )
        ],
        centerTitle: true,
        title: Center(child: Text(widget.title)),
      ),
      body: todoList != null
          ? ReorderableListView(
              children: todoList.todosForDisplay.map((todo) {
                return CustomListTile(
                  key: UniqueKey(),
                  todo: todo,
                  onDismissed: () => setState(() {
                    todoList.todos.remove(todo);
                    _saveToSharedPref();
                  }),
                  checkBoxOnChanged: (value) => setState(() {
                    todo.finished = value;
                    _saveToSharedPref();
                  }),
                );
              }).toList(),
              onReorder: (int oldIndex, int newIndex) => setState(() => _reorderList(newIndex, oldIndex)),
            )
          : Center(
              child: Text('Loading...'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNewTodo(context);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
