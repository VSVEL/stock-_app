// import 'package:hive/hive.dart';
//
// import '../models/watchlist.dart';
//
// class WatchlistItemAdapter extends TypeAdapter<WatchlistItem> {
//   @override
//   final typeId = 1;
//
//   @override
//   WatchlistItem read(BinaryReader reader) {
//     var symbol = reader.readString();
//     var latestPrice = reader.readDouble();
//     return WatchlistItem(symbol: symbol, latestPrice: latestPrice);
//   }
//
//   @override
//   void write(BinaryWriter writer, WatchlistItem obj) {
//     writer.writeString(obj.symbol);
//     writer.writeDouble(obj.latestPrice);
//   }
// }
