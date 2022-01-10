class Vendor {
  var lat, lng;
  var name;
  var phone;
  var isAgent;

  //  normal constructor, as we've already seen

  //  Quote(String author, String text){
  //    this.text = text;
  //    this.author = author;
  //  }

  //  constructor with named parameters

  //  Quote({ String author, String text }){
  //    this.text = text;
  //    this.author = author;
  //  }

  // constructor with named parameters
  // & automatically assigns named arguments to class properties

  Vendor(
      {required this.name,
      required this.phone,
      required this.isAgent,
      required this.lat,
      required this.lng});

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
      name: json['name'],
      phone: json['phone'],
      isAgent: json['isAgent'],
      lat: json['lat'],
      lng: json['lng']);

  factory Vendor.singlefromJson(dynamic json) => Vendor(
      name: json['name'],
      phone: json['phone'],
      isAgent: json['isAgent'],
      lat: json['lat'],
      lng: json['lng']);
}
