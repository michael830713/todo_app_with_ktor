import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

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
  List<TodoItems> list = [
    TodoItems(content: 'test', finished: false),
    TodoItems(content: 'test', finished: false),
    TodoItems(content: 'test', finished: false),
    TodoItems(content: 'test', finished: false),
    TodoItems(content: 'test', finished: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Center(child: Text(widget.title)),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          TodoItems todoItems = list[index];
          return Dismissible(
            child: ListTile(
              leading: Checkbox(
                onChanged: (bool value) {
                  setState(() {
                    todoItems.finished = value;
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
                list.removeAt(index);
              });
              Scaffold.of(context).showSnackBar(SnackBar(content: Text("${todoItems.content} dismissed")));
            },
            background: Container(
              color: Colors.red,
            ),
          );
        },
        itemCount: list.length,
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
                            list.add(TodoItems(content: textEditingController.text));
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

class TodoItems {
  TodoItems({this.content, this.finished = false});

  String content;

  bool finished;
}
