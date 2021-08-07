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

      var date = DateTime.fromMillisecondsSinceEpoch(release.releaseDate * 1000);
      var monthString = date.month.toString();
      var dayString = date.day.toString();

      if (monthString.length == 1) monthString = "0" + monthString;
      if (dayString.length == 1) dayString = "0" + dayString;
      dateController.text = date.year.toString() + "-" + monthString + "-" + dayString;

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
          isEditing
              ? TextButton(
                  onPressed: () {
                    var record = new Release(
                        title: titleController.text,
                        type: _selectedType ?? "Other",
                        releaseDate: DateTime.parse(dateController.text).millisecondsSinceEpoch * 1000,
                        checkDate: isChecked ? 1 : 0);
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
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      var date = DateTime.tryParse(dateController.text);
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
