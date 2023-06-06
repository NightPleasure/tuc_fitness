import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddMealPage extends StatefulWidget {
  final String apiUrl;
  final Map<String, dynamic> initialFormData;

  const AddMealPage({
    required this.apiUrl,
    required this.initialFormData,
  });

  @override
  _AddMealPageState createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _startTakingHourController;
  late final TextEditingController _startTakingMinutesController;
  late final TextEditingController _caloriesController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.initialFormData['name']);
    _descriptionController = TextEditingController(text: widget.initialFormData['description']);
    _startTakingHourController = TextEditingController(text: widget.initialFormData['startTakingHour'].toString());
    _startTakingMinutesController = TextEditingController(text: widget.initialFormData['startTakingMinutes'].toString());
    _caloriesController = TextEditingController(text: widget.initialFormData['calories'].toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _startTakingHourController.dispose();
    _startTakingMinutesController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  Future<void> _saveMeal() async {
     final formData = {
       'name': _nameController.text,
       'description': _descriptionController.text,
       'startTakingHour': int.parse(_startTakingHourController.text),
       'startTakingMinutes': int.parse(_startTakingMinutesController.text),
       'calories': int.parse(_caloriesController.text),
     };
     final response = await http.post(Uri.parse(widget.apiUrl), body: jsonEncode(formData));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adăugare masă'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nume',
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Descriere',
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _startTakingHourController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Ora începerii',
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _startTakingMinutesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Minute începere',
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _caloriesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Calorii',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveMeal,
              child: Text('Salvează masă'),
            ),
          ],
        ),
      ),
    );
  }
}
