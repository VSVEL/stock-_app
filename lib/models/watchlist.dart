import 'package:hive/hive.dart';

part 'watchlist.g.dart';

@HiveType(typeId: 0)
class WatchlistItem extends HiveObject {
  @HiveField(0)
  final String? symbol;
  @HiveField(1)
  final double? latestPrice;
  @HiveField(2)
  final String? company;
  @HiveField(3)
  final String? type;

  WatchlistItem({
    required this.symbol,
    required this.latestPrice,
    required this.company,
    required this.type
  });
}