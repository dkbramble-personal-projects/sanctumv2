import 'package:flutter/material.dart';
import '../data_table.dart';
import '../data/database_service.dart';
import '../data/models/models.dart';

class Todos extends StatefulWidget {
  @override
  _TodosState createState() => _TodosState();
}

class _TodosState extends State<Todos> {
  List<Todo> _todos = List<Todo>.empty(growable: true);

  @override
  void initState(){
    getTodos();
    super.initState();
  }

  void getTodos() async {
    var databaseService = DatabaseService();
    var todos = await databaseService.getTodos();
    setState(() {
      _todos = todos;
    });
  }

  void _addRecord() async {
    var databaseService = DatabaseService();
    var release = new Todo(title: "Twelve Minutes", type: "Game");
    await databaseService.insertRecord(release, 'todos');
    getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DataTableSanctum(_todos),
      ),
      floatingActionButton: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
          child:
          FloatingActionButton(
              onPressed: _addRecord,
              tooltip: 'Increment',
              child: Icon(Icons.add, color: Colors.white),
              backgroundColor: Color(0xff14C460)
          )
      ),
    );
  }
}