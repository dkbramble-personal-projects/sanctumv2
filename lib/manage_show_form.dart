import 'package:flutter/material.dart';
import 'data/type_values.dart';
import 'data/database_service.dart';
import 'data/models/models.dart';

class ManageOngoingShowForm extends StatefulWidget {
  final OngoingShow? ongoingShow;

  const ManageOngoingShowForm(this.ongoingShow);

  @override
  ManageOngoingShowFormState createState() {
    return ManageOngoingShowFormState();
  }
}

class ManageOngoingShowFormState extends State<ManageOngoingShowForm> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();

  bool isEditing = false;
  String formTitle = "New Show";

  void insertRecord(OngoingShow record) async {
    var databaseService = DatabaseService();
    await databaseService.insertRecord(record, 'ongoingShows');
  }

  void updateRecord(OngoingShow record) async {
    var databaseService = DatabaseService();
    await databaseService.updateRecord(record, 'ongoingShows');
  }

  void deleteRecord(OngoingShow record) async {
    var databaseService = DatabaseService();
    await databaseService.deleteRecord(record, 'ongoingShows');
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var ongoingShow = widget.ongoingShow;

    if (ongoingShow != null) {
      isEditing = true;
      formTitle = "";
      titleController.text = ongoingShow.title;
    }

    return new AlertDialog(
      title: Row(
        children: [
          Text(formTitle),
          isEditing ? TextButton(
            onPressed: () {
              var record = new OngoingShow(title: titleController.text);
              deleteRecord(record);
              Navigator.of(context).pop();
            },
            child: Text("Delete?", style: TextStyle(color: Colors.red)),
          )  : Container()
        ],
      ),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          isEditing ? Container() :
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration: InputDecoration(hintText: 'Title'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      var record = new OngoingShow(title: titleController.text);
                      insertRecord(record);

                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
