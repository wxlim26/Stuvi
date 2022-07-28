import 'package:STUVI_app/Screens/home_screen.dart';
import 'package:STUVI_app/model/user_friend.dart';
import 'package:STUVI_app/model/user_friends.dart';
import 'package:STUVI_app/model/user_model.dart';
import 'package:STUVI_app/widget/friend_tile_display.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class BlockedUserPage extends StatefulWidget {
  final String uid;

  const BlockedUserPage({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<BlockedUserPage> createState() => _BlockedUserPageState();
}

class _BlockedUserPageState extends State<BlockedUserPage> {
  UserFriends userFriends = new UserFriends();
  List<UserModel> friends = [];
  List<UserModel> blockedFriends = [];
  List<UserModel> selectedFriends = [];

  List<UserFriend> blockedUserFriends = [];
  List<UserFriend> acceptedUserFriends = [];

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("userFriends")
        .doc(widget.uid)
        .get()
        .then((value) {
      setState(() {
        this.userFriends = UserFriends.fromMap(value.data());
      });
      this.blockedUserFriends = userFriends.friendList
          .where((element) => element.status == 'BLOCKED')
          .toList();

      this.acceptedUserFriends = userFriends.friendList
          .where((element) => element.status == 'ACCEPTED')
          .toList();

      userFriends.friendList.forEach((element) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(element.uid)
            .get()
            .then((value) {
          UserModel user = UserModel.fromMap(value.data());

          setState(() {
            if (element.status == 'BLOCKED') {
              blockedFriends.add(user);
            } else if (element.status == 'ACCEPTED') {
              friends.add(user);
            }
          });
        });
      });
    });
  }

  void unblockFriendRequest(int i) async {
    List<UserFriend> newBlockedList = blockedUserFriends;
    String friendID = newBlockedList[i].uid!;
    newBlockedList.removeAt(i);
    List<UserFriend> newList = [];
    newList.addAll(acceptedUserFriends);
    newList.addAll(newBlockedList);
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    UserFriends newUserFriend = userFriends;
    newUserFriend.friendList = newList;
    await _firestore
        .collection("userFriends")
        .doc(widget.uid)
        .set(newUserFriend.toMap());
    _firestore.collection("userFriends").doc(friendID).get().then(
      ((val) async {
        UserFriends otherFriendList = UserFriends.fromMap(val.data());
        otherFriendList.friendList = otherFriendList.friendList
            .where((val) => val.uid != widget.uid)
            .toList();
        await _firestore
            .collection("userFriends")
            .doc(friendID)
            .set(otherFriendList.toMap());
        getUserFriends();
      }),
    );
  }

  void blockFriendRequest(String uid) async {
    List<UserFriend> newAceptedList = acceptedUserFriends;
    for (int i = 0; i < acceptedUserFriends.length; i++) {
      if (acceptedUserFriends[i].uid == uid) {
        acceptedUserFriends[i].status = 'BLOCKED';
      }
    }
    List<UserFriend> newList = [];
    newList.addAll(blockedUserFriends);
    newList.addAll(newAceptedList);
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    userFriends.friendList = newList;
    await _firestore
        .collection("userFriends")
        .doc(widget.uid)
        .set(userFriends.toMap());

    _firestore.collection("userFriends").doc(uid).get().then(
      ((value) async {
        UserFriends otherFriendList = UserFriends.fromMap(value.data());
        otherFriendList.friendList = otherFriendList.friendList.map((val) {
          if (val.uid == widget.uid) {
            val.status = 'BLOCKED';
          }
          return val;
        }).toList();
        await _firestore
            .collection("userFriends")
            .doc(uid)
            .set(otherFriendList.toMap());
        getUserFriends();
      }),
    );
  }

  void getUserFriends() {
    FirebaseFirestore.instance
        .collection("userFriends")
        .doc(widget.uid)
        .get()
        .then(((value) {
      List<UserFriend> newFriendList =
          UserFriends.fromMap(value.data()).friendList;

      setState(() {
        acceptedUserFriends = newFriendList
            .where((element) => element.status == 'ACCEPTED')
            .toList();
      });
      setState(() {
        blockedUserFriends = newFriendList
            .where((element) => element.status == 'BLOCKED')
            .toList();
      });

      setState(() {
        blockedFriends.clear();
        friends.clear();
      });

      newFriendList.forEach((element) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(element.uid)
            .get()
            .then(((value) {
          UserModel user = UserModel.fromMap(value.data());
          setState(() {
            if (element.status == 'BLOCKED') {
              blockedFriends.add(user);
            } else if (element.status == 'ACCEPTED') {
              friends.add(user);
            }
          });
        }));
      });
    }));
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

    blockButton(context) => Padding(
          padding: EdgeInsets.all(15),
          child: GestureDetector(
            onTap: () {
              List<String> userIds =
                  (selectedFriends).map((e) => e.uid!).toList();
              userIds.forEach((element) {
                blockFriendRequest(element);
              });
              Navigator.pop(context);
            },
            child: Text(
              'BLOCK',
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

    Widget buttonRow(context) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[blockButton(context), cancelButton],
        );

    Widget requestingList = Container(
      height: MediaQuery.of(context).size.height * 0.35,
      child: ListView.separated(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(15),
        itemCount: blockedFriends.length,
        itemBuilder: (context, index) {
          return FriendTileDisplay(
            uid: blockedFriends[index].uid != null
                ? blockedFriends[index].uid!
                : "",
            priv: true,
            status: 'BLOCKED',
            onSuccessfullyRequest: () => {},
            onRejectedRequest: () => unblockFriendRequest(index),
            requestedPersonID: blockedFriends[index].uid!,
            loggedinpersonID: blockedFriends[index].uid! != null
                ? blockedFriends[index].uid!
                : "",
          );
        },
        separatorBuilder: (context, index) => SizedBox(height: 20),
      ),
    );

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: ((context) => HomeScreen()),
                ),
              );
            }, //Add pages
            iconSize: 25,
          ),
          backgroundColor: Colors.white,
          title: Text(
            "Blocked Friends",
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'OxygenBold',
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          actions: [
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
                      'Blocked Friends',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'OxygenBold', color: Colors.black),
                    ),
                    content: Container(
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
                              buttonRow(context),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }, //Add pages
              icon: Icon(
                CupertinoIcons.ellipsis,
                size: 25,
              ),
            )
          ]),
      body: Container(
        child: requestingList,
      ),
    );
  }
}
