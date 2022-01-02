import 'package:flutter/material.dart';
import 'package:momoproxy/widgets/vendor.dart';
import 'package:momoproxy/widgets/vendor_card.dart';
import 'package:momoproxy/widgets/ma_card.dart';

class GetVendorScreen extends StatefulWidget {
  const GetVendorScreen({Key? key}) : super(key: key);

  @override
  _GetVendorScreenState createState() => _GetVendorScreenState();
}

class _GetVendorScreenState extends State<GetVendorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Vendors Nearby",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
          child: ListView(children: [
        VendorCard(
            vendor: Vendor(
                name: "Jason",
                phone: "0504524328",
                isAgent: false,
                lat: 0.0000,
                lng: 0.00000)),
        VendorCard(
            vendor: Vendor(
                name: "Kofi",
                phone: "0504524328",
                isAgent: false,
                lat: 0.0000,
                lng: 0.00000)),
        MomoAgent(
            vendor: Vendor(
                name: "Big Joe Enterprise",
                phone: "0504524328",
                isAgent: true,
                lat: 0.0000,
                lng: 0.00000)),
        VendorCard(
            vendor: Vendor(
                name: "Akwasi",
                phone: "0504524328",
                isAgent: false,
                lat: 0.0000,
                lng: 0.00000)),
        MomoAgent(
            vendor: Vendor(
                name: "Tag Bee Enterprise",
                phone: "0504524328",
                isAgent: true,
                lat: 0.0000,
                lng: 0.00000)),
      ])),
    );
  }
}
