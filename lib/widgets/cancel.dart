import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
            children: <Widget>[Icon(Icons.cancel), Text('Cancel Transaction')]),
        onPressed: () {
          //launch('tel: ${vendor.phone}');
        },
      ),
    ]);
  }
}
