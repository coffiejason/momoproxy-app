import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:momoproxy/theme.dart';
import 'package:momoproxy/widgets/vendor.dart';
import 'package:momoproxy/widgets/vendor_card.dart';
import 'package:momoproxy/widgets/ma_card.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:async/async.dart';

import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _switchValue = false;
  int _state = 0;

  String _depositIcon = "assets/images/deposit_active.png";
  String _withdrawIcon = "assets/images/withdraw_inactive.png";

  String _amountLabel = "How much do you want to Deposit ?";

  final List<String> titles = [
    "Post a Transaction",
    "Nearby Vendors",
    "Profile"
  ];

  TextEditingController amountController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  late Future<List<Vendor>> futureData;

  late List<Vendor> vendors = [];
  late bool _loading = true;

  final AsyncMemoizer<List<Vendor>> _memoizer = AsyncMemoizer();

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

  Future<List<Vendor>> fetchData() async {
    // var location = await _determinePosition();
    // var lat = location.latitude;
    // var lng = location.longitude;

    return this._memoizer.runOnce(() async {
      try {
        const String url =
            "https://momoproxy.herokuapp.com/getcustomers_v2/0.0000/0.00000";

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

  void fetchData2() async {
    // var location = await _determinePosition();
    // var lat = location.latitude;
    // var lng = location.longitude;

    Future<dynamic> memvalue = _memoizer.runOnce(() async {
      try {
        const String url =
            "https://momoproxy.herokuapp.com/getcustomers_v2/0.0000/0.00000";

        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          List jsonResponse = json.decode(response.body);

          print("got data 2");

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
    }) as Future<List<Vendor>>;

    print(memvalue);

    //return memvalue as Future<List<Vendor>>;
  }

  @override
  void initState() {
    super.initState();
    // fetchData().then((value) =>
    //     setState(() => {print(value), vendors = value, _loading = false}));
  }

  String getType(bool switchValue) {
    if (switchValue) {
      return "withdraw";
    } else if (!switchValue) {
      return "deposit";
    } else {
      return "deposit";
    }
  }

  void postTransaction() async {
    var location = await _determinePosition();
    var lat = location.latitude;
    var lng = location.longitude;

    String amount = amountController.text;
    String phone = phoneController.text;
    String type = getType(_switchValue);

    final response = await http.get(Uri.parse(
        'https://momoproxy.herokuapp.com/request_transaction_v2/$type/$phone/$amount/$lat/$lng'));

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Posted successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green[500],
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      throw Exception('Unexpected error occurred');
    }
  }

  Widget setUpButtonChild() {
    if (_state == 0) {
      return Text(
        "Send Request",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      );
    } else if (_state == 1) {
      return Transform.scale(
        scale: 0.5,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 3.0,
        ),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  void animateButton() {
    setState(() {
      _state = 1;
    });

    Timer(Duration(milliseconds: 3300), () {
      setState(() {
        _state = 2;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> refreshData() {
      setState(() {});
      return fetchData();
    }

    setState(() {
      futureData = fetchData();
    });

    final tabs = [
      SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(right: 24, left: 24, bottom: 36),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/writepostnbg.png",
                  width: 200,
                  height: 200,
                ),
                SizedBox(
                  width: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Transform.scale(
                          scale: 1.2,
                          child: Image.asset(
                            _depositIcon,
                            width: 50,
                            height: 50,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("DEPOSIT",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                color: Color.fromRGBO(136, 152, 170, 1.0))),
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Transform.scale(
                      scale: 1.3,
                      child: CupertinoSwitch(
                        value: _switchValue,
                        onChanged: (bool value) {
                          setState(() {
                            _switchValue = !_switchValue;

                            if (_switchValue == true) {
                              _depositIcon =
                                  "assets/images/deposit_inactive.png";

                              _withdrawIcon =
                                  "assets/images/withdraw_active.png";

                              _amountLabel =
                                  "How much do you want to Withdraw ?";
                            } else if (_switchValue == false) {
                              _depositIcon = "assets/images/deposit_active.png";

                              _withdrawIcon =
                                  "assets/images/withdraw_inactive.png";

                              _amountLabel =
                                  "How much do you want to Deposit ?";
                            }
                          });
                        },
                        trackColor: Colors.amber[400],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        Image.asset(
                          _withdrawIcon,
                          width: 50,
                          height: 50,
                        ),
                        Text("WITHDRAW",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                color: Color.fromRGBO(136, 152, 170, 1.0))),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(_amountLabel,
                      style: TextStyle(fontSize: 17, color: Colors.grey)),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                    controller: amountController,
                    cursorColor: Color.fromRGBO(136, 152, 170, 1.0),
                    textAlignVertical: TextAlignVertical(y: 0.6),
                    keyboardType: TextInputType.numberWithOptions(),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: ArgonColors.white,
                        hintStyle: TextStyle(
                          color: ArgonColors.muted,
                        ),
                        prefixText: "GHS ",
                        prefixStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.attach_money),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(17, 205, 239, 1.0),
                                width: 1.0,
                                style: BorderStyle.solid)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(17, 205, 239, 1.0),
                                width: 1.0,
                                style: BorderStyle.solid)),
                        hintText: "20")),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("What's you phone number?",
                      style: TextStyle(fontSize: 17, color: Colors.grey)),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                    controller: phoneController,
                    cursorColor: Color.fromRGBO(136, 152, 170, 1.0),
                    textAlignVertical: TextAlignVertical(y: 0.6),
                    keyboardType: TextInputType.numberWithOptions(),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: ArgonColors.white,
                        hintStyle: const TextStyle(
                          color: ArgonColors.muted,
                        ),
                        prefixText: "(233) ",
                        prefixIcon: Icon(Icons.local_phone),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(17, 205, 239, 1.0),
                                width: 1.0,
                                style: BorderStyle.solid)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(17, 205, 239, 1.0),
                                width: 1.0,
                                style: BorderStyle.solid)),
                        hintText: "0240000000")),
                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  child: setUpButtonChild(),
                  onPressed: () {
                    setState(() {
                      if (_state == 0) {
                        animateButton();
                      }
                    });

                    postTransaction();
                  },
                  elevation: 4.0,
                  minWidth: double.infinity,
                  height: 48.0,
                  color: Colors.lightGreen,
                ),
              ],
            ),
          ),
        ),
      ),
      Center(
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
                          return VendorCard(vendor: vendor![index]);
                        }),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              })),
      SafeArea(
        child: Center(
            child: Padding(
                padding: const EdgeInsets.only(right: 24, left: 24, bottom: 36),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    CircleAvatar(
                      foregroundImage: AssetImage("assets/images/artwork.png"),
                      radius: 50,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "John Kofi Doe",
                      style: TextStyle(fontSize: 17),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "JohnKofiDoe@email.com",
                      style: TextStyle(fontSize: 17),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "02400000000",
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ))),
      ),
    ];
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              //_loading ? 'Loading ...' : titles[_currentIndex],
              titles[_currentIndex],
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          iconSize: 28,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Post'),
              //backgroundColor: Colors.blue
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              title: Text('Vendors'),
              //backgroundColor: Colors.blue
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile'),
              //backgroundColor: Colors.blue
            )
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;

              //loginStatus(index);
            });
          },
        ),
        body: tabs[_currentIndex]);
  }
}
