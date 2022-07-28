import 'package:STUVI_app/model/user_friend.dart';
import 'package:STUVI_app/model/user_friends.dart';
import 'package:STUVI_app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Search extends StatefulWidget {
  final VoidCallback onSuccessfullyRequest;

  const Search(this.onSuccessfullyRequest);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  UserModel searchedUser = UserModel();
  final searchController = TextEditingController();
  bool isLoading = false;
  bool valid = false;
  String? frienduid;
  String? text;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
    });
  }

  TextFormField buildSearchField() {
    return TextFormField(
      maxLines: 1,
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Search for a friend',
        hintStyle: TextStyle(color: Color(0xFF808080)),
        filled: true,
        fillColor: Color(0xFFEBEBEB),
        prefixIcon: Icon(Icons.search),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 0, style: BorderStyle.none),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a UserID';
        }
        return null;
      },
    );
  }

  addingFriend(UserModel friend) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    List<UserFriend> existingList = [];
    await _firestore
        .collection("userFriends")
        .doc(loggedInUser.uid)
        .get()
        .then(((value) {
      existingList = UserFriends.fromMap(value.data()).friendList;
    }));

    bool isExist = existingList
        .where((element) => element.uid == friend.uid)
        .toList()
        .isNotEmpty;

    if (isExist) {
      Fluttertoast.showToast(msg: 'Friend request already received from User');
      return;
    }

    if (friend.uid != loggedInUser.uid) {
      await _firestore.collection("userFriends").doc(loggedInUser.uid).update({
        "friendList": FieldValue.arrayUnion([
          UserFriend(
                  uid: friend.uid,
                  status: 'PENDING',
                  requestedAt: DateTime.now().toUtc().millisecondsSinceEpoch,
                  requestedID: loggedInUser.uid!)
              .toMap()
        ]),
      });
      await _firestore.collection("userFriends").doc(frienduid).update({
        "friendList": FieldValue.arrayUnion([
          UserFriend(
                  uid: loggedInUser.uid,
                  status: 'PENDING',
                  requestedAt: DateTime.now().toUtc().millisecondsSinceEpoch,
                  requestedID: loggedInUser.uid!)
              .toMap()
        ]),
      });
      Fluttertoast.showToast(msg: 'Friend request sent');
      widget.onSuccessfullyRequest();
    } else if (friend.uid == loggedInUser.uid) {
      Fluttertoast.showToast(msg: 'Unable to add yourself');
    } else {
      Fluttertoast.showToast(msg: 'User is already a friend');
    }
  }

  handleSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection("users")
        .where("uid", isEqualTo: searchController.text)
        .get()
        .then((value) {
      setState(() {
        if (value.docs.isNotEmpty) {
          this.searchedUser = UserModel.fromMap(value.docs[0].data());
          isLoading = false;
          frienduid = searchedUser.uid;
          valid = true;
          // ADD FRIEND
          addingFriend(searchedUser);
        } else {
          valid = false;
          Fluttertoast.showToast(msg: 'No such User');
        }
      });
    });
    /* USED TO CREATE A TILE OF SEARCHED USER if we doing search user
    if (valid == true) {
      return showDialog(
          context: context, builder: (_) => profiletile(searchedUser));
    }
    */
  }

  // ADD FRIEND BUTTON
  Widget buildSearchButton() => InkWell(
        onTap: () {
          if (searchController.text.isEmpty) {
            Fluttertoast.showToast(msg: 'Enter valid UID');
          } else {
            setState(
              () {
                handleSearch();
              },
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF31AFE1),
            borderRadius: BorderRadius.circular(30),
          ),
          width: MediaQuery.of(context).size.width * 0.2,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Send',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Oxygen',
                color: Colors.white,
              ),
            ),
          ),
        ),
      );

  /* USED IF WE WANT TO CHANGE IT TO SEARCH FOR USER INSTEAD
  Widget profiletile(UserModel userSearched) {
    return AlertDialog(
      title: Text("${userSearched.firstName} ${userSearched.lastName}"),
      content: 
    );
  }
  */

  SingleChildScrollView addFriend() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text('Enter UserID'),
          ),
          SizedBox(height: 8),
          buildSearchField(),
          SizedBox(height: 10),
          buildSearchButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        title: Text(
          'Send Friend Request',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'OxygenBold',
            fontSize: 20,
          ),
        ),
        content: addFriend(),
      );
}
