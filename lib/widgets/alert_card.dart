// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import 'Alert.dart';

class AlertCard extends StatelessWidget {
  final Alert alert;
  AlertCard({required this.alert});

  void hide(context) {
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        //Navigator.pushNamed(context, "/customerprofile", arguments: alert);
        //showBanner(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Card(
          margin: const EdgeInsets.fromLTRB(5, 3, 5, 0),
          child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.access_time_outlined),
              ),
              title: Text('GHS ${alert.amount} ${alert.type} request'),
              subtitle: Text('${alert.sec} seconds ago')),
        ),
      ),
    );

    // return Card(
    //     margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
    //     // ignore: unnecessary_new
    //     child: new GestureDetector(
    //       onTap: () {
    //         Navigator.pushNamed(context, 'completeTransaction',
    //             arguments: [vendor.text, vendor.author]);
    //       },
    //       child: Padding(
    //         padding: const EdgeInsets.all(12.0),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.stretch,
    //           children: <Widget>[
    //             Text(
    //               vendor.text,
    //               style: TextStyle(
    //                 fontSize: 18.0,
    //                 color: Colors.grey[600],
    //               ),
    //             ),
    //             SizedBox(height: 6.0),
    //             Text(
    //               vendor.author,
    //               style: TextStyle(
    //                 fontSize: 14.0,
    //                 color: Colors.grey[800],
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ));
  }
}
