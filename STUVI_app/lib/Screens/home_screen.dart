import 'dart:developer';

import 'package:STUVI_app/Screens/add_task_page.dart';
import 'package:STUVI_app/Screens/countdown_page.dart';
import 'package:STUVI_app/Screens/home_page.dart';
import 'package:STUVI_app/model/todo.dart';
import 'package:STUVI_app/widget/todo_form_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:STUVI_app/widget/add_todo_widget.dart';
import 'package:STUVI_app/widget/completed_list_widget.dart';
import 'package:STUVI_app/widget/todo_list_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:STUVI_app/Screens/login_screen.dart';
import 'package:provider/provider.dart';
//import 'package:STUVI_app/Screens/home_screen.dart';
import 'package:STUVI_app/Screens/profile_page.dart';
import '../API/firebase_api.dart';
import '../provider/todos.dart';
import 'package:STUVI_app/Screens/friends_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0; // 0 means first tab in the bottom navigation bar
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  // different pages in navigation bottom bar
  final screens = [
    HomePage(),
    CountdownPage(), // Focus mode
    AddTaskWidget(),
    FriendsPage(),
    ProfilePage()
  ];

  // different icons for navigation bottom bar
  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(Icons.home),
      Icon(Icons.visibility),
      Icon(Icons.add),
      Icon(Icons.group_rounded),
      Icon(Icons.person),
    ];

    //navigation bottom bar
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: screens[selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context)
            .copyWith(iconTheme: IconThemeData(color: Colors.white)),
        child: CurvedNavigationBar(
          color: Color(0xFF31AFE1),
          backgroundColor: Colors.transparent,
          height: 60,
          items: items,
          index: selectedIndex,
          onTap: (index) => setState(() => this.selectedIndex = index),
          animationDuration: Duration(milliseconds: 300),
        ),
      ),
    );
  }
}
