import 'package:flutter/material.dart';
import 'data/type_values.dart';
import 'data/database_service.dart';
import 'data/models/models.dart';

class ManageReleaseForm extends StatefulWidget {
  final Release? release;

  const ManageReleaseForm(this.release);

  @override
  ManageReleaseFormState createState() {
    return ManageReleaseFormState();
  }
}

class ManageReleaseFormState extends State<ManageReleaseForm> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  var isChanging = false;
  bool isChecked = false;
  bool isEditing = false;
  var originalTitle = "";
  String formTitle = "New Release";

  String? _selectedType;
  List<String> listOfTypes = TypeValues.getTypeValues();

  void insertRecord(Release record) async {
    var databaseService = DatabaseService();
    await databaseService.insertRecord(record, 'releases');
  }

  void updateRecord(Release record) async {
    var databaseService = DatabaseService();
    await databaseService.updateRecord(record, 'releases');
  }

  void deleteRecord(Release record) async {
    var databaseService = DatabaseService();
    await databaseService.deleteRecord(record, 'releases');
  }

  void moveToTodo(Release record) async {
    var databaseService = DatabaseService();
    await databaseService.deleteRecord(record, 'releases');
    var todo = new Todo(title: record.title, type: record.type);
    await databaseService.insertRecord(todo, 'todos');
  }

  @override
  void dispose() {
    titleController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var release = widget.release;
    dateController.text = "";

    if (release != null && !isChanging) {
      this.isChecked = release.checkDate == 1;
      isEditing = true;
      formTitle = "Edit Release";
      titleController.text = release.title;
      originalTitle = release.title;

      if (release.releaseDate != -1) {
        var date = DateTime.fromMillisecondsSinceEpoch(release.releaseDate * 1000);
        var dateString = date.toIso8601String().substring(0, 10);

        dateController.text = dateString;
      }

      setState(() {
        isChanging = true;
        _selectedType = release.type;
      });
    }

    isChanging = false;
    return new AlertDialog(
      title: Row(
        children: [
          Text(formTitle),
        ],
      ),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[ TextFormField(
                        controller: titleController,
                        autocorrect: false,
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
                TextFormField(
                  controller: dateController,
                  autocorrect: false,
                  validator: (value) {
                    if (value == null || (value.isNotEmpty && DateTime.tryParse(dateController.text) == null)) {
                      return 'Please enter a date';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: 'Release Date (ex: YYYY-MM-DD)'),
                ),
                Row(
                  children: [
                    Text("Check Date?"),
                    Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          isChanging = true;
                          setState(() {
                            isChecked = value!;
                          });
                        }),
                  ],
                ),
                isEditing
                    ? Row(
                    children: [TextButton(
                      onPressed: () {
                        var date = DateTime.tryParse(dateController.text);
                        var dateVal = date != null ? date.millisecondsSinceEpoch * 1000 : -1;
                        if (date != null){

                        }
                        var record = new Release(
                            title: titleController.text,
                            type: _selectedType ?? "Other",
                            releaseDate: dateVal,
                            checkDate: isChecked ? 1 : 0);
                        deleteRecord(record);
                        Navigator.of(context).pop();
                      },
                      child: Text("Delete", style: TextStyle(color: Colors.red)),
                    ),
                      TextButton(
                        onPressed: () {
                          var record = new Release(
                              title: titleController.text,
                              type: _selectedType ?? "Other",
                              releaseDate: DateTime.parse(dateController.text).millisecondsSinceEpoch * 1000,
                              checkDate: isChecked ? 1 : 0);
                          moveToTodo(record);
                          Navigator.of(context).pop();
                        },
                        child: Text("Move To Todo", style: TextStyle(color: Colors.white)),
                      ),])
                    : Container(),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      var date = DateTime.tryParse(dateController.text)?.toUtc();
                      var dateVal = -1;
                      if (date != null){
                        dateVal = date.millisecondsSinceEpoch ~/ 1000;
                      }
                      var record = new Release(
                          title: titleController.text,
                          type: _selectedType ?? "Other",
                          releaseDate: dateVal,
                          checkDate: isChecked ? 1 : 0);

                      bool titleChanged = originalTitle != titleController.text;

                      if(titleChanged && release != null) {
                        deleteRecord(release);
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
