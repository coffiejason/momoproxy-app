import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:momoproxy/screens/signup.dart';
import 'package:momoproxy/widgets/custom_checkbox.dart';
import 'package:momoproxy/theme.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordVisible = false;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  void initState() {
    // Fluttertoast.showToast(
    //     msg: "This is Center Short Toast",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.CENTER,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.cyan[600],
    //     textColor: Colors.white,
    //     fontSize: 16.0);
  }

  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  void httpLogin() async {
    String email = emailController.text;
    String password = passwordController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      var response = await http.get(Uri.parse(
          'http://momoproxy.herokuapp.com/user_login/$email/$password'));

      print('Response body: ${response.body}');

      var jsonData = jsonDecode(response.body);

      if (jsonData['id'] != null) {
        prefs.setString('userid', jsonData['id']);
        prefs.setString('name', jsonData['name']);
        prefs.setString('phone', jsonData['phone']);
        prefs.setString('email', jsonData['email']);

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Fluttertoast.showToast(
            msg: "Wrong email and password combination",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red[500],
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg: "Internal serve error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.amber[500],
          textColor: Colors.white,
          fontSize: 16.0);
    }

    // Fluttertoast.showToast(
    //     msg: "Logging in",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.CENTER,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.green,
    //     textColor: Colors.white,
    //     fontSize: 16.0);
  }

  void autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String userid = prefs.getString("userid").toString();

    print(userid);

    if (userid != "null" && userid != "") {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    autoLogin();

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Login to your\naccount',
                      style: heading2.copyWith(color: textBlack),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      'assets/images/accent.png',
                      width: 99,
                      height: 4,
                    ),
                  ],
                ),
                SizedBox(
                  height: 48,
                ),
                Form(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: textWhiteGrey,
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: heading6.copyWith(color: textGrey),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: textWhiteGrey,
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: !passwordVisible,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: heading6.copyWith(color: textGrey),
                            suffixIcon: IconButton(
                              color: textGrey,
                              splashRadius: 1,
                              icon: Icon(passwordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined),
                              onPressed: togglePassword,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomCheckbox(),
                    SizedBox(
                      width: 12,
                    ),
                    Text('Remember me', style: regular16pt),
                  ],
                ),
                SizedBox(
                  height: 32,
                ),
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        if (emailController.text.isNotEmpty &&
                            passwordController.text.isNotEmpty) {
                          httpLogin();
                        } else {
                          Fluttertoast.showToast(
                              msg: "Fill up all fields",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.amber[500],
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                      borderRadius: BorderRadius.circular(14.0),
                      child: Center(
                        child: Text(
                          'Login',
                          style: heading5.copyWith(color: textWhiteGrey),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Center(
                  child: Text(
                    'OR',
                    style: heading6.copyWith(color: textGrey),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: Color(0xfffbfbfb),
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()));
                      },
                      borderRadius: BorderRadius.circular(14.0),
                      child: Center(
                        child: Text(
                          'Create an account',
                          style: heading5.copyWith(color: textBlack),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "You can also login with ",
                      style: regular16pt.copyWith(color: textGrey),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Google',
                        style: regular16pt.copyWith(color: primaryBlue),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}
