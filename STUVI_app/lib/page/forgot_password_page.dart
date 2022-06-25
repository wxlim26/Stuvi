import 'package:STUVI_app/Screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // form key
  final _formKey = GlobalKey<FormState>();

  // editing controller [ email ]
  final TextEditingController emailController = new TextEditingController();

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
          return "Please Enter Your Email Address";
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
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

    // reset password button
    final resetPasswordButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(40),
        color: Color(0xFF31AFE1),
        child: MaterialButton(
            onPressed: passwordReset,
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            minWidth: MediaQuery.of(context).size.width,
            child: Text(
              'Reset Password',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15, color: Colors.white, fontFamily: 'OxygenBold'),
            )));

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
                    Text(
                        'Enter your email and we will send you instructions on how to reset your password.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15)),
                    SizedBox(height: 15), // separating the fields
                    emailField,
                    SizedBox(height: 15),
                    resetPasswordButton,
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Back to'),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => LoginScreen())));
                          },
                          child: Text(
                            ' Login Page',
                            style: TextStyle(
                                color: Color(0xFF31AFE1),
                                fontFamily: 'OxygenBold',
                                fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

//Reset password Function
  Future passwordReset() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text.trim());
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              content: Text(
                'Password reset link has been sent, please check your email.',
                textAlign: TextAlign.center,
              ),
            );
          },
        );
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
