// ignore_for_file: unnecessary_new

import 'dart:core';

import 'package:flutter/material.dart';
import 'vendor.dart';
import 'vendor2.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:maps_launcher/maps_launcher.dart';
// import 'package:intl/intl.dart';

class MomoAgent extends StatelessWidget {
  final Vendor vendor;
  final bool clickable;
  final double lat;
  final double lng;

  MomoAgent(
      {required this.vendor,
      required this.clickable,
      required this.lat,
      required this.lng});

  bool isAgent = true;

  //DateTime now = DateTime.now();
  // String ftdate = DateFormat('kk:mm:ss').format(DateTime.now());

  // String timeDifference(systemTime, postTime) {
  //   String systemHour = "${systemTime[0]}${systemTime[1]}";
  //   String systemMin = "${systemTime[3]}${systemTime[4]}";
  //   String systemSec = "${systemTime[6]}${systemTime[7]}";

  //   String postHour = "${postTime[0]}${postTime[1]}";
  //   String postMin = "${postTime[3]}${postTime[4]}";
  //   String postSec = "${postTime[6]}${postTime[7]}";

  //   int hourDiff = int.parse(systemHour) - int.parse(postHour);
  //   int minDiff = int.parse(systemMin) - int.parse(postMin);
  //   int secDiff = int.parse(systemSec) - int.parse(postSec);

  //   print('$postTime');

  //   print('$systemHour $postHour');

  //   if (hourDiff > 0) {
  //     return "$hourDiff hours ago";
  //   } else if (hourDiff <= 0 && !(minDiff <= 0)) {
  //     return "$minDiff minutes ago";
  //   } else if (minDiff <= 0 && !(secDiff <= 0)) {
  //     return "$secDiff seconds ago";
  //   } else {
  //     return "posted recently";
  //   }
  // }

  Icon chooseIcon() {
    Icon icon = Icon(Icons.person);
    if (vendor.isAgent) {
      icon = Icon(Icons.person);
    }
    return icon;
  }

  int getDist(
      double userlat, double userlng, double targetlat, double targetlng) {
    return Geolocator.distanceBetween(userlat, userlng, targetlat, targetlng)
        .round();
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        String dist =
            '${getDist(this.lat, this.lng, double.parse(vendor.lat), double.parse(vendor.lng)).toString()} meters away';
        Vendor2 vendor2 = Vendor2(
            name: vendor.name,
            phone: vendor.phone,
            isAgent: vendor.isAgent,
            lat: vendor.lat,
            lng: vendor.lng,
            distance: dist);
        if (clickable) {
          Navigator.pushNamed(context, "/customerprofile", arguments: vendor2);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Card(
          margin: const EdgeInsets.fromLTRB(5, 3, 5, 0),
          child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.store_rounded),
              ),
              title: Text('${vendor.name}'),
              subtitle: Text(
                  '${getDist(this.lat, this.lng, double.parse(vendor.lat), double.parse(vendor.lng))} meters away'),
              trailing: new GestureDetector(
                onTap: () {
                  // MapsLauncher.launchCoordinates(
                  //     double.parse(vendor.lat), double.parse(vendor.lng));
                },
                child: const CircleAvatar(
                  child: Icon(Icons.directions),
                ),
              )),
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
