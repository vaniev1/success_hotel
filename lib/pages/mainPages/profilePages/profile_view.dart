import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:success_hotel/pages/Addons/booking_page.dart';
import '../../../bloc/booking_bloc/booking_bloc.dart';
import '../../../bloc/profile_bloc/profile_event.dart';
import '../../../bloc/profile_bloc/profile_state.dart';
import '../../../bloc/profile_bloc/profile_bloc.dart';
import 'package:success_hotel/pages/authentification/login_view.dart';

Color backGroundColor = Colors.white54;
Color buttonColor = Colors.black;

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late ProfileBloc _profileBloc;

  @override
  void initState() {
    super.initState();
    _profileBloc = ProfileBloc();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      _profileBloc.add(LoadProfile(token));
    }
  }

  Future<void> _refreshProfile() async {
    await _loadProfile();
  }

  void _showAlert(
      BuildContext context, String message, VoidCallback onYesPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          contentPadding: EdgeInsets.all(16),
          title: Center(child: Text(message, style: TextStyle(fontSize: 16))),
          actions: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: onYesPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: buttonColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    ),
                    child: Text(
                      'Да',
                      style: TextStyle(color: buttonColor),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: buttonColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    ),
                    child: Text('Нет'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleLogout() {
    _profileBloc.add(Logout(() {
      Get.offAll(() => LoginView());
    }));
  }

  void _handleCheckOut() {
    _profileBloc.add(CheckOut(() {
      Get.offAll(() => BlocProvider(
            create: (context) => BookingBloc(),
            child: BookingPage(),
          ));
    }));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _profileBloc,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: backGroundColor,
          toolbarHeight: 100,
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
                "Мой профиль",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          centerTitle: true,
        ),
        backgroundColor: backGroundColor,
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Center(
                  child: CircularProgressIndicator(
                color: Colors.green,
              ));
            } else if (state is ProfileLoaded) {
              return RefreshIndicator(
                onRefresh: _refreshProfile,
                color: Colors.green,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      state.fullname,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    bottom: 0,
                                    right: 0,
                                    child: IconButton(
                                      icon: Icon(Icons.logout,
                                          color: Colors.black),
                                      onPressed: () {
                                        _showAlert(
                                          context,
                                          "Вы уверены, что хотите выйти?",
                                          () {
                                            Navigator.of(context).pop();
                                            _handleLogout();
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Почта: ${state.email}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  _showAlert(
                                    context,
                                    "Вы уверены, что хотите выселиться?",
                                    () {
                                      Navigator.of(context).pop();
                                      _handleCheckOut();
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: BorderSide(color: buttonColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 24),
                                ),
                                child: Text(
                                  'Выселиться',
                                  style: TextStyle(color: buttonColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 18),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.delete, color: Colors.black),
                            SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                _showAlert(
                                  context,
                                  "Вы уверены, что хотите удалить аккаунт?",
                                  () {
                                    Navigator.of(context).pop();
                                    // Логика для удаления аккаунта
                                  },
                                );
                              },
                              child: Text(
                                'Удалить аккаунт',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is ProfileError) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text("Неизвестная ошибка"));
            }
          },
        ),
      ),
    );
  }
}
