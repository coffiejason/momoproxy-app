import 'package:flutter/material.dart';
import 'package:momoproxy/widgets/vendor.dart';
import 'package:momoproxy/widgets/vendor_card.dart';
import 'package:momoproxy/widgets/ma_card.dart';

import 'package:async/async.dart';
import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class GetVendorScreen extends StatefulWidget {
  const GetVendorScreen({Key? key}) : super(key: key);

  @override
  _GetVendorScreenState createState() => _GetVendorScreenState();
}

class _GetVendorScreenState extends State<GetVendorScreen> {
  late Future<List<Vendor>> futureData;

  late List<Vendor> vendors = [];

  final AsyncMemoizer<List<Vendor>> _memoizer = AsyncMemoizer();

  double lat = 0.00;
  double lng = 0.00;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void getLocation() async {
    var location = await _determinePosition();
    lat = location.latitude;
    lng = location.longitude;
  }

  Future<List<Vendor>> fetchData(String tid) async {
    // var location = await _determinePosition();
    // var lat = location.latitude;
    // var lng = location.longitude;

    return _memoizer.runOnce(() async {
      try {
        String url =
            "http://momoproxy.herokuapp.com/nearestvendors/${tid}/${lat}/${lng}";

        final response = await http.get(Uri.parse(url));

        print("got data");

        if (response.statusCode == 200) {
          List jsonResponse = json.decode(response.body);

          List<Vendor> vendorList = jsonResponse
              .map((vendorData) => new Vendor.fromJson(vendorData))
              .toList();

          return vendorList;
        } else {
          throw Exception('Unexpected error occurred');
        }
      } on Exception catch (e) {
        throw Exception('Unexpected error occurred');
      }
    });
  }

  void savetransaction(
      bool data, String amount, String phone, String operator) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('haspending', data);
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  }

  @override
  Widget build(BuildContext context) {
    final tid = ModalRoute.of(context)!.settings.arguments as String;
    savetransaction(true, "10", "0000000000", "Vodaphone");

    getLocation();

    Future<void> refreshData() {
      setState(() {});
      return fetchData(tid);
    }

    setState(() {
      futureData = fetchData(tid);
    });

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        title: Text(
          "Vendors Nearby",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        centerTitle: true,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
          child: FutureBuilder<List<Vendor>>(
              future: futureData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Vendor>? vendor = snapshot.data;

                  return RefreshIndicator(
                    onRefresh: refreshData,
                    child: ListView.builder(
                        itemCount: vendor?.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (vendor![index].isAgent) {
                            return MomoAgent(
                              vendor: vendor[index],
                              clickable: true,
                              lat: lat,
                              lng: lng,
                            );
                          } else {
                            return VendorCard(
                              vendor: vendor[index],
                              clickable: true,
                              lat: lat,
                              lng: lng,
                            );
                          }
                        }),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              })),
    );
  }
}
