import 'package:STUVI_app/model/user_friends.dart';
import 'package:STUVI_app/model/user_stats_model.dart';
import 'package:STUVI_app/widget/friend_tile_display.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:STUVI_app/model/user_model.dart';
import 'package:STUVI_app/widget/search.dart';

class FriendsPage extends StatefulWidget {
  FriendsPage({Key? key}) : super(key: key);

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  List friendList = []; // list of uid of friends
  UserModel friend = UserModel();
  UserStatsModel friendStat = UserStatsModel();
  UserFriends userFriend = UserFriends();
  bool? priv;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });

    FirebaseFirestore.instance
        .collection("userFriends")
        .doc(user!.uid)
        .get()
        .then(((value) {
      setState(() {
        friendList = value["friendList"];
      });
    }));

    FirebaseFirestore.instance
        .collection("userFriends")
        .doc(user!.uid)
        .get()
        .then((value) {
      setState(() {
        userFriend = UserFriends.fromMap(value);
        priv = userFriend.privacyMode;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    if (user == null) {
      isLoading = true;
    }

    return isLoading
        ? Container(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                "Friends",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              centerTitle: true,
              leading: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => Search(),
                    );
                    //refresh(context);
                  },
                  child: Icon(Icons.add, color: Colors.black)),
            ),
            body: Container(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.separated(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(15),
                  itemCount: friendList.length,
                  itemBuilder: (context, index) {
                    return FriendTileDisplay(
                        uid: friendList[index], priv: priv!);
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 20),
                ),
              ),
            ),
          );
  }

  Future<void> _refresh() {
    FirebaseFirestore.instance
        .collection("userFriends")
        .doc(user!.uid)
        .get()
        .then(((value) {
      setState(() {
        friendList = value["friendList"];
      });
    }));
    return Future.delayed(
      Duration(seconds: 1),
    );
  }
}
