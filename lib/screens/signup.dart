import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:momoproxy/widgets/custom_checkbox.dart';
import 'package:momoproxy/widgets/primary_button.dart';
import 'package:momoproxy/theme.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool passwordVisible = false;
  bool passwordConfrimationVisible = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  void httpSignup() {
    setState(() async {
      String name = nameController.text;
      String phone = phoneController.text;
      String email = emailController.text;
      String password = passwordController.text;
      SharedPreferences prefs = await SharedPreferences.getInstance();

      try {
        var response = await http.get(Uri.parse(
            'http://momoproxy.herokuapp.com/user_register/$name/$phone/$email/$password'));

        print('Response body: ${response.body}');

        var jsonData = jsonDecode(response.body);

        if (jsonData['response'] == 'success') {
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          Fluttertoast.showToast(
              msg: "An error occurred please try again",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red[500],
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } on Exception catch (e) {
        Fluttertoast.showToast(
            msg: "Internal server error",
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
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      'Register new\naccount',
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
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: 'Name',
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
                          controller: phoneController,
                          decoration: InputDecoration(
                            hintText: 'Phone',
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
                      SizedBox(
                        height: 32,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: textWhiteGrey,
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        child: TextFormField(
                          controller: confirmController,
                          obscureText: !passwordConfrimationVisible,
                          decoration: InputDecoration(
                            hintText: 'Password Confirmation',
                            hintStyle: heading6.copyWith(color: textGrey),
                            suffixIcon: IconButton(
                              color: textGrey,
                              splashRadius: 1,
                              icon: Icon(passwordConfrimationVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined),
                              onPressed: () {
                                setState(() {
                                  passwordConfrimationVisible =
                                      !passwordConfrimationVisible;
                                });
                              },
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'By registering, you agree to our',
                          style: regular16pt.copyWith(color: textGrey),
                        ),
                        Text(
                          'Terms & Conditions',
                          style: regular16pt.copyWith(color: primaryBlue),
                        ),
                      ],
                    ),
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
                        //httpLogin();
                        //Navigator.pushReplacementNamed(context, "/home");

                        if (emailController.text.isNotEmpty &&
                            passwordController.text.isNotEmpty &&
                            nameController.text.isNotEmpty &&
                            phoneController.text.isNotEmpty) {
                          if (passwordController.text ==
                              confirmController.text) {
                            httpSignup();
                          } else {
                            Fluttertoast.showToast(
                                msg: "passwords must match",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.orange[500],
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
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
                          'Register',
                          style: heading5.copyWith(color: textWhiteGrey),
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
                      "Already have an account? ",
                      style: regular16pt.copyWith(color: textGrey),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(
                          context,
                        );
                      },
                      child: Text(
                        'Login',
                        style: regular16pt.copyWith(color: primaryBlue),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
