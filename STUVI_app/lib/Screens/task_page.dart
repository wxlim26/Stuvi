import 'package:STUVI_app/Screens/countdown_page.dart';
import 'package:STUVI_app/model/todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:STUVI_app/widget/add_todo_dialog_widget.dart';
import 'package:STUVI_app/widget/completed_list_widget.dart';
import 'package:STUVI_app/widget/todo_list_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:STUVI_app/Screens/login_screen.dart';
import 'package:provider/provider.dart';
//import 'package:STUVI_app/Screens/home_screen.dart';
import 'package:STUVI_app/Screens/profile_page.dart';
import '../API/firebase_api.dart';
import '../provider/todos.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0; // 0 means first tab todo tab
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    //Todo Page and Completed Page
    final tabs = [
      TodoListWidget(), // Todo container
      CompletedListWidget(), // Completed container
      CountdownPage(), // FOcus mode
      ProfilePage(), // Profile Page
      //HomeScreen(),
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        selectedItemColor: Colors.white,
        currentIndex: selectedIndex,
        selectedLabelStyle: GoogleFonts.oxygen(),
        onTap: (index) => setState(() {
          selectedIndex = index;
        }),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.fact_check_outlined),
            label: 'Todos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done, size: 28),
            label: 'Completed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.visibility, size: 28),
            label: 'Focus Mode',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 28),
            label: 'Profile',
          ),
        ],
      ),
      body: StreamBuilder<List<Todo>>(
        stream: FirebaseApi.readTodos(user!.uid),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return buildText('Something Went Wrong Try later');
              } else if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                final todos = snapshot.data;

                final provider = Provider.of<TodosProvider>(context);
                provider.setTodos(todos!);

                return tabs[selectedIndex];
              }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: Color(0xFF3FC5F0),
        onPressed: () => showDialog(
          context: context,
          builder: (_) => AddTodoDialogWidget(),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}

Widget buildText(String text) => Center(
      child: Text(
        text,
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    );

Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: ((context) => LoginScreen())));
}
