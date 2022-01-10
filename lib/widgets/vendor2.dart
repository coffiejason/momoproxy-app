class Vendor2 {
  var lat, lng;
  var name;
  var phone;
  var isAgent;
  String distance;

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

  Vendor2(
      {required this.name,
      required this.phone,
      required this.isAgent,
      required this.lat,
      required this.lng,
      required this.distance});

  // factory Vendor2.fromJson(Map<String, dynamic> json) => Vendor2(
  //     name: json['name'],
  //     phone: json['phone'],
  //     isAgent: json['isAgent'],
  //     lat: json['lat'],
  //     lng: json['lng']);

  factory Vendor2.singlefromJson(dynamic json) => Vendor2(
      name: json['name'],
      phone: json['phone'],
      isAgent: json['isAgent'],
      lat: json['lat'],
      lng: json['lng'],
      distance: "100");
}
