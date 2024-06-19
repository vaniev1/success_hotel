import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:success_hotel/pages/Addons/booking_page.dart';
import 'package:success_hotel/pages/mainPages/content_view.dart';
import 'package:success_hotel/pages/greetingPages/first_page.dart';
import 'package:success_hotel/pages/authentification/login_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:success_hotel/bloc/booking_bloc/booking_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstRun = prefs.getBool('isFirstRun') ?? true;
  String? token = prefs.getString('token');

  Widget home = isFirstRun ? FirstPage() : LoginView();

  if (token != null) {
    final response = await http.get(
      Uri.parse('https://app.successhotel.ru/api/client/profile'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final profile = data['profile'];
      final currentClientRoom = profile['current_client_room'];

      if (currentClientRoom == null) {
        home = BookingPage();
      } else {
        home = ContentView();
      }
    }
  }

  runApp(MyApp(home: home));
}

class MyApp extends StatelessWidget {
  final Widget home;

  MyApp({required this.home});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SuccessHotel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<BookingBloc>(
            create: (context) => BookingBloc(),
          ),
        ],
        child: home,
      ),
    );
  }
}
