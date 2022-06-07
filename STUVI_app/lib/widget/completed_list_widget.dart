import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:STUVI_app/provider/todos.dart';
import 'package:STUVI_app/widget/todo_widget.dart';

class CompletedListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodosProvider>(context);
    final todos = provider.todosCompleted;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF3FC5F0),
          title: Text(
            'Daily Planner',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true),
      body: todos.isEmpty
          ? Center(
              child: Text(
                'No completed tasks.',
                style: GoogleFonts.oxygen(),
              ),
            )
          : ListView.separated(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(16),
              separatorBuilder: (context, index) => Container(height: 8),
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];

                return TodoWidget(todo: todo);
              },
            ),
    );
  }
}
