import 'package:STUVI_app/model/user_stats_model.dart';
import 'package:STUVI_app/provider/stats.dart';
import 'package:STUVI_app/provider/todos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

class SelectTasksCompletedWidget extends StatefulWidget {
  const SelectTasksCompletedWidget({Key? key}) : super(key: key);

  @override
  State<SelectTasksCompletedWidget> createState() =>
      _SelectTasksCompletedWidgetState();
}

class _SelectTasksCompletedWidgetState
    extends State<SelectTasksCompletedWidget> {
  List selectedToDoList = [];
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodosProvider>(context);
    final todosCompleted = provider.todosCompleted;

    final multiSelectDialogField = MultiSelectBottomSheetField(
      items: todosCompleted.map((e) => MultiSelectItem(e, e.title)).toList(),
      listType: MultiSelectListType.CHIP,
      cancelText: Text(
        "CANCEL",
        style: TextStyle(
          fontFamily: "OxygenBold",
          color: Color(0xFF31AFE1),
        ),
      ),
      confirmText: Text(
        "SELECT",
        style: TextStyle(
          fontFamily: "OxygenBold",
          color: Color(0xFF31AFE1),
        ),
      ),
      title: Text(
        "Tasks",
        style:
            TextStyle(fontFamily: 'Oxygen', color: Colors.black, fontSize: 18),
      ),
      buttonText: Text(
        "Select Task",
        style: TextStyle(
            fontFamily: 'OxygenLight', color: Color(0xFF808080), fontSize: 15),
      ),
      buttonIcon: Icon(CupertinoIcons.bars, color: Color(0xFF808080)),
      decoration: BoxDecoration(
        color: Color(0xFFEBEBEB),
      ),
      chipDisplay: MultiSelectChipDisplay(
        chipColor: Color(0xFF31AFE1),
        textStyle: TextStyle(fontFamily: "Oxygen", color: Colors.white),
        alignment: Alignment.center,
      ),
      itemsTextStyle: TextStyle(color: Color(0xFF808080)),
      onConfirm: (values) {
        setState(() {
          selectedToDoList = values;
        });
      },
    );

    final deleteButton = Padding(
      padding: EdgeInsets.all(13),
      child: GestureDetector(
        onTap: () {
          deleteToDoList(context, selectedToDoList);
        },
        child: Text(
          'DELETE',
          style: TextStyle(
              color: Colors.red, fontFamily: 'OxygenBold', fontSize: 15),
        ),
      ),
    );

    final markIncompletedButton = Padding(
      padding: EdgeInsets.all(15),
      child: GestureDetector(
        onTap: () {
          provider.toggleTodoStatusList(selectedToDoList);
          User? user = FirebaseAuth.instance.currentUser;

          FirebaseFirestore.instance
              .collection("UserStats")
              .doc(user!.uid)
              .get()
              .then(
            (DocumentSnapshot doc) {
              UserStatsModel stats = UserStatsModel.fromMap(doc.data());
              StatsProvider()
                  .updateExpTasksList(stats, -50 * selectedToDoList.length);
            },
          );
        },
        child: Text(
          'MARK INCOMPLETED',
          style: TextStyle(
              color: Color(0xFF31AFE1), fontFamily: 'OxygenBold', fontSize: 15),
        ),
      ),
    );

    final buttonRow = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[markIncompletedButton, deleteButton],
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.height * 0.4,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              multiSelectDialogField,
              SizedBox(height: 15),
              buttonRow,
            ],
          ),
        ),
      ),
    );
  }
}

void deleteToDoList(BuildContext context, List selectedToDoList) {
  final provider = Provider.of<TodosProvider>(context, listen: false);
  provider.removeToDoList(selectedToDoList);
}
