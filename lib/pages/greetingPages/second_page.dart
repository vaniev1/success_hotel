import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:success_hotel/pages/greetingPages/third_page.dart';

Color ButtonColor = Color(0xFF15BE77);
Color TextColor = Color(0xFF3B3B3B);

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 102),
            Image.asset('assets/logo.png', height: 60),
            SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/card.png', height: 200),
                SizedBox(width: 16),
              ],
            ),
            SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 52.0),
              child: Text(
                'Оплачивайте прямо в приложении',
                style: TextStyle(fontSize: 18, color: TextColor),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 146),
            Padding(
              padding: const EdgeInsets.only(bottom: 63),
              child: ElevatedButton(
                onPressed: () {
                  Get.off(ThirdPage());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ButtonColor,
                  minimumSize: Size(325, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text('Хорошо', style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}