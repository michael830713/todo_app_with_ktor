import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_with_ktor/todo_api.dart';

class CustomListTile extends StatelessWidget {
  CustomListTile({Key key, this.checkBoxOnChanged, this.todo}) : super(key: key);
  final Data todo;
  final Function(bool value) checkBoxOnChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        onChanged: (bool value) => checkBoxOnChanged(value),
        value: todo.completed,
      ),
      title: Text(
        todo.title,
        style: TextStyle(decoration: todo.completed ? TextDecoration.lineThrough : null),
      ),
      subtitle: Text(todo.createdAt),
    );
    ;
  }
}
