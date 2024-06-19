import 'package:flutter/material.dart';

Color backGroundColor = Color(0xFFFAFDFF);

class MyRequestsView extends StatefulWidget {
  const MyRequestsView({super.key});

  @override
  State<MyRequestsView> createState() => _MyRequestsViewState();
}

class _MyRequestsViewState extends State<MyRequestsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backGroundColor,
        toolbarHeight: 120,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              fit: BoxFit.contain,
              height: 60,
            ),
            SizedBox(height: 4),
            Text(
              "Мои запросы",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        centerTitle: true,
      ),
      backgroundColor: backGroundColor,
      body: Center(
        child: Text(
          "Мои запросы",
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}
