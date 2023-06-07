import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class AddMealPage extends StatefulWidget {
  final String apiUrl;
  final Map<String, dynamic> initialFormData;

  const AddMealPage({
    Key? key,
    required this.apiUrl,
    required this.initialFormData,
  }) : super(key: key);

  @override
  _AddMealPageState createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _startTakingHourController;
  late final TextEditingController _startTakingMinutesController;
  late final TextEditingController _caloriesController;

  // Additional controllers for the new fields
  late final TextEditingController _firstCourseDescriptionController;
  late final TextEditingController _secondCourseDescriptionController;

  @override
  void initState() {
    super.initState();

    _nameController =
        TextEditingController(text: widget.initialFormData['name']);
    _descriptionController =
        TextEditingController(text: widget.initialFormData['description']);
    _startTakingHourController = TextEditingController(
        text: widget.initialFormData['startTakingHour'].toString());
    _startTakingMinutesController = TextEditingController(
        text: widget.initialFormData['startTakingMinutes'].toString());
    _caloriesController = TextEditingController(
        text: widget.initialFormData['calories'].toString());

    // Initialize the new controllers
    _firstCourseDescriptionController = TextEditingController(
        text: widget.initialFormData['firstCourseDescription'] ?? '');
    _secondCourseDescriptionController = TextEditingController(
        text: widget.initialFormData['secondCourseDescription'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _startTakingHourController.dispose();
    _startTakingMinutesController.dispose();
    _caloriesController.dispose();
    _firstCourseDescriptionController.dispose();
    _secondCourseDescriptionController.dispose();
    super.dispose();
  }

  bool validateFields() {
    final startTakingHour = int.tryParse(_startTakingHourController.text);
    final startTakingMinutes = int.tryParse(_startTakingMinutesController.text);
    final calories = int.tryParse(_caloriesController.text);

    if (startTakingHour == null ||
        startTakingHour < 0 ||
        startTakingHour > 23) {
      showValidationError('Ora de începere nu este validă');
      return false;
    }

    if (startTakingMinutes == null ||
        startTakingMinutes < 0 ||
        startTakingMinutes > 59) {
      showValidationError('Minutele de începere nu sunt valide');
      return false;
    }

    if (calories == null) {
      showValidationError('Numărul de calorii nu este valid');
      return false;
    }

    return true;
  }

  void showValidationError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eroare de validare'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveMeal() async {
    if (!validateFields()) {
      return;
    }

    final formData = {
      'name': _nameController.text,
      'description': _descriptionController.text,
      'startTakingHour': int.parse(_startTakingHourController.text),
      'startTakingMinutes': int.parse(_startTakingMinutesController.text),
      'calories': int.parse(_caloriesController.text),
      'firstCourseDescription': _firstCourseDescriptionController.text,
      // Add the new field values to the form data
      'secondCourseDescription': _secondCourseDescriptionController.text,
    };

    final response = await http.post(
      Uri.parse(widget.apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(formData),
    );

    if (response.statusCode == 200) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Notificare'),
            content: const Text('Bucatele au fost salvate cu succes!'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const FitnessApp()),
                        (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          );
        },
      );
    } else {
      print('Eroare la salvarea retetei: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ADĂUGARE MASĂ',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Gilroy',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/addmeal.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                CupertinoTextField(
                  controller: _nameController,
                  placeholder: 'Nume',
                  placeholderStyle: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Color.fromRGBO(255, 255, 255, 0.6),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: _descriptionController,
                  placeholder: 'Descriere',
                  placeholderStyle: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Color.fromRGBO(255, 255, 255, 0.6),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: CupertinoTextField(
                        controller: _startTakingHourController,
                        keyboardType: TextInputType.number,
                        placeholder: 'Ora',
                        placeholderStyle: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Color.fromRGBO(255, 255, 255, 0.6),
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CupertinoTextField(
                        controller: _startTakingMinutesController,
                        keyboardType: TextInputType.number,
                        placeholder: 'Minute',
                        placeholderStyle: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Color.fromRGBO(255, 255, 255, 0.6),
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: _caloriesController,
                  keyboardType: TextInputType.number,
                  placeholder: 'Calorii',
                  placeholderStyle: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Color.fromRGBO(255, 255, 255, 0.6),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                if (widget.apiUrl == 'https://localhost:7152/api/Meal?mealType=1')
                  Column(
                    children: [
                      const SizedBox(height: 8),
                      CupertinoTextField(
                        controller: _firstCourseDescriptionController,
                        placeholder: 'Descriere felul I',
                        placeholderStyle: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Color.fromRGBO(255, 255, 255, 0.6),
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      const SizedBox(height: 8),
                      CupertinoTextField(
                        controller: _secondCourseDescriptionController,
                        placeholder: 'Descriere felul II',
                        placeholderStyle: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Color.fromRGBO(255, 255, 255, 0.6),
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveMeal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  child: const Text(
                    'Salvează',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
