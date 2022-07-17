import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:STUVI_app/Screens/achievement_selector_page.dart';
import 'package:STUVI_app/Screens/home_screen.dart';
import 'package:STUVI_app/Screens/login_page.dart';
import 'package:STUVI_app/model/user_friends.dart';
import 'package:STUVI_app/model/user_stats_model.dart';
import 'package:STUVI_app/widget/image_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../model/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class EditProfilePage extends StatefulWidget {
  UserModel user;
  EditProfilePage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // formkey
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  File? image;
  String? errorMessage;
  String imageBase64String = "";
  String title = "";

  //editing controllers
  final firstNameEditingController = new TextEditingController();
  final lastNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();
  final titleController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstNameEditingController.text = widget.user.firstName!;
    lastNameEditingController.text = widget.user.lastName!;
    emailEditingController.text = widget.user.email!;
    titleController.text = widget.user.title;
    imageBase64String =
        widget.user.imageBase64 != null ? widget.user.imageBase64! : "";
  }

  @override
  Widget build(BuildContext context) {
    void signUp(String email, String password) async {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      User? user = _auth.currentUser;
      UserModel userModel = UserModel();
      userModel.email = user!.email;

      if (user.email != emailEditingController.text) {
        await user.updateEmail(emailEditingController.text);
        userModel.email = emailEditingController.text;
      }

      if (passwordEditingController.text != null &&
          passwordEditingController.text.isNotEmpty) {
        await user.updatePassword(passwordEditingController.text);
      }

      userModel.uid = user.uid;
      userModel.firstName = firstNameEditingController.text;
      userModel.lastName = lastNameEditingController.text;
      userModel.registrationDate = widget.user.registrationDate;
      userModel.imageBase64 = imageBase64String;
      userModel.title = titleController.text;

      await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(userModel.toMap());
      Fluttertoast.showToast(msg: "Profile Updated");

      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    }

    Future pickImage(ImageSource source) async {
      try {
        final image = await ImagePicker().pickImage(source: source);
        if (image == null) return;

        final bytes = File(image.path).readAsBytesSync();
        String img64 = base64Encode(bytes);
        setState(() => this.imageBase64String = img64);
      } on PlatformException catch (e) {
        print('Failed to pick image $e');
      }
    }

    renderImage() {
      return SizedBox(
        width: 160,
        height: 160,
        child: imageBase64String.isEmpty
            ? Image.asset("assets/default.jpg", fit: BoxFit.contain)
            : Image.memory(base64Decode(this.imageBase64String),
                fit: BoxFit.cover),
      );
    }

    final defaultProfilePicture = ClipOval(
      child: renderImage(),
    );

    final cameraButton = IconButton(
      icon: Icon(
        Icons.camera_alt,
        color: Color(0xFF808080),
        size: 25,
      ),
      onPressed: () => pickImage(ImageSource.camera),
    );

    final galleyButton = IconButton(
      icon: Icon(
        Icons.image,
        color: Color(0xFF808080),
        size: 25,
      ),
      onPressed: () => pickImage(ImageSource.gallery),
    );

    final buttonRow = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[cameraButton, galleyButton],
    );

    //FirstName Field
    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("First Name cannot be empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid name(Min. 3 Character)");
        }
        return null;
      },
      onSaved: (value) {
        firstNameEditingController.text = value!;
      },

      textInputAction: TextInputAction.next, // goes to next field
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFEBEBEB),
        prefixIcon: Icon(Icons.person),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Enter First Name",
        hintStyle: TextStyle(color: Color(0xFF808080)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 0, style: BorderStyle.none)),
      ),
    );

    //lastName Field
    final lastNameField = TextFormField(
      autofocus: false,
      controller: lastNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Last Name cannot be empty");
        }
        return null;
      },
      onSaved: (value) {
        lastNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next, // goes to next field
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFEBEBEB),
        prefixIcon: Icon(Icons.person),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Enter Last Name",
        hintStyle: TextStyle(color: Color(0xFF808080)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 0, style: BorderStyle.none)),
      ),
    );

    //Email Field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter your Email");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next, // goes to next field
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFEBEBEB),
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Enter Email",
        hintStyle: TextStyle(color: Color(0xFF808080)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 0, style: BorderStyle.none)),
      ),
    );

    //Password Field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: true,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min. 6 Character)");
        }
        return null;
      },
      onSaved: (value) {
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next, // goes to next field
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFEBEBEB),
        prefixIcon: Icon(Icons.lock),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Enter Password",
        hintStyle: TextStyle(color: Color(0xFF808080)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 0, style: BorderStyle.none)),
      ),
    );

    //Confirm password field
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingController,
      obscureText: true,
      validator: (value) {
        if (confirmPasswordEditingController.text !=
            passwordEditingController.text) {
          return "Password don't match";
        }
        return null;
      },
      onSaved: (value) {
        confirmPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.done, // goes to next field
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFEBEBEB),
        prefixIcon: Icon(Icons.lock),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Confirm Password",
        hintStyle: TextStyle(color: Color(0xFF808080)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 0, style: BorderStyle.none)),
      ),
    );

    final achievementSelector = TextFormField(
      autofocus: false,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AchievementSelectorPage(
                      onChangeTitle: (String title) {
                        setState(() {
                          this.title = title;
                          titleController.text = title;
                        });
                      },
                      uid: widget.user.uid!,
                    )));
      },
      readOnly: true,
      controller: titleController,
      textInputAction: TextInputAction.next, // goes to next field
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFEBEBEB),
        prefixIcon: Icon(Icons.emoji_events),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Select Title",
        hintStyle: TextStyle(color: Color(0xFF808080)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 0, style: BorderStyle.none)),
      ),
    );

    //Sign up button
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(40),
      color: Color(0xFF31AFE1),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signUp(emailEditingController.text, passwordEditingController.text);
        }, // Replace with the save to database
        child: Text(
          "Update Profile",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 15, color: Colors.white, fontFamily: 'OxygenBold'),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Your Profile",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'OxygenBold',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 25,
          ),
        ),
        actions: [],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    image != null
                        ? ImageWidget(
                            image: image!,
                            onClicked: (source) => pickImage(source),
                          )
                        : defaultProfilePicture,
                    SizedBox(height: 15),
                    buttonRow,
                    SizedBox(height: 15),
                    firstNameField,
                    SizedBox(height: 15),
                    lastNameField,
                    SizedBox(height: 15),
                    emailField,
                    SizedBox(height: 15),
                    passwordField,
                    SizedBox(height: 15),
                    confirmPasswordField,
                    SizedBox(height: 15),
                    achievementSelector,
                    SizedBox(height: 15),
                    signUpButton,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
