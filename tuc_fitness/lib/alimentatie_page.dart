import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'add_meal.dart';
import 'meal_details.dart';

Future<List<Meal>> fetchMeals() async {
  final response = await http.get(Uri.parse('https://localhost:7152/api/Meal/sorted?sortType=0'));
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

  Meal({
    required this.id,
    required this.name,
    required this.description,
    required this.startTakingHour,
    required this.startTakingMinutes,
    required this.calories,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startTakingHour: json['startTakingHour'],
      startTakingMinutes: json['startTakingMinutes'],
      calories: json['calories'],
    );
  }
}

class AlimentatiePage extends StatefulWidget {
  @override
  _AlimentatiePageState createState() => _AlimentatiePageState();
}

class _AlimentatiePageState extends State<AlimentatiePage> {
  late Future<List<Meal>> _futureMeals;

  @override
  void initState() {
    super.initState();
    _futureMeals = fetchMeals();
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
    _futureMeals = fetchMeals();
  }

  Future<void> ChoseAddMealPage() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alegeți tipul de masă'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                navigateToAddMealPage(0);
              },
              child: Text('MIC DEJUN'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                navigateToAddMealPage(1);
              },
              child: Text('PRÂNZ'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                navigateToAddMealPage(2);
              },
              child: Text('CINĂ'),
            ),
          ],
        );
      },
    );
    setState(() {
      _futureMeals = fetchMeals();
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
          'startTakingHour': 0,
          'startTakingMinutes': 0,
          'calories': 0,
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
          'startTakingHour': 0,
          'startTakingMinutes': 0,
          'calories': 0,
        };
        break;
      case 2:
        apiUrl = 'https://localhost:7152/api/Meal?mealType=2';
        initialFormData = {
          'id': 0,
          'name': '',
          'description': '',
          'startTakingHour': 0,
          'startTakingMinutes': 0,
          'calories': 0,
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
        _futureMeals = fetchMeals();
      });
    });
  }


  Future<void> navigateToMealDetailsPage(Meal meal) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealDetailsPage(meal: meal)
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
          'MESE',
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
            image: AssetImage('assets/images/meals.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/meals.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            FutureBuilder<List<Meal>>(
              future: _futureMeals,
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
                  List<Meal> meals = snapshot.data!;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: meals.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                navigateToMealDetailsPage(meals[index]);
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
                                          meals[index].name,
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
                                  onTap: () {
                                    ChoseAddMealPage();
                                  },
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
                    child: Text('No meals found'),
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

