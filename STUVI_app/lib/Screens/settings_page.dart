import 'package:STUVI_app/Screens/edit_profile_page.dart';
import 'package:STUVI_app/Screens/home_screen.dart';
import 'package:STUVI_app/Screens/profile_page.dart';
import 'package:STUVI_app/model/user_friend.dart';
import 'package:STUVI_app/model/user_friends.dart';
import 'package:STUVI_app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:STUVI_app/Screens/login_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  UserFriends userFriends = UserFriends();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      setState(() {
        this.loggedInUser = UserModel.fromMap(value.data());
      });
    });

    FirebaseFirestore.instance
        .collection("userFriends")
        .doc(user!.uid)
        .get()
        .then((value) {
      UserFriends curr = UserFriends.fromMap(value.data());
      setState(() {
        userFriends.friendList = curr.friendList;
        userFriends.uid = curr.uid;
        userFriends.privacyMode = curr.privacyMode;
      });
    });
  }

  Widget build(BuildContext context) {
    Future<void> logout(BuildContext context) async {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: ((context) => LoginPage())));
    }

    final appBar = AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        'Settings',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: 'OxygenBold', fontSize: 20, color: Colors.black),
      ),
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
    );

    final firstContainer = Container(
      color: Color(0xFFEBEBEB),
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width,
    );

    final myProfileText = Padding(
      padding: const EdgeInsets.only(left: 15, top: 15),
      child: Text(
        "My Profile",
        style:
            TextStyle(fontFamily: 'Oxygen', color: Colors.black, fontSize: 15),
      ),
    );

    final arrowTextOne = Padding(
      padding: const EdgeInsets.only(left: 250),
      child: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => EditProfilePage(
                  user: loggedInUser)), //create edit profile page
            ),
          );
        },
        icon: Icon(Icons.arrow_forward),
        color: Colors.black,
      ),
    );

    final firstRow = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[myProfileText, arrowTextOne],
    );

    final line = Divider(
      color: Color(0xFFEBEBEB),
      thickness: 1,
    );

    final blockedUserText = Padding(
      padding: const EdgeInsets.only(left: 15, top: 15),
      child: Text(
        "Blocked Users",
        style:
            TextStyle(fontFamily: 'Oxygen', color: Colors.black, fontSize: 15),
      ),
    );

    final arrowTextTwo = Padding(
      padding: const EdgeInsets.only(left: 220),
      child: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => HomeScreen()), //shows blocked user
            ),
          );
        },
        icon: Icon(Icons.arrow_forward),
        color: Colors.black,
      ),
    );

    final secondRow = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[blockedUserText, arrowTextTwo],
    );

    final privacyModeText = Padding(
      padding: const EdgeInsets.only(left: 15, top: 15),
      child: Text(
        "Privacy Mode",
        style:
            TextStyle(fontFamily: 'Oxygen', color: Colors.black, fontSize: 15),
      ),
    );

    final switchButton = Padding(
      padding: const EdgeInsets.only(left: 220),
      child: Switch(
        onChanged: (bool value) {
          setState(() {
            userFriends.privacyMode = value;
            FirebaseFirestore.instance
                .collection("userFriends")
                .doc(user!.uid)
                .set(userFriends.toMap());
          });
        },
        value: userFriends.privacyMode,
        activeColor: Color(0xFF9FE2BF),
      ),
    );

    final thirdRow = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[privacyModeText, switchButton],
    );

    final userIDText = Padding(
      padding: const EdgeInsets.only(left: 15, top: 15),
      child: Text(
        "User ID",
        style:
            TextStyle(fontFamily: 'Oxygen', color: Colors.black, fontSize: 15),
      ),
    );

    final loggedInUserID = Padding(
      padding: const EdgeInsets.only(left: 50, top: 15),
      child: Text(
        "${loggedInUser.uid}",
        style:
            TextStyle(fontFamily: 'Oxygen', color: Colors.black, fontSize: 15),
      ),
    );

    final fourthRow = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[userIDText, loggedInUserID],
    );

    final deleteAccount = Padding(
      padding: const EdgeInsets.only(left: 15, top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async {
              await user?.delete();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text(
              'Delete Account',
              style: TextStyle(
                  fontFamily: 'Oxygen', color: Colors.red, fontSize: 15),
            ),
          ),
        ],
      ),
    );

    final logoutButton = ActionChip(
      backgroundColor: Color(0xFF3FC5F0),
      label: Text(
        "Logout",
        style: TextStyle(
            fontFamily: 'OxygenBold', color: Colors.white, fontSize: 13),
      ),
      onPressed: () {
        logout(context);
      },
    );

    return Scaffold(
      appBar: appBar,
      body: Column(
        children: [
          firstContainer,
          SizedBox(height: 10),
          firstRow,
          line,
          secondRow,
          line,
          thirdRow,
          line,
          fourthRow,
          SizedBox(height: 15),
          line,
          deleteAccount,
          SizedBox(height: 15),
          line,
          logoutButton
        ],
      ),
    );
  }
}
