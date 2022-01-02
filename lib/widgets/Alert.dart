class Alert {
  var id, tid, type, postedToday, hour, min, sec, amount;
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

  Alert({
    required this.id,
    required this.tid,
    required this.type,
    required this.postedToday,
    required this.hour,
    required this.min,
    required this.sec,
    required this.amount,
  });

  Alert.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        tid = json['tid'],
        type = json['type'],
        postedToday = json['postedToday'],
        hour = json['hour'],
        min = json['min'],
        sec = json['sec'],
        amount = json['amount'];
}
