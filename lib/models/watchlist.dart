import 'package:hive/hive.dart';

part 'watchlist.g.dart';

@HiveType(typeId: 0)
class WatchlistItem extends HiveObject {
  @HiveField(0)
  final String symbol;
  @HiveField(1)
  final double latestPrice;

  WatchlistItem({
    required this.symbol,
    required this.latestPrice,
  });
}