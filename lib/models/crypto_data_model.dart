class CryptoDataModel {
  String t;
  String s;
  String p;
  String percent;
  String c;
  String o;
  String h;
  String l;
  String b;
  String a;

  CryptoDataModel({
    required this.t,
    required this.s,
    required this.p,
    required this.percent,
    required this.c,
    required this.o,
    required this.h,
    required this.l,
    required this.b,
    required this.a,
  });

  factory CryptoDataModel.fromJson(Map<String, dynamic> json) {
    return CryptoDataModel(
      t: json['T'] as String,
      s: json['s'] as String,
      p: json['p'] as String,
      percent: json['P'] as String,
      c: json['c'] as String,
      o: json['o'] as String,
      h: json['h'] as String,
      l: json['l'] as String,
      b: json['b'] as String,
      a: json['a'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['T'] = t;
    data['s'] = s;
    data['p'] = p;
    data['P'] = p;
    data['c'] = c;
    data['o'] = o;
    data['h'] = h;
    data['l'] = l;
    data['b'] = b;
    data['a'] = a;
    return data;
  }
}
