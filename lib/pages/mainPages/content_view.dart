import 'package:flutter/material.dart';
import 'package:success_hotel/pages/mainPages/requestsPages/my_requests.dart';
import 'package:success_hotel/pages/mainPages/profilePages/profile_view.dart';
import 'package:success_hotel/pages/mainPages/servicesPages/services_view.dart';

class ContentView extends StatefulWidget {
  const ContentView({super.key});

  @override
  State<ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> {
  int _pageIndex = 0;
  final List<Widget> _tabList = [
    MyRequestsView(),
    ServicesView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _tabList.elementAt(_pageIndex),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Align(
              alignment: Alignment(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: BottomNavigationBar(
                    selectedItemColor: Colors.green,
                    unselectedItemColor: Colors.grey,
                    showSelectedLabels: true,
                    showUnselectedLabels: true,
                    backgroundColor: Colors.white,
                    currentIndex: _pageIndex,
                    onTap: (int index) {
                      setState(() {
                        _pageIndex = index;
                      });
                    },
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.notifications),
                        label: "Мои запросы",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.room_service),
                        label: "Сервисы",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: "Профиль",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
