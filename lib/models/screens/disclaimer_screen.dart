import 'package:flutter/material.dart';
import 'simulation_screen.dart';

class DisclaimerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Disclaimer"),
        backgroundColor: Colors.green.shade900,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 60),
            SizedBox(height: 20),
            Text(
              "⚠️ IMPORTANT DISCLAIMER",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "This app is for EDUCATIONAL AND ENTERTAINMENT PURPOSES ONLY.",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 15),
            Text(
              "• This app does NOT predict actual game outcomes",
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
            Text(
              "• This app does NOT guarantee winnings",
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
            Text(
              "• This is a SIMULATION tool for strategy testing",
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
            Text(
              "• All results are RANDOM and for practice only",
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
            Text(
              "• Never gamble with money you cannot afford to lose",
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.red.shade900.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.shade900),
              ),
              child: Text(
                "⚠️ GAMBLING CAN BE ADDICTIVE. Play responsibly.",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SimulationScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  "I UNDERSTAND - CONTINUE",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}