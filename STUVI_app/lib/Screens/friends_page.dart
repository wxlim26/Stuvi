import 'package:STUVI_app/Screens/countdown_page.dart';
import 'package:STUVI_app/model/todo.dart';
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

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('bye')));
  }
}
