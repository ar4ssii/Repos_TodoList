import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

void main() async{
  await Hive.initFlutter();
  var box = await Hive.openBox('database');

  runApp(MaterialApp(home:MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {
  var box = Hive.box('database');
  void addData() async{

    box.put('name', 'David');

    print('Name: ${box.get('name')}');
  }

  @override
  void initState() {
    addData();
    super.initState();
  }

  final List<String> todoList = [];
  void addToDo() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add Todo'),
            content: TextField(
              decoration: InputDecoration(labelText: 'Enter Todo'),
              onSubmitted: (value) {
                setState(() {
                  todoList.add(value);
                });

                Navigator.pop(context);
              },
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    todoList.add('New Todo');
                  });
                  Navigator.pop(context);
                },
                child: Text('Add'),
              ),
            ],
          );
        },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFADBC9F),
        title: Text('ToDo List'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          // display this if there is no data
          // Center(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text('No Data')
          //     ],
          //   ),
          // ),

          // item1
          Container(
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
                      value: false, // Set your checkbox value here
                      onChanged: (newValue) {
                        // Handle checkbox onChanged event here
                      },
                    ),
                    SizedBox(width: 10),
                    // Add spacing between Checkbox and Text
                    Text(
                      "${box.get('name')}",
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    // Handle delete button onPressed event here
                  },
                  icon: Icon(Icons.delete),
                  color: Colors.red, // Set delete button color
                ),
              ],
            ),
          ),

          // item2
          Container(
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
                      value: false, // Set your checkbox value here
                      onChanged: (newValue) {
                        // Handle checkbox onChanged event here
                      },
                    ),
                    SizedBox(width: 10),
                    // Add spacing between Checkbox and Text
                    Text(
                      "Todo 2",
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    // Handle delete button onPressed event here
                  },
                  icon: Icon(Icons.delete),
                  color: Colors.red, // Set delete button color
                ),
              ],
            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addToDo,
        tooltip: 'Add To Do',
        child: const Icon(Icons.add),
      ),
    );
  }
}
