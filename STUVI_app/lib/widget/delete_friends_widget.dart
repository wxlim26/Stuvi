import 'package:STUVI_app/model/user_friend.dart';
import 'package:STUVI_app/model/user_friends.dart';
import 'package:STUVI_app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class DeleteFriendsWidget extends StatefulWidget {
  final List<UserFriend> friendList;
  final Function onDeleteFriends;

  const DeleteFriendsWidget(
      {Key? key, required this.friendList, required this.onDeleteFriends})
      : super(key: key);

  @override
  State<DeleteFriendsWidget> createState() => _DeleteFriendsWidgetState();
}

class _DeleteFriendsWidgetState extends State<DeleteFriendsWidget> {
  UserFriends userFriend = UserFriends();
  List<UserModel> friends = [];
  List<UserModel> selectedFriends = [];

  @override
  void initState() {
    super.initState();
    widget.friendList.forEach((element) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(element.uid)
          .get()
          .then((value) {
        UserModel user = UserModel.fromMap(value.data());

        setState(() {
          friends.add(user);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final multiSelectDialogField = MultiSelectBottomSheetField(
      items: friends
          .map((e) => MultiSelectItem(e, e.firstName! + " " + e.lastName!))
          .toList(),
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
        "Friends",
        style:
            TextStyle(fontFamily: 'Oxygen', color: Colors.black, fontSize: 18),
      ),
      buttonText: Text(
        "Select Friend",
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
          selectedFriends = values.map((e) => e as UserModel).toList();
        });
      },
    );

    final deleteButton = Padding(
      padding: EdgeInsets.all(15),
      child: GestureDetector(
        onTap: () {
          List<String> userIds = (selectedFriends).map((e) => e.uid!).toList();
          widget.onDeleteFriends(userIds);
        },
        child: Text(
          'DELETE',
          style: TextStyle(
              color: Colors.red, fontFamily: 'OxygenBold', fontSize: 15),
        ),
      ),
    );

    final cancelButton = Padding(
      padding: EdgeInsets.all(15),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Text(
          'CANCEL',
          style: TextStyle(
              color: Color(0xFF31AFE1), fontFamily: 'OxygenBold', fontSize: 15),
        ),
      ),
    );

    final buttonRow = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[deleteButton, cancelButton],
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
