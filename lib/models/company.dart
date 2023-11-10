class Company {
  final String type;
  final String company;
  final String symbol;

  Company({
    required this.company,
    required this.symbol,
    required this.type
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      type: json['type'] as String,
      symbol: json['symbol'] as String,
      company: json['company'] as String,
    );
  }
}