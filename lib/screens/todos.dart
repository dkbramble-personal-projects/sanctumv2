import 'package:flutter/material.dart';
import '../data_table.dart';
import '../data/database_service.dart';
import '../data/models/models.dart';
import '../manage_todo_form.dart';

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

  @override
  Widget build(BuildContext context) {
    var callback = () => getTodos();
    return Scaffold(
      body: Center(
        child: DataTableSanctum(_todos, callback),
      ),
      floatingActionButton: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
          child:
          FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => ManageTodoForm(null)
                ).then((_) => getTodos());
              },
              child: Icon(Icons.add, color: Colors.white),
              backgroundColor: Color(0xff14C460)
          )
      ),
    );
  }
}