import 'package:flutter/material.dart';

void main() {
  runApp(LoanInterestApp());
}

class LoanInterestApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size.width;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Hello, Soe Myint!"),),
        body: Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: screenSize / 5,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.green,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),              
              width: screenSize / 5,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.green,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: screenSize / 5,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.green,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: screenSize / 5,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
