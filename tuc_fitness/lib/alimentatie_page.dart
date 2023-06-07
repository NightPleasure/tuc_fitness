import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'add_meal.dart';
import 'meal_details.dart';

Future<List<Meal>> fetchMeals({int sortType = 0}) async {
  final response = await http.get(Uri.parse('https://localhost:7152/api/Meal/sorted?sortType=$sortType'));
  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = jsonDecode(response.body);
    List<Meal> meals = [];

    for (var mealData in jsonResponse) {
      Meal meal = Meal.fromJson(mealData);
      meals.add(meal);
    }
    return meals;
  } else {
    throw Exception('Failed to load meals');
  }
}

class Meal {
  final int id;
  final String name;
  final String description;
  final int startTakingHour;
  final int startTakingMinutes;
  final int calories;
  final String firstCourseDescription;
  final String secondCourseDescription;


  Meal({

    required this.id,
    required this.name,
    required this.description,
    required this.startTakingHour,
    required this.startTakingMinutes,
    required this.calories,
    this.firstCourseDescription = '',
    this.secondCourseDescription = '',
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startTakingHour: json['startTakingHour'],
      startTakingMinutes: json['startTakingMinutes'],
      calories: json['calories'],
      firstCourseDescription: json['firstCourseDescription'] ?? "",
      secondCourseDescription: json['secondCourseDescription'] ?? "",
    );
  }
}

class AlimentatiePage extends StatefulWidget {
  const AlimentatiePage({super.key});

  @override
  _AlimentatiePageState createState() => _AlimentatiePageState();
}

class _AlimentatiePageState extends State<AlimentatiePage> {
  late Future<List<Meal>> _futureMeals;
  int sortType = 0;

  @override
  void initState() {
    super.initState();
    _futureMeals = fetchMeals(sortType: sortType);
    loadFont();
  }

  Future<void> loadFont() async {
    await Future.wait([
      rootBundle.load('assets/fonts/gilroy_regular.ttf'),
    ]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _futureMeals = fetchMeals(sortType: sortType);
  }

  Future<void> ChoseAddMealPage() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: const EdgeInsets.all(25),
          title: const Text(
            'Alegeți tipul de masă',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: 'Gilroy',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                navigateToAddMealPage(0);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              child: const Text(
                  'MIC DEJUN',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontFamily: 'Gilroy',
                  ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                navigateToAddMealPage(1);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              child: const Text(
                'PRÂNZ',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontFamily: 'Gilroy',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                navigateToAddMealPage(2);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              child: const Text(
                  'CINĂ',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontFamily: 'Gilroy',
                  ),
                ),
            ),
          ],
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
          ),
          backgroundColor: Colors.white.withOpacity(0.9),
        );
      },
    );
    setState(() {
      _futureMeals = fetchMeals(sortType: sortType);
    });
  }

  Future<void> navigateToAddMealPage(int mealType) async {
    String apiUrl;
    Map<String, dynamic> initialFormData;

    switch (mealType) {
      case 0:
        apiUrl = 'https://localhost:7152/api/Meal?mealType=0';
        initialFormData = {
          'id': 0,
          'name': '',
          'description': '',
          'startTakingHour': '',
          'startTakingMinutes': '',
          'calories': '',
        };
        break;
      case 1:
        apiUrl = 'https://localhost:7152/api/Meal?mealType=1';
        initialFormData = {
          'firstCourseDescription': '',
          'secondCourseDescription': '',
          'id': 0,
          'name': '',
          'description': '',
          'startTakingHour': '',
          'startTakingMinutes': '',
          'calories': '',
        };
        break;
      case 2:
        apiUrl = 'https://localhost:7152/api/Meal?mealType=2';
        initialFormData = {
          'id': 0,
          'name': '',
          'description': '',
          'startTakingHour': '',
          'startTakingMinutes': '',
          'calories': '',
        };
        break;
      default:
        throw Exception('Invalid meal type');
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMealPage(apiUrl: apiUrl, initialFormData: initialFormData),
      ),
    ).then((value) {
      setState(() {
        _futureMeals = fetchMeals(sortType: sortType);
      });
    });
  }

  Future<void> navigateToMealDetailsPage(Meal meal) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealDetailsPage(meal: meal),
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
          'MESE',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'Gilroy',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              setState(() {
                sortType = (sortType + 1) % 4;
                _futureMeals = fetchMeals(sortType: sortType);
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/meals.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/meals.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              color: Colors.black.withOpacity(0.4),
            ),
            FutureBuilder<List<Meal>>(
              future: _futureMeals,
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
                  List<Meal> meals = snapshot.data!;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: meals.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                navigateToMealDetailsPage(meals[index]);
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    color: Colors.white.withOpacity(0.2),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          meals[index].name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontFamily: 'Gilroy',
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          meals[index].description,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontFamily: 'Gilroy',
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Calorii: ${meals[index].calories}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontFamily: 'Gilroy',
                                              ),
                                            ),
                                            Text(
                                              'Ora: ${meals[index].startTakingHour}:${meals[index].startTakingMinutes}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontFamily: 'Gilroy',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 64, // Aici poți ajusta lățimea butonului
        height: 64, // Aici poți ajusta înălțimea butonului
        child: FloatingActionButton(
          onPressed: () {
            ChoseAddMealPage();
          },
          backgroundColor: Colors.amberAccent,
          child: const Icon(
              Icons.add,
            size: 60,
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const AlimentatiePage(),
    );
  }
}
