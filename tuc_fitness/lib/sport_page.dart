import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'add_exercise.dart';
import 'exercise_details.dart';

Future<List<Exercise>> fetchExercises() async {
  final response = await http.get(Uri.parse('https://localhost:7152/api/Exercise'));
  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = jsonDecode(response.body);
    List<Exercise> exercises = [];

    for (var exerciseData in jsonResponse) {
      Exercise exercise = Exercise.fromJson(exerciseData);
      exercises.add(exercise);
    }
    return exercises;
  } else {
    throw Exception('Failed to load exercises');
  }
}

class Exercise {
  final int id;
  final String name;
  final String description;
  final int startDoingHour;
  final int startDoingMinutes;
  final int durationInSeconds;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.startDoingHour,
    required this.startDoingMinutes,
    required this.durationInSeconds,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startDoingHour: json['startDoingHour'],
      startDoingMinutes: json['startDoingMinutes'],
      durationInSeconds: json['durationInSeconds'],
    );
  }
}

class SportPage extends StatefulWidget {
  @override
  _SportPageState createState() => _SportPageState();
}

class _SportPageState extends State<SportPage> {
  Future<List<Exercise>>? _futureExercises;

  @override
  void initState() {
    super.initState();
    _futureExercises = fetchExercises();
    loadFont();
  }

  Future<void> loadFont() async {
    await Future.wait([
      // Încarcă fontul Gilroy
      rootBundle.load('assets/fonts/gilroy_regular.ttf'),
    ]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _futureExercises = fetchExercises();
  }

  Future<void> navigateToAddExercisePage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExercisePage(),
      ),
    );
    setState(() {
      _futureExercises = fetchExercises();
    });
  }

  Future<void> navigateToExerciseDetailsPage(Exercise exercise) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseDetailsPage(exercise: exercise),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        elevation: 0,
        title: Text(
          'EXERCIȚII',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
              fontFamily: 'Gilroy',
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/sport.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/sport.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            FutureBuilder<List<Exercise>>(
              future: _futureExercises,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  List<Exercise> exercises = snapshot.data!;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: exercises.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                navigateToExerciseDetailsPage(exercises[index]);
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30.0),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
                                    child: Container(
                                      height: 120,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                      ),
                                      child: Center(
                                        child: Text(
                                          exercises[index].name,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: 'Gilroy',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30.0),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
                              child: Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                child: InkWell(
                                  onTap: navigateToAddExercisePage,
                                  child: Center(
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white.withOpacity(1),
                                      size: 48 * 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Text('No exercises found'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
