import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:STUVI_app/Screens/registration_page.dart';
import 'package:STUVI_app/Screens/home_screen.dart';
import '../page/forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // form key
  final _formKey = GlobalKey<FormState>();

  // editing controller [ email and password ]
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  //firebase
  final _auth = FirebaseAuth.instance;

  //String for error Message
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    // email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter your Email Address";
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please enter a valid email");
        }
        return null;
      }, //if we want to validate email address
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      style: TextStyle(fontFamily: 'OxygenLight'), // goes to next field
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

    // password field
    final passwordField = TextFormField(
      obscureText:
          true, // If we dont want to show users password as they are typing
      autofocus: false,
      controller: passwordController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        // Minimum 6 characters for Firebase password
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min. 6 Character)");
        }
        return null;
      }, //if we want to validate email address
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done, // no next field
      style: TextStyle(fontFamily: 'OxygenLight'),
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFEBEBEB),
        prefixIcon: Icon(Icons.lock),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Enter Password",
        hintStyle: TextStyle(color: Color(0xFF808080)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 0, style: BorderStyle.none),
        ),
      ),
    );

    final forgotPassword =
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ForgotPasswordPage();
                },
              ),
            );
          },
          child: Text('Forgot Password?',
              style: TextStyle(
                  fontFamily: 'OxygenBold', color: Color(0xFF31AFE1))))
    ]);

    // loginbutton
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(40),
      color: Color(0xFF31AFE1),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signIn(emailController.text, passwordController.text);
        }, // Replace with the save to database
        child: Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 15, color: Colors.white, fontFamily: 'OxygenBold'),
        ),
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
                    SizedBox(
                      height: 300,
                      child: Image.asset("assets/STUVI_Logo.png",
                          fit: BoxFit.contain),
                    ),
                    emailField,
                    SizedBox(height: 15), // separating the fields
                    passwordField,
                    SizedBox(height: 15),
                    forgotPassword,
                    SizedBox(height: 15),
                    loginButton,
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Don't have an account?"),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => RegistrationPage(
                                          onClicked: () => {},
                                        ))));
                          },
                          child: Text(
                            ' Sign up',
                            style: TextStyle(
                                color: Color(0xFF31AFE1),
                                fontFamily: 'OxygenBold',
                                fontSize: 15),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Login Function
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  Fluttertoast.showToast(msg: "Login Successful"),
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen())),
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
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }
}
