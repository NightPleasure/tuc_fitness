import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Exercise {
  final String name;
  final String description;
  final int startDoingHour;
  final int startDoingMinutes;
  final int durationInSeconds;

  Exercise({
    required this.name,
    required this.description,
    required this.startDoingHour,
    required this.startDoingMinutes,
    required this.durationInSeconds,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'startDoingHour': startDoingHour,
      'startDoingMinutes': startDoingMinutes,
      'durationInSeconds': durationInSeconds,
    };
  }
}

class AddExercisePage extends StatefulWidget {
  const AddExercisePage({super.key});

  @override
  _AddExercisePageState createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController hourController = TextEditingController();
  final TextEditingController minutesController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  bool _nameValid = true;
  bool _descriptionValid = true;
  bool _hourValid = true;
  bool _minutesValid = true;
  bool _durationValid = true;

  Future<void> saveExercise() async {
    setState(() {
      _nameValid = nameController.text.isNotEmpty;
      _descriptionValid = descriptionController.text.isNotEmpty;
      _hourValid = hourController.text.isNotEmpty &&
          int.tryParse(hourController.text) != null &&
          int.parse(hourController.text) >= 0 &&
          int.parse(hourController.text) < 24;
      _minutesValid = minutesController.text.isNotEmpty &&
          int.tryParse(minutesController.text) != null &&
          int.parse(minutesController.text) >= 0 &&
          int.parse(minutesController.text) < 60;
      _durationValid = durationController.text.isNotEmpty &&
          int.tryParse(durationController.text) != null &&
          int.parse(durationController.text) > 0;
    });

    if (_nameValid &&
        _descriptionValid &&
        _hourValid &&
        _minutesValid &&
        _durationValid) {
      var exercise = Exercise(
        name: nameController.text,
        description: descriptionController.text,
        startDoingHour: int.parse(hourController.text),
        startDoingMinutes: int.parse(minutesController.text),
        durationInSeconds: int.parse(durationController.text),
      );

      var headers = {'Content-Type': 'application/json'};

      var response = await http.post(
        Uri.parse('https://localhost:7152/api/Exercise'),
        headers: headers,
        body: jsonEncode(exercise.toJson()),
      );

      if (response.statusCode == 200) {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text('Notificare'),
              content: const Text('Exercițiul a fost salvat cu succes!'),
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
        print('Eroare la salvarea exercițiului: ${response.statusCode}');
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    hourController.dispose();
    minutesController.dispose();
    durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ADAUGARE EXERCIȚIU',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Gilroy',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/sport2add.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Builder(
            builder: (context) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Denumirea',
                          labelStyle: const TextStyle(color: Colors.black),
                          errorText: _nameValid ? null : 'Câmp obligatoriu',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Descriere',
                          labelStyle: const TextStyle(color: Colors.black),
                          errorText:
                          _descriptionValid ? null : 'Câmp obligatoriu',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: hourController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]'),
                                ),
                              ],
                              decoration: InputDecoration(
                                labelText: 'Ora',
                                labelStyle: const TextStyle(color: Colors.black),
                                errorText: _hourValid
                                    ? null
                                    : 'Introduceți o oră validă (0-23)',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: minutesController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]'),
                                ),
                              ],
                              decoration: InputDecoration(
                                labelText: 'Minute',
                                labelStyle: const TextStyle(color: Colors.black),
                                errorText: _minutesValid
                                    ? null
                                    : 'Introduceți minute valide (0-59)',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: durationController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9]'),
                          ),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Durată (în secunde)',
                          labelStyle: const TextStyle(color: Colors.black),
                          errorText:
                          _durationValid ? null : 'Câmp obligatoriu',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: saveExercise,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(
                            vertical: 30.0,
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
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
