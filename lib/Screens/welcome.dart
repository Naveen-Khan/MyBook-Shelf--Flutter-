import 'package:flutter/material.dart';
import 'mainscreen.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Colors.white,
                  const Color.fromARGB(255, 235, 167, 247),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                CircleAvatar(
                  maxRadius: 70,

                  backgroundColor: Colors.white,
                  foregroundColor: Color.fromARGB(255, 91, 19, 133),
                  child: Icon(
                    Icons.import_contacts,
                    color: Color.fromARGB(255, 91, 19, 133),
                    size: 100,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Welcome To Your",
                  style: TextStyle(fontSize: 18, color: Colors.purple),
                ),
                SizedBox(height: 10),
                Text(
                  "BOOK SHELF 💜",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 89, 25, 100),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Let's Track Your Book",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 92, 90, 92),
                  ),
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Mainscreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Start',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
