import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isChecked = false;
  bool isSaved = false;
  TextEditingController nicknameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchNotificationStatus();
    fetchUserProfile();
  }

  void fetchNotificationStatus() async {
    String apiUrl = 'https://localhost:7152/api/Notification/email';

    try {
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          isChecked = response.body.toLowerCase() == 'true';
        });
      } else {
        print('Eroare în obținerea stării notificărilor. Cod de răspuns: ${response.statusCode}');
      }
    } catch (e) {
      print('Eroare în obținerea stării notificărilor: $e');
    }
  }

  void fetchUserProfile() async {
    String apiUrl = 'https://localhost:7152/api/User';

    try {
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var userData = json.decode(response.body);
        setState(() {
          nicknameController.text = userData['nickname'];
          emailController.text = userData['email'];
          ageController.text = userData['age'].toString();
          weightController.text = userData['weight'].toString();
          heightController.text = userData['height'].toString();
        });
      } else {
        print('Eroare în obținerea profilului utilizatorului. Cod de răspuns: ${response.statusCode}');
      }
    } catch (e) {
      print('Eroare în obținerea profilului utilizatorului: $e');
    }
  }

  void sendUserProfile() async {
    String apiUrl = 'https://localhost:7152/api/User';

    Map<String, dynamic> userData = {
      'nickname': nicknameController.text,
      'email': emailController.text,
      'age': int.parse(ageController.text),
      'gender': 0,
      'weight': int.parse(weightController.text),
      'height': int.parse(heightController.text),
    };

    try {
      var response = await http.patch(
        Uri.parse(apiUrl),
        body: json.encode(userData),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          isSaved = true;
        });
        print('Profilul a fost actualizat cu succes.');
      } else {
        print('Eroare în actualizarea profilului. Cod de răspuns: ${response.statusCode}');
      }
    } catch (e) {
      print('Eroare în actualizarea profilului: $e');
    }
  }

  void convertUnits() async {
    String apiUrl = 'https://localhost:7152/api/User/usunits';

    try {
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var unitData = json.decode(response.body);
        double weight = unitData['weight'];
        double height = unitData['height'];

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Unit Conversion',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Gilroy',
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Weight: $weight lbs',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Height: $height inches',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              actions: [
                Container(),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                  ),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              backgroundColor: Colors.white.withOpacity(0.8),
            );
          },
        );
      } else {
        print('Eroare în obținerea unităților de măsură. Cod de răspuns: ${response.statusCode}');
      }
    } catch (e) {
      print('Eroare în obținerea unităților de măsură: $e');
    }
  }

  void sendNotification(bool value) async {
    String apiUrl = 'https://localhost:7152/api/Notification/email';

    try {
      if (value) {
        var response = await http.post(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          print('Notificare trimisă cu succes.');
        } else {
          print('Eroare în trimiterea notificării. Cod de răspuns: ${response.statusCode}');
        }
      } else {
        var response = await http.delete(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          print('Notificările au fost dezactivate cu succes.');
        } else {
          print('Eroare în dezactivarea notificărilor. Cod de răspuns: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Eroare în trimiterea notificării: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PROFIL',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Gilroy',
            color: Colors.white.withOpacity(0.8),
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/profile.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            TextField(
              controller: nicknameController,
              decoration: InputDecoration(
                labelText: 'Nickname',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: ageController,
              decoration: InputDecoration(
                labelText: 'Varsta',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: weightController,
              decoration: InputDecoration(
                labelText: 'Greutate (kg)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: heightController,
              decoration: InputDecoration(
                labelText: 'Inaltime (cm)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    sendUserProfile();
                  },
                  child: Text(
                    'MODIFICĂ',
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 18.0,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    convertUnits();
                  },
                  child: Text(
                    'CONVERTEȘTE UNITAȚILE',
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 18.0,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
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
            SizedBox(height: 20),
            CheckboxListTile(
              title: Text('Notificări'),
              value: isChecked,
              onChanged: (value) {
                setState(() {
                  isChecked = value ?? false;
                });
                sendNotification(isChecked);
              },
            ),
            SizedBox(height: 7),
            if (isSaved)
              Center(
                child: Text(
                  'Datele au fost salvate cu succes.',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
