import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'sport_page.dart';

class TimerWidget extends StatefulWidget {
  final int durationInSeconds;

  TimerWidget({required this.durationInSeconds});

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

    Future.delayed(Duration(seconds: 1), () {
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
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Timp rămas:',
            style: TextStyle(
              fontSize: 25.0,
              color: Colors.white,
              fontFamily: 'Gilroy',
            ),
          ),
          Text.rich(
            TextSpan(
              text: '$minutes',
              style: TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Gilroy',
              ),
              children: <InlineSpan>[
                TextSpan(
                  text: ':$seconds',
                  style: TextStyle(
                    fontSize: 50.0,
                    color: Colors.white,
                    fontFamily: 'Gilroy',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _isRunning ? null : _startTimer,
                child: Text(
                    'Start',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontFamily: 'Gilroy',
                      fontSize: 20
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 40,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: _resetTimer,
                child: Text(
                'RESET',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontFamily: 'Gilroy',
                      fontSize: 20
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 40,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: _isRunning ? _pauseTimer : null,
                child: Text(
                    _isPaused ? 'Pause' : 'Pause',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontFamily: 'Gilroy',
                      fontSize: 20
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 40,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
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

  ExerciseDetailsPage({required this.exercise});

  Future<void> deleteExercise(int exerciseId, BuildContext context) async {
    final response = await http.delete(Uri.parse('https://localhost:7152/api/Exercise/$exerciseId'));
    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Notificare'),
            content: Text('Exercițiul a fost șters cu succes!'),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text('OK', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SportPage()),
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
        title: Center(
          child: Text(
            'DETALII EXERCIȚIU',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Gilroy',
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
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
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Denumire: ${exercise.name}',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Descriere: ${exercise.description}',
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Ora de începere: ${exercise.startDoingHour}:${exercise.startDoingMinutes}',
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Durată: ${exercise.durationInSeconds} secunde',
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TimerWidget(durationInSeconds: exercise.durationInSeconds),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirmare ștergere'),
                              content: Text('Ești sigur că vrei să ștergi acest exercițiu?'),
                              actions: [
                                TextButton(
                                  child: Text('NU'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('DA'),
                                  onPressed: () {
                                    deleteExercise(exercise.id, context);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(200, 60),
                        padding: EdgeInsets.all(16.0),
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
