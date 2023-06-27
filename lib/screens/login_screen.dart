import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/services/error_messages.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flash_chat/screens/reset_password.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;
  String? password;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _saving = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: _saving,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: SizedBox(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 72.0,
                ),
                Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12))),
                  child: TextField(
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      email = value;
                    },
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: kTextFieldDecoration,
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  child: TextField(
                    obscureText: true,
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      //Do something with the user input.
                      password = value;
                    },
                    style: kTextInputStyle,
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your password'),
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Material(
                    color: Colors.lightBlueAccent,
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed: () async {
                        //Implement login functionality.
                        setState(() {
                          _saving = true;
                        });
                        try {
                          var user = await _auth.signInWithEmailAndPassword(
                              email: email!, password: password!);
                          Fluttertoast.showToast(
                            msg: 'Welcome to Flash Chat',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.white,
                            textColor: Colors.blue[800],
                            fontSize: 16.0,
                          );
                          Navigator.pushNamed(context, ChatScreen.id);
                          setState(() {
                            _saving = false;
                          });
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            _saving = false;
                          });
                          String errorMessage =
                              getErrorMessage('login', e.code);

                          //print(e.code);
                          Fluttertoast.showToast(
                            msg: errorMessage,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.red[400],
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      },
                      minWidth: 200.0,
                      height: 60.0,
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: const Text(
                        'New User? Sign Up',
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, RegistrationScreen.id);
                      },
                    ),
                    TextButton(
                      child: const Text(
                        'Forgot Password',
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, ResetPasswordScreen.id);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
