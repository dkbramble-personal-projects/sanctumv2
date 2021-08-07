import 'package:flutter/material.dart';
import 'data/type_values.dart';
import 'data/database_service.dart';
import 'data/models/models.dart';

class ManageTodoForm extends StatefulWidget {
  final Todo? todo;

  const ManageTodoForm(this.todo);

  @override
  ManageTodoFormState createState() {
    return ManageTodoFormState();
  }
}

class ManageTodoFormState extends State<ManageTodoForm> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();

  var isChanging = false;
  bool isEditing = false;
  String formTitle = "New Todo";
  var originalTitle = "";

  String? _selectedType;
  List<String> listOfTypes = TypeValues.getTypeValues();

  void insertRecord(Todo record) async {
    var databaseService = DatabaseService();
    await databaseService.insertRecord(record, 'todos');
  }

  void updateRecord(Todo record) async {
    var databaseService = DatabaseService();
    await databaseService.updateRecord(record, 'todos');
  }

  void deleteRecord(Todo record) async {
    var databaseService = DatabaseService();
    await databaseService.deleteRecord(record, 'todos');
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var todo = widget.todo;

    if (todo != null && !isChanging) {
      isEditing = true;
      formTitle = "Edit Todo";
      titleController.text = todo.title;
      originalTitle = todo.title;

      setState(() {
        isChanging = true;
        _selectedType = todo.type;
      });
    }

    isChanging = false;
    return new AlertDialog(
      title: Row(
        children: [
          Text(formTitle),
          isEditing
              ? TextButton(
            onPressed: () {
              var record = new Todo(
                  title: titleController.text,
                  type: _selectedType ?? "Other");
              deleteRecord(record);
              Navigator.of(context).pop();
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          )
              : Container(),
        ],
      ),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
                DropdownButtonFormField(
                  value: _selectedType,
                  hint: Text('Type'),
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      isChanging = true;
                      _selectedType = value.toString();
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      isChanging = true;
                      _selectedType = value.toString();
                    });
                  },
                  items: listOfTypes.map((String val) {
                    return DropdownMenuItem(value: val, child: Text(val));
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      var record = new Todo(
                          title: titleController.text,
                          type: _selectedType ?? "Other");

                      bool titleChanged = originalTitle != titleController.text;

                      if(titleChanged && todo != null) {
                        deleteRecord(todo);
                      }

                      if (isEditing && !titleChanged) {
                        updateRecord(record);
                      } else {
                        insertRecord(record);
                      }

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
