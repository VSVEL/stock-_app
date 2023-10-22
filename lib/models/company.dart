class SearchStock {
  String? symbol;
  String? name;
  String? type;

  SearchStock({this.symbol, this.name, this.type});

  SearchStock.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['name'] = name;
    data['type'] = type;
    return data;
  }

}


