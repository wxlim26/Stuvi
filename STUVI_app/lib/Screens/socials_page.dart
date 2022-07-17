import 'package:STUVI_app/Screens/leaderboard_page.dart';
import 'package:STUVI_app/model/user_friend.dart';
import 'package:STUVI_app/model/user_friends.dart';
import 'package:STUVI_app/model/user_stats_model.dart';
import 'package:STUVI_app/widget/delete_friends_widget.dart';
import 'package:STUVI_app/widget/friend_tile_display.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:STUVI_app/model/user_model.dart';
import 'package:STUVI_app/widget/search.dart';
import 'package:flutter/cupertino.dart';

class SocialsPage extends StatefulWidget {
  SocialsPage({Key? key}) : super(key: key);

  @override
  State<SocialsPage> createState() => _SocialsPageState();
}

class _SocialsPageState extends State<SocialsPage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  List<UserFriend> friendList = [];
  List<UserFriend> pendingList = []; // list of uid of friends
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
        friendList = UserFriends.fromMap(value.data())
            .friendList
            .where((element) => element.status == 'ACCEPTED')
            .toList();
        pendingList = UserFriends.fromMap(value.data())
            .friendList
            .where((element) => element.status == 'PENDING')
            .toList();
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

    final appBar = AppBar(
      backgroundColor: Colors.white,
      title: Text(
        "Socials",
        style: TextStyle(
          fontSize: 20,
          fontFamily: 'OxygenBold',
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => Search(getUserFriends),
          );
          //refresh(context);
        },
        child: Icon(
          CupertinoIcons.person_add_solid,
          color: Colors.black,
          size: 25,
        ),
      ),
      actions: [
        IconButton(
          color: Colors.black,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => LeaderBoardPage(
                        userFriends: userFriend, loggedInUser: loggedInUser))));
          }, //Add pages
          icon: Icon(
            Icons.emoji_events,
            size: 25,
          ),
        ),
        IconButton(
          color: Colors.black,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                title: Text(
                  'Delete Friends',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontFamily: 'OxygenBold', color: Colors.black),
                ),
                content: DeleteFriendsWidget(
                    friendList: friendList,
                    onDeleteFriends: (List<String> userIds) {
                      deleteFriend(userIds);
                      Navigator.pop(context);
                    }),
              ),
            );
          }, //Add pages
          icon: Icon(
            CupertinoIcons.ellipsis,
            size: 25,
          ),
        )
      ],
    );

    final requestedText = Padding(
      padding: EdgeInsets.only(left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Pending Requests',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontFamily: 'OxygenBold',
              fontSize: 20,
            ),
          ),
        ],
      ),
    );

    Widget requestingList(String status) => Container(
          height: MediaQuery.of(context).size.height * 0.35,
          child: ListView.separated(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(15),
            itemCount: pendingList.length,
            itemBuilder: (context, index) {
              return FriendTileDisplay(
                uid: pendingList[index].uid != null
                    ? pendingList[index].uid!
                    : "",
                priv: priv!,
                status: status,
                onSuccessfullyRequest: () => acceptFriendRequest(index),
                onRejectedRequest: () => rejectFriendRequest(index),
                requestedPersonID: pendingList[index].requestedID,
                loggedinpersonID:
                    loggedInUser.uid != null ? loggedInUser.uid! : "",
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 20),
          ),
        );

    final acceptedText = Padding(
      padding: EdgeInsets.only(left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Friends',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontFamily: 'OxygenBold',
              fontSize: 20,
            ),
          ),
        ],
      ),
    );

    final acceptedList = Container(
      height: MediaQuery.of(context).size.height * 0.35,
      child: ListView.separated(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(15),
        itemCount: friendList.length,
        itemBuilder: (context, index) {
          return FriendTileDisplay(
            uid: friendList[index].uid != null ? friendList[index].uid! : "",
            priv: priv!,
            status: 'ACCEPTED',
            onSuccessfullyRequest: getUserFriends,
            onRejectedRequest: () => rejectFriendRequest(index),
            requestedPersonID: friendList[index].requestedID,
            loggedinpersonID: loggedInUser.uid != null ? loggedInUser.uid! : "",
          );
        },
        separatorBuilder: (context, index) => SizedBox(height: 20),
      ),
    );

    return isLoading
        ? Container(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: appBar,
            body: Container(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      requestedText,
                      requestingList('PENDING'),
                      acceptedText,
                      acceptedList
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  void getUserFriends() {
    FirebaseFirestore.instance
        .collection("userFriends")
        .doc(user!.uid)
        .get()
        .then(((value) {
      setState(() {
        friendList = UserFriends.fromMap(value.data())
            .friendList
            .where((element) => element.status == 'ACCEPTED')
            .toList();
        pendingList = UserFriends.fromMap(value.data())
            .friendList
            .where((element) => element.status == 'PENDING')
            .toList();
      });
    }));
  }

  void rejectFriendRequest(int i) async {
    List<UserFriend> newPendingList = pendingList;
    String friendID = newPendingList[i].uid!;
    newPendingList.removeAt(i);
    List<UserFriend> newList = [];
    newList.addAll(friendList);
    newList.addAll(newPendingList);
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    UserFriends newUserFriend = userFriend;
    newUserFriend.friendList = newList;
    await _firestore
        .collection("userFriends")
        .doc(loggedInUser.uid)
        .set(newUserFriend.toMap());
    _firestore.collection("userFriends").doc(friendID).get().then(
      ((val) async {
        UserFriends otherFriendList = UserFriends.fromMap(val.data());
        otherFriendList.friendList = otherFriendList.friendList
            .where((val) => val.uid != loggedInUser.uid)
            .toList();
        await _firestore
            .collection("userFriends")
            .doc(friendID)
            .set(otherFriendList.toMap());
        getUserFriends();
      }),
    );
  }

  void acceptFriendRequest(int i) async {
    List<UserFriend> newPendingList = pendingList;
    newPendingList[i].status = 'ACCEPTED';
    List<UserFriend> newList = [];
    newList.addAll(friendList);
    newList.addAll(newPendingList);
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    UserFriends newUserFriend = userFriend;
    newUserFriend.friendList = newList;
    await _firestore
        .collection("userFriends")
        .doc(loggedInUser.uid)
        .set(newUserFriend.toMap());

    _firestore.collection("userFriends").doc(newPendingList[i].uid).get().then(
      ((value) async {
        UserFriends otherFriendList = UserFriends.fromMap(value.data());
        otherFriendList.friendList = otherFriendList.friendList.map((val) {
          if (val.uid == loggedInUser.uid) {
            val.status = 'ACCEPTED';
          }
          return val;
        }).toList();
        await _firestore
            .collection("userFriends")
            .doc(newPendingList[i].uid)
            .set(otherFriendList.toMap());
        getUserFriends();
      }),
    );
  }

  void deleteFriend(List<String> userIDs) async {
    List<UserFriend> newFriendList =
        friendList.where((element) => !userIDs.contains(element.uid)).toList();

    List<UserFriend> newList = [];
    newList.addAll(newFriendList);
    newList.addAll(pendingList);
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    UserFriends newUserFriend = userFriend;
    newUserFriend.friendList = newList;
    await _firestore
        .collection("userFriends")
        .doc(loggedInUser.uid)
        .set(newUserFriend.toMap());

    userIDs.forEach((element) {
      _firestore.collection("userFriends").doc(element).get().then(
        ((value) async {
          UserFriends otherFriendList = UserFriends.fromMap(value.data());
          otherFriendList.friendList = otherFriendList.friendList
              .where((val) => val.uid != loggedInUser.uid)
              .toList();
          await _firestore
              .collection("userFriends")
              .doc(element)
              .set(otherFriendList.toMap());
          getUserFriends();
        }),
      );
    });
  }

  Future<void> _refresh() {
    getUserFriends();
    return Future.delayed(
      Duration(seconds: 1),
    );
  }
}
