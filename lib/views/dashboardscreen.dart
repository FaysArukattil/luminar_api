// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:luminar_api/services/userservice.dart';
import 'package:luminar_api/views/homescreen.dart';
import 'package:luminar_api/views/loginpage.dart';
import 'package:luminar_api/views/myproducts.dart';
import 'package:luminar_api/views/profilescreen.dart';

class Dashboardscreen extends StatefulWidget {
  const Dashboardscreen({super.key});

  @override
  State<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends State<Dashboardscreen> {
  List<Widget> screens = [Homescreen(), Myproducts(), Profilescreen()];
  int selectedIndex = 0;
  final PageController _pageController = PageController();
  Future<void> _logout() async {
    await UserService.clearUser();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (selectedIndex != 0) {
          setState(() => selectedIndex = 0);
          _pageController.jumpToPage(0);
          return;
        }
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _logout();
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        body: PageView.builder(
          itemCount: screens.length,
          itemBuilder: (context, index) => screens[index],
          controller: _pageController,
          onPageChanged: (index) => setState(() => selectedIndex = index),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() => selectedIndex = index);
            _pageController.jumpToPage(index);
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: "My Products",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
