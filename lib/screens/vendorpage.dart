import 'package:flutter/material.dart';
import 'package:momoproxy/widgets/vendor2.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:maps_launcher/maps_launcher.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VendorPage extends StatefulWidget {
  const VendorPage({Key? key}) : super(key: key);

  @override
  _VendorPageState createState() => _VendorPageState();
}

class _VendorPageState extends State<VendorPage> {
  @override
  Widget build(BuildContext context) {
    final vendor = ModalRoute.of(context)!.settings.arguments as Vendor2;

    // String proxy =
    //     "jhjk"; //getDist(lat, lng, vendor.lat, vendor.lng).toString();

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Vendor Profile'),
        centerTitle: true,
        elevation: 0.0,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                radius: 40.0,
                backgroundImage: AssetImage('assets/images/thumb.jpg'),
              ),
            ),
            Divider(
              color: Colors.grey[800],
              height: 60.0,
            ),
            Text(
              'NAME',
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '${vendor.name}',
              style: TextStyle(
                color: Colors.amberAccent[200],
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 30.0),
            SizedBox(height: 30.0),
            Text(
              'PROXIMITY',
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '${vendor.distance}',
              style: TextStyle(
                color: Colors.amberAccent[200],
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.green,
                      child: Row(children: <Widget>[
                        Icon(Icons.call),
                        Text('Call Vendor')
                      ]),
                      onPressed: () {
                        launch('tel: ${vendor.phone}');
                      },
                    )),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(5, 5, 3, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Row(children: <Widget>[
                        Icon(Icons.directions),
                        Text('Show on map')
                      ]),
                      onPressed: () {
                        MapsLauncher.launchCoordinates(
                            double.parse(vendor.lat), double.parse(vendor.lng));
                      },
                    ))
              ],
            ),
            RaisedButton(
              textColor: Colors.white,
              color: Colors.red[400],
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.cancel),
                    Text('Cancel Transaction')
                  ]),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String tid = prefs.getString('transactionid').toString();

                String url =
                    "http://momoproxy.herokuapp.com/deleteprior/${tid}";

                await http.get(Uri.parse(url));

                prefs.remove('transactionid');

                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
          ],
        ),
      ),
    );
  }
}
