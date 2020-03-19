import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:todo_app_with_ktor/custom_listtile.dart';
import 'package:todo_app_with_ktor/todo_api.dart';

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
  TodoResponse todoList;

  void _fetchFromApi() async {
    var url = 'https://ktor-gcp-practice1.appspot.com/api/tasks';
    var response = await http.get(url);
    if (response.statusCode == 200) setState(() => todoList = TodoResponse.fromJson(jsonDecode(response.body)));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  @override
  void didChangeDependencies() {
    _fetchFromApi();

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
              itemCount: todoList.data.length,
              itemBuilder: (BuildContext context, int index) {
                return CustomListTile(
                  todo: todoList.data[index],
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
