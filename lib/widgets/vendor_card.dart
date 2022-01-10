// ignore_for_file: unnecessary_new

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:momoproxy/widgets/vendor2.dart';
import 'vendor.dart';
import 'vendor2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:maps_launcher/maps_launcher.dart';
// import 'package:intl/intl.dart';

class VendorCard extends StatelessWidget {
  final Vendor vendor;
  final bool clickable;
  final double lat;
  final double lng;

  VendorCard(
      {required this.vendor,
      required this.clickable,
      required this.lat,
      required this.lng});

  bool isAgent = true;

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
        } else {
          Fluttertoast.showToast(
              msg: "Post a transaction in access e-vendors",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.cyan[600],
              textColor: Colors.white,
              fontSize: 16.0);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Card(
          margin: const EdgeInsets.fromLTRB(5, 3, 5, 0),
          child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
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
