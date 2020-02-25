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
