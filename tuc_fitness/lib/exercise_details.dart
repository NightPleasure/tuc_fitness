import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'sport_page.dart';

class TimerWidget extends StatefulWidget {
  final int durationInSeconds;

  const TimerWidget({super.key, required this.durationInSeconds});

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late int _remainingSeconds;
  late bool _isRunning;
  late bool _isPaused;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationInSeconds;
    _isRunning = false;
    _isPaused = false;
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _isPaused = false;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (_isRunning && !_isPaused) {
        setState(() {
          _remainingSeconds--;
        });

        if (_remainingSeconds > 0) {
          _startTimer();
        }
      }
    });
  }

  void _resetTimer() {
    setState(() {
      _remainingSeconds = widget.durationInSeconds;
      _isRunning = false;
      _isPaused = false;
    });
  }

  void _pauseTimer() {
    setState(() {
      _isRunning = false;
      _isPaused = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    String minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    String seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber.withOpacity(0.9), Colors.deepOrangeAccent.withOpacity(0.9)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Timp rămas:',
            style: TextStyle(
              fontSize: 25.0,
              color: Colors.white,
              fontFamily: 'Gilroy',
            ),
          ),
          Text.rich(
            TextSpan(
              text: minutes,
              style: const TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Gilroy',
              ),
              children: <InlineSpan>[
                TextSpan(
                  text: ':$seconds',
                  style: const TextStyle(
                    fontSize: 50.0,
                    color: Colors.white,
                    fontFamily: 'Gilroy',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _isRunning ? null : _startTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 40,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                child: Text(
                    'Start',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontFamily: 'Gilroy',
                      fontSize: 20
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: _resetTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 40,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                child: Text(
                'RESET',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontFamily: 'Gilroy',
                      fontSize: 20
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: _isRunning ? _pauseTimer : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 40,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                child: Text(
                    _isPaused ? 'Pause' : 'Pause',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontFamily: 'Gilroy',
                      fontSize: 20
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ExerciseDetailsPage extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailsPage({super.key, required this.exercise});

  Future<void> deleteExercise(int exerciseId, BuildContext context) async {
    final response = await http.delete(Uri.parse('https://localhost:7152/api/Exercise/$exerciseId'));
    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Notificare'),
            content: const Text('Exercițiul a fost șters cu succes!'),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('OK', style: TextStyle(color: Colors.white)),
                onPressed: () {
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
      throw Exception('Failed to delete exercise');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber.withOpacity(0.85),
        title: const Center(
          child: Text(
            'DETALII EXERCIȚIU',
            style: TextStyle(
              fontSize: 23,
              color: Colors.white,
              fontFamily: 'Gilroy',
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/deta.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Denumire: ${exercise.name}',
                      style: const TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      'Descriere: ${exercise.description}',
                      style: const TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      'Ora de începere: ${exercise.startDoingHour}:${exercise.startDoingMinutes}',
                      style: const TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      'Durată: ${exercise.durationInSeconds} secunde',
                      style: const TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TimerWidget(durationInSeconds: exercise.durationInSeconds),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirmare ștergere'),
                              content: const Text('Ești sigur că vrei să ștergi acest exercițiu?'),
                              actions: [
                                TextButton(
                                  child: const Text('NU'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('DA'),
                                  onPressed: () {
                                    deleteExercise(exercise.id, context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 60),
                        padding: const EdgeInsets.all(16.0),
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white.withOpacity(0.13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Text(
                        'Șterge exercițiu',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white.withOpacity(0.75),
                          fontFamily: 'Gilroy',
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
