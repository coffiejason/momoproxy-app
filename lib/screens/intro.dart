import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatelessWidget {
  // const IntroScreen({Key? key}) : super(key: key);

  void autoLogin(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String userid = prefs.getString("userid").toString();

    print(userid);

    if (userid != "null" && userid != "") {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void showOnboarding(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String _seenOnboarding = prefs.getString("seenOnboarding").toString();

    if (_seenOnboarding == "true" || "${_seenOnboarding}" == "Null") {
      autoLogin(context);
    } else {
      Navigator.pushReplacementNamed(context, '/onboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    showOnboarding(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(120),
            child: Image(
              image: AssetImage('assets/images/logo.png'),
            ),
          ),
        ),
      ),
    );
  }
}
