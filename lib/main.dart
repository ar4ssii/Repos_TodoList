import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<String>('todos');
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Box<String> todoBox;

  @override
  void initState() {
    super.initState();
    todoBox = Hive.box('todos');
  }

  void addToDo() {
    TextEditingController todoController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Todo'),
          content: TextField(
            controller: todoController,
            decoration: InputDecoration(labelText: 'Enter Todo'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final text = todoController.text;
                if (text.isNotEmpty) {
                  final newTodo = Todo(description: text, isDone: false);
                  todoBox.add(json.encode(newTodo.toJson()));
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void deleteToDo(int index) {
    todoBox.deleteAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFADBC9F),
        title: Text('ToDo List'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: todoBox.listenable(),
        builder: (context, Box<String> box, _) {
          if (box.values.isEmpty) {
            return Center(child: Text("No Data"));
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final todoJson = box.getAt(index);
              if (todoJson != null) {
                try {
                  final todo = Todo.fromJson(json.decode(todoJson));
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: todo.isDone,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  todo.isDone = newValue ?? false;
                                  todoBox.putAt(index, json.encode(todo.toJson()));
                                });
                              },
                            ),
                            SizedBox(width: 10),
                            Text(
                              todo.description,
                              style: TextStyle(
                                decoration: todo.isDone ? TextDecoration.lineThrough : null,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => deleteToDo(index),
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                        ),
                      ],
                    ),
                  );
                } catch (e) {
                  print("Error decoding todo at index $index: $e");
                }
              }
              return SizedBox.shrink();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addToDo,
        tooltip: 'Add To Do',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Todo {
  String description;
  bool isDone;

  Todo({
    required this.description,
    required this.isDone,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'isDone': isDone,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      description: json['description'],
      isDone: json['isDone'],
    );
  }
}
