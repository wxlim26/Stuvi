import 'dart:io';
import 'package:STUVI_app/Screens/home_screen.dart';
import 'package:STUVI_app/Screens/login_page.dart';
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

class RegistrationPage extends StatefulWidget {
  final VoidCallback onClicked;

  RegistrationPage({
    Key? key,
    required this.onClicked,
  }) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // formkey
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  File? image;
  String? errorMessage;

  //editing controllers
  final firstNameEditingController = new TextEditingController();
  final lastNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    postDetailsToFirestore() async {
      // calling our firestore
      // calling our user model
      // sedning these values

      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      User? user = _auth.currentUser;

      UserModel userModel = UserModel();
      UserStatsModel stats = UserStatsModel();

      // writing all the values
      userModel.email = user!.email;
      userModel.uid = user.uid;
      userModel.firstName = firstNameEditingController.text;
      userModel.lastName = lastNameEditingController.text;
      userModel.registrationDate =
          DateTime.now().toUtc().millisecondsSinceEpoch;

      //writing values for user Stats
      stats.uid = user.uid;
      stats.exp = 0;

      await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(userModel.toMap());
      Fluttertoast.showToast(msg: "Account created successfully :) ");

      await firebaseFirestore
          .collection("UserStats")
          .doc(user.uid)
          .set(stats.toMap());

      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    }

    void signUp(String email, String password) async {
      if (_formKey.currentState!.validate()) {
        try {
          await _auth
              .createUserWithEmailAndPassword(email: email, password: password)
              .then((value) => {postDetailsToFirestore()})
              .catchError((e) {
            Fluttertoast.showToast(msg: e!.message);
          });
        } on FirebaseAuthException catch (error) {
          switch (error.code) {
            case "invalid-email":
              errorMessage = "Your email address appears to be malformed.";
              break;
            case "wrong-password":
              errorMessage = "Your password is wrong.";
              break;
            case "user-not-found":
              errorMessage = "User with this email doesn't exist.";
              break;
            case "user-disabled":
              errorMessage = "User with this email has been disabled.";
              break;
            case "too-many-requests":
              errorMessage = "Too many requests";
              break;
            case "operation-not-allowed":
              errorMessage =
                  "Signing in with Email and Password is not enabled.";
              break;
            default:
              errorMessage = "An undefined Error happened.";
          }
          Fluttertoast.showToast(msg: errorMessage!);
          print(error.code);
        }
      }
    }

    Future<File> saveImagePermanenetly(String imagePath) async {
      final directory = await getApplicationDocumentsDirectory();
      final name = basename(imagePath);
      final image = File('${directory.path}/$name');
      return File(imagePath).copy(imagePath);
    }

    Future pickImage(ImageSource source) async {
      try {
        final image = await ImagePicker().pickImage(source: source);
        if (image == null) return;

        // final imageTemporary = File(image.path);
        final imagePermanent = await saveImagePermanenetly(image.path);
        setState(() => this.image = imagePermanent);
      } on PlatformException catch (e) {
        print('Failed to pick image $e');
      }
    }

    final defaultProfilePicture = ClipOval(
      child: Image.file(
        File('assets/default.jpg'),
        width: 160,
        height: 160,
        fit: BoxFit.cover,
      ),
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
          "Sign Up",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 15, color: Colors.white, fontFamily: 'OxygenBold'),
        ),
      ),
    );

    final bottomText = Material(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Back To"),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => LoginPage())));
            },
            child: Text(
              ' Login Page',
              style: TextStyle(
                  color: Color(0xFF31AFE1),
                  fontFamily: 'OxygenBold',
                  fontSize: 15),
            ),
          )
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
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
                    signUpButton,
                    SizedBox(height: 15),
                    bottomText
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
