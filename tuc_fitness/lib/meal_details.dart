import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'alimentatie_page.dart';

class MealDetails {
  final String? firstCourseDescription;
  final String? secondCourseDescription;
  final int id;
  final String name;
  final String description;
  final int startTakingHour;
  final int startTakingMinutes;
  final int calories;

  MealDetails({
    this.firstCourseDescription,
    this.secondCourseDescription,
    required this.id,
    required this.name,
    required this.description,
    required this.startTakingHour,
    required this.startTakingMinutes,
    required this.calories,
  });

  factory MealDetails.fromJson(Map<String, dynamic> json) {
    return MealDetails(
      firstCourseDescription: json['firstCourseDescription'],
      secondCourseDescription: json['secondCourseDescription'],
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startTakingHour: json['startTakingHour'],
      startTakingMinutes: json['startTakingMinutes'],
      calories: json['calories'],
    );
  }
}

class MealDetailsPage extends StatefulWidget {
  final Meal meal;

  const MealDetailsPage({Key? key, required this.meal}) : super(key: key);

  @override
  _MealDetailsPageState createState() => _MealDetailsPageState();
}

class _MealDetailsPageState extends State<MealDetailsPage> {
  late MealDetails mealDetails;

  @override
  void initState() {
    super.initState();
    fetchMealDetails();
  }

  Future<void> fetchMealDetails() async {
    final url = 'https://localhost:7152/api/Meal/${widget.meal.id}';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      mealDetails = MealDetails.fromJson(jsonBody);
      setState(() {});
    }
  }

  Future<void> deleteMeal(BuildContext context) async {
    final url = 'https://localhost:7152/api/Meal/${widget.meal.id}';
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Succes'),
            content: const Text('Masa a fost ștearsă cu succes.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AlimentatiePage(),
                    ),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Eroare'),
            content: const Text('A apărut o eroare în timpul ștergerii mesei.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DETALII MASĂ',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'Gilroy',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/mealDetails.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.55),
          ),
          BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text(
                        'Denumire: ${widget.meal.name}',
                        style: const TextStyle(
                            fontFamily: "Gilroy",
                            fontSize: 25,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text(
                        'Descriere: ${widget.meal.description}',
                        style: const TextStyle(
                            fontFamily: "Gilroy",
                            fontSize: 25,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text(
                        'Ora de începere a mesei: ${widget.meal.startTakingHour}:${widget.meal.startTakingMinutes.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                            fontFamily: "Gilroy",
                            fontSize: 25,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text(
                        'Calorii: ${widget.meal.calories}',
                        style: const TextStyle(
                            fontFamily: "Gilroy",
                            fontSize: 25,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (mealDetails.firstCourseDescription != null && mealDetails.firstCourseDescription!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Text(
                          'Felul 1: ${mealDetails.firstCourseDescription}',
                          style: const TextStyle(
                              fontFamily: "Gilroy",
                              fontSize: 25,
                              color: Colors.white),
                        ),
                      ),
                    const SizedBox(height: 8),
                    if (mealDetails.secondCourseDescription != null && mealDetails.secondCourseDescription!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Text(
                          'Felul 2: ${mealDetails.secondCourseDescription}',
                          style: const TextStyle(
                              fontFamily: "Gilroy",
                              fontSize: 25,
                              color: Colors.white),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                        onPressed: () => deleteMeal(context),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete),
                              SizedBox(width: 8),
                              Text(
                                'ȘTERGE MASA',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'Gilroy',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
