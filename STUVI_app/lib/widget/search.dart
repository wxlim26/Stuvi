import 'package:STUVI_app/model/user_friend.dart';
import 'package:STUVI_app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

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
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Search for a friend...',
        filled: true,
        prefixIcon: Icon(
          Icons.search,
          size: 28.0,
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
    List existingList = [];
    await _firestore
        .collection("userFriends")
        .doc(loggedInUser.uid)
        .get()
        .then(((value) {
      existingList = value["friendList"];
    }));

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
      Fluttertoast.showToast(msg: 'Friend Successfully added');
      widget.onSuccessfullyRequest();
    } else if (friend.uid == loggedInUser.uid) {
      Fluttertoast.showToast(msg: 'Cannot add yourself');
    } else {
      Fluttertoast.showToast(msg: 'Friend is already added');
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
  Widget buildSearchButton() => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xFF3FC5F0)),
          ),
          onPressed: () {
            if (searchController.text.isEmpty) {
              Fluttertoast.showToast(msg: 'Enter valid UID');
            } else {
              setState(() {
                handleSearch();
              });
            }
          }, // QUERY
          child: Text('Add Friend', style: GoogleFonts.oxygen()),
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
        title: Text(
          'Add Friend',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        content: addFriend(),
      );
}
