import 'package:flutter/material.dart';
import 'data/type_values.dart';
import 'data/database_service.dart';
import 'data/models/models.dart';

class ManageRumorForm extends StatefulWidget {
  final Rumor? rumor;

  const ManageRumorForm(this.rumor);

  @override
  ManageRumorFormState createState() {
    return ManageRumorFormState();
  }
}

class ManageRumorFormState extends State<ManageRumorForm> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  var isChanging = false;
  bool isEditing = false;
  var originalTitle = "";
  String formTitle = "New Rumor";

  String? _selectedType;
  List<String> listOfTypes = TypeValues.getTypeValues();

  void insertRecord(Rumor record) async {
    var databaseService = DatabaseService();
    await databaseService.insertRecord(record, 'rumors');
  }

  void updateRecord(Rumor record) async {
    var databaseService = DatabaseService();
    await databaseService.updateRecord(record, 'rumors');
  }

  void deleteRecord(Rumor record) async {
    var databaseService = DatabaseService();
    await databaseService.deleteRecord(record, 'rumors');
  }

  @override
  void dispose() {
    titleController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var rumor = widget.rumor;

    if (rumor != null && !isChanging) {
      isEditing = true;
      formTitle = "Edit Rumor";
      titleController.text = rumor.title;
      originalTitle = rumor.title;
      dateController.text = rumor.releaseWindow ?? "";

      setState(() {
        isChanging = true;
        _selectedType = rumor.type;
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
              var record = new Rumor(
                  title: titleController.text,
                  type: _selectedType ?? "Other",
                  releaseWindow: dateController.text);
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
                TextFormField(
                  controller: dateController,
                  decoration: InputDecoration(
                      hintText: 'Rumor Date (ex: YYYY-MM-DD)'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      var record = new Rumor(
                          title: titleController.text,
                          type: _selectedType ?? "Other",
                          releaseWindow: dateController.text);

                      bool titleChanged = originalTitle != titleController.text;

                      if(titleChanged && rumor != null) {
                        deleteRecord(rumor);
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
