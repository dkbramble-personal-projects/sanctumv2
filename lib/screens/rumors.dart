import 'package:flutter/material.dart';
import '../data_table.dart';
import '../data/database_service.dart';
import '../data/models/models.dart';
import '../manage_rumor_form.dart';

class Rumors extends StatefulWidget {
  @override
  _RumorsState createState() => _RumorsState();
}

class _RumorsState extends State<Rumors> {
  List<Rumor> _rumors = List<Rumor>.empty(growable: true);

  @override
  void initState(){
    getRumors();
    super.initState();
  }

  void getRumors() async {
    var databaseService = DatabaseService();
    var rumors = await databaseService.getRumors();
    setState(() {
      _rumors = rumors;
    });
  }

  @override
  Widget build(BuildContext context) {
    var callback = () => getRumors();
    return Scaffold(
      body: Center(
        child: DataTableSanctum(_rumors, callback),
      ),
      floatingActionButton: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
          child:
          FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => ManageRumorForm(null)
                ).then((_) => getRumors());
              },
              child: Icon(Icons.add, color: Colors.white),
              backgroundColor: Color(0xff14C460)
          )
      ),
    );
  }
}