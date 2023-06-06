import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'sport_page.dart';
import 'alimentatie_page.dart';
import 'profile_page.dart';

void main() => runApp(FitnessApp());

class FitnessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'FrontPageNeue',
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      }
    });
  }

  void _goToProfilePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.60,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/main.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Blur pe fundal
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    image: _image != null
                        ? DecorationImage(
                      image: FileImage(_image!),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: InkWell(
                    onTap: _pickImage,
                    child: _image == null
                        ? Icon(
                      Icons.camera_alt,
                      size: 60,
                    )
                        : null,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 60,
                  child: Material(
                    elevation: 5,
                    shadowColor: Colors.black.withOpacity(1),
                    color: Colors.white.withOpacity(0.13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(70.0),
                    ),
                    child: InkWell(
                      onTap: _goToProfilePage,
                      child: Center(
                        child: Text(
                          'PROFILE',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white.withOpacity(0.75),
                            fontFamily: 'Gilroy',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Image.asset(
                  'assets/images/logo2.png',
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 200,
                          child: Material(
                            elevation: 10,
                            shadowColor: Colors.black.withOpacity(1),
                            color: Colors.white.withOpacity(0.13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(70.0),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SportPage(),
                                  ),
                                );
                              },
                              child: Center(
                                child: Text(
                                  'SPORT',
                                  style: TextStyle(
                                    fontSize: 35,
                                    color: Colors.white.withOpacity(0.75),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Gilroy',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          height: 200,
                          child: Material(
                            elevation: 10,
                            shadowColor: Colors.black.withOpacity(1),
                            color: Colors.white.withOpacity(0.13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(70.0),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AlimentatiePage(),
                                  ),
                                );
                              },
                              child: Center(
                                child: Text(
                                  'ALIMENTAȚIE',
                                  style: TextStyle(
                                    fontSize: 35,
                                    color: Colors.white.withOpacity(0.75),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Gilroy',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
