import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_with_ktor/todo.dart';

import 'delete_background.dart';

class CustomListTile extends StatelessWidget {
  CustomListTile({Key key, this.checkBoxOnChanged, this.onDismissed, this.todo}) : super(key: key);
  final Todo todo;
  final Function(bool value) checkBoxOnChanged;
  final Function() onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      child: ListTile(
        leading: Checkbox(
          onChanged: (bool value) {
            checkBoxOnChanged(value);
          },
          value: todo.finished,
        ),
        trailing: Icon(Icons.drag_handle),
        title: Text(
          todo.content,
          style: TextStyle(decoration: todo.finished ? TextDecoration.lineThrough : null),
        ),
        subtitle: Text(todo.dateTime ?? ''),
      ),
      key: key,
      onDismissed: (ddd) {
        onDismissed();

        Scaffold.of(context).showSnackBar(SnackBar(content: Text("${todo.content} dismissed")));
      },
      background: DeleteBackground(
        mainAxisAlignment: MainAxisAlignment.start,
      ),
      secondaryBackground: DeleteBackground(
        mainAxisAlignment: MainAxisAlignment.end,
      ),
    );
    ;
  }
}
