import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CancelRequest extends StatelessWidget {
  const CancelRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Center(
          child: Text(
        "Finding you a vendor",
        style: TextStyle(color: Colors.grey[800], fontSize: 18),
      )),
      SizedBox(
        height: 50,
      ),
      Center(
        child: SpinKitRipple(
          color: Colors.green,
          size: 50.0,
        ),
      ),
      SizedBox(
        height: 50,
      ),
      RaisedButton(
        textColor: Colors.white,
        color: Colors.red[400],
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[Icon(Icons.cancel), Text('Cancel Transaction')]),
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String tid = prefs.getString('transactionid').toString();

          String url = "http://momoproxy.herokuapp.com/deleteprior/${tid}";

          await http.get(Uri.parse(url));

          prefs.remove('transactionid');

          Navigator.pop(context);
        },
      ),
      SizedBox(
        height: 20,
      ),
      Center(
          child: Text(
        "Impatient ? contact the nearby vendors",
        style: TextStyle(color: Colors.grey[500], fontSize: 18),
      )),
    ]);
  }
}
