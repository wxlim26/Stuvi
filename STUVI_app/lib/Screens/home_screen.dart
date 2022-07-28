import 'package:STUVI_app/Screens/countdown_page.dart';
import 'package:STUVI_app/Screens/home_page.dart';
import 'package:STUVI_app/model/user_stats_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:STUVI_app/widget/add_todo_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:STUVI_app/Screens/profile_page.dart';
import 'package:STUVI_app/Screens/socials_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  UserStatsModel stats = UserStatsModel();

  bool _showWidgetKeyboard = false;
  List<String> emojis = [];
  TextEditingController _emojiController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void showEmojiKeyboard(TextEditingController contoller) {
    setState(() {
      _showWidgetKeyboard = true;
      _emojiController = contoller;
    });
  }

  void hideEmojiKeyboard() {
    setState(() {
      _showWidgetKeyboard = false;
    });
  }

  void onEmojiRemoved() {
    if (!emojis.isEmpty) {
      emojis.removeLast();
    }
    if (emojis.isEmpty) {
      setState(() {
        _showWidgetKeyboard = false;
      });
    }
    _emojiController.text = stringEmoji();
  }

  void _onEmojiSelected(Emoji emoji) {
    emojis.add(emoji.emoji);
    _emojiController.text = stringEmoji();
  }

  String stringEmoji() {
    return emojis.join("");
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomePage(onShowEmojiKeyboard: showEmojiKeyboard),
      CountdownPage(), // Focus mode
      AddTaskWidget(
          onShowEmojiKeyboard: showEmojiKeyboard,
          onHideEmojiKeyboard: hideEmojiKeyboard,
          emojis: emojis),
      SocialsPage(),
      ProfilePage()
    ];
    final items = <Widget>[
      Icon(Icons.home),
      Icon(Icons.visibility),
      Icon(Icons.add),
      Icon(Icons.group_rounded),
      Icon(Icons.person),
    ];

    //navigation bottom bar
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: screens[selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context)
            .copyWith(iconTheme: IconThemeData(color: Colors.white)),
        child: Stack(
          children: [
            CurvedNavigationBar(
              color: Color(0xFF31AFE1),
              backgroundColor: Colors.transparent,
              height: 60,
              items: items,
              index: selectedIndex,
              onTap: (index) => setState(() => this.selectedIndex = index),
              animationDuration: Duration(milliseconds: 300),
            ),
            Offstage(
              offstage: !_showWidgetKeyboard,
              child: SizedBox(
                height: 250,
                child: EmojiPicker(
                    onEmojiSelected: (Category category, Emoji emoji) {
                      _onEmojiSelected(emoji);
                    },
                    onBackspacePressed: onEmojiRemoved,
                    config: Config(
                        columns: 7,
                        // Issue: https://github.com/flutter/flutter/issues/28894
                        emojiSizeMax: 32,
                        verticalSpacing: 0,
                        horizontalSpacing: 0,
                        gridPadding: EdgeInsets.zero,
                        initCategory: Category.RECENT,
                        bgColor: const Color(0xFFF2F2F2),
                        indicatorColor: Colors.blue,
                        iconColor: Colors.grey,
                        iconColorSelected: Colors.blue,
                        progressIndicatorColor: Colors.blue,
                        backspaceColor: Colors.blue,
                        skinToneDialogBgColor: Colors.white,
                        skinToneIndicatorColor: Colors.grey,
                        enableSkinTones: true,
                        showRecentsTab: true,
                        recentsLimit: 28,
                        replaceEmojiOnLimitExceed: false,
                        noRecents: const Text(
                          'No Recents',
                          style: TextStyle(fontSize: 20, color: Colors.black26),
                          textAlign: TextAlign.center,
                        ),
                        tabIndicatorAnimDuration: kTabScrollDuration,
                        categoryIcons: const CategoryIcons(),
                        buttonMode: ButtonMode.MATERIAL)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
