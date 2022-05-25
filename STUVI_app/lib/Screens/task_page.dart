import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:STUVI_app/widget/add_todo_dialog_widget.dart';
import 'package:STUVI_app/widget/completed_list_widget.dart';
import 'package:STUVI_app/widget/todo_list_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0; // 0 means first tab TODO TAB

  @override
  Widget build(BuildContext context) {
    //Todo Page and Completed Page
    final tabs = [
      TodoListWidget(), // Todo container
      CompletedListWidget(), // Completed container
    ];

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF2A93D5),
          title: Text(
            'Task Manager',
            style: GoogleFonts.oxygen(),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(40.0),
            ),
          ),
          centerTitle: true),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
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
        ],
      ),
      body: tabs[selectedIndex],
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
