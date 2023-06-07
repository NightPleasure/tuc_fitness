import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'add_exercise.dart';
import 'exercise_details.dart';

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDoingHour': startDoingHour,
      'startDoingMinutes': startDoingMinutes,
      'durationInSeconds': durationInSeconds,
    };
  }
}

class ExerciseProxy {
  List<Exercise> exercises = [];

  Future<List<Exercise>> getExercises() async {
    if (exercises.isEmpty) {
      await fetchExercises();
    }
    return exercises;
  }

  Future<void> addExercise(Exercise exercise) async {
    var headers = {'Content-Type': 'application/json'};
    var response = await http.post(
      Uri.parse('https://localhost:7152/api/Exercise'),
      headers: headers,
      body: jsonEncode(exercise.toJson()),
    );

    if (response.statusCode == 200) {
      await fetchExercises();
    } else {
      print('Error saving exercise: ${response.statusCode}');
    }
  }

  Future<void> fetchExercises() async {
    var response = await http.get(Uri.parse('https://localhost:7152/api/Exercise'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      exercises = List<Exercise>.from(data.map((exercise) {
        return Exercise.fromJson(exercise);
      }));
    } else {
      print('Error fetching exercises: ${response.statusCode}');
    }
  }
}

class SportPage extends StatefulWidget {
  const SportPage({super.key});

  @override
  _SportPageState createState() => _SportPageState();
}

class _SportPageState extends State<SportPage> {
  ExerciseProxy exerciseProxy = ExerciseProxy();

  @override
  void initState() {
    super.initState();
    fetchExercises();
    loadFont();
  }

  Future<void> loadFont() async {
    await Future.wait([
      rootBundle.load('assets/fonts/gilroy_regular.ttf'),
    ]);
  }

  Future<void> fetchExercises() async {
    await exerciseProxy.fetchExercises();
    setState(() {});
  }

  Future<void> navigateToAddExercisePage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExercisePage(),
      ),
    );
    fetchExercises();
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
        title: const Text(
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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/sport.jpg'),
            fit: BoxFit.cover,
          ),
        ),

        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/sport.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            FutureBuilder<List<Exercise>>(
              future: exerciseProxy.getExercises(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
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
                        const SizedBox(height: 8.0),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: exercises.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                navigateToExerciseDetailsPage(exercises[index]);
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                                          style: const TextStyle(
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
                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                  return const Center(
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
