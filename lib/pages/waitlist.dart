import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/watchlist.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({Key? key}) : super(key: key);

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  late Box<WatchlistItem> watchlistBox;

  @override
  void initState() {
    super.initState();
    openWatchlistBox();
  }

  @override
  void dispose() {
    // watchlistBox.close();
    super.dispose();
  }

  void openWatchlistBox() async {
    watchlistBox = await Hive.openBox<WatchlistItem>('watchlist');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trade Brains'),
      ),
      body: FutureBuilder(
        future: _fetchWatchlistItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No stocks in the watchlist'));
          } else {
            var watchlistItems = snapshot.data as List<WatchlistItem>;
            return ListView.builder(
              itemCount: watchlistItems.length,
              itemBuilder: (context, index) {
                var watchlistItem = watchlistItems[index];
                return Dismissible(
                  key: Key(watchlistItem.symbol!), // Unique key for each item
                  onDismissed: (direction) {
                    // Remove item from Hive database and update UI
                    _removeFromWatchlist(watchlistItem);
                    setState(() {
                      watchlistItems.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${watchlistItem.symbol} removed from watchlist')),
                    );
                  },
                  background: Container(color: Colors.red),
                  child: ListTile(
                    title: Text(watchlistItem.symbol!),
                    subtitle: FutureBuilder(
                      future: _getLatestPrice(watchlistItem.symbol!),
                      builder: (context, priceSnapshot) {
                        if (priceSnapshot.connectionState == ConnectionState.waiting) {
                          return Text('Loading...');
                        } else if (priceSnapshot.hasError) {
                          return Text('Error: ${priceSnapshot.error}');
                        } else if (priceSnapshot.hasData) {
                          var latestPrice = priceSnapshot.data as double;
                          return Text('Latest Price: \$${latestPrice.toStringAsFixed(2)}');
                        } else {
                          return Text('N/A');
                        }
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<WatchlistItem>?> _fetchWatchlistItems() async {
    var watchlistBox = await Hive.openBox<WatchlistItem>('watchlist');
    return watchlistBox.values.toList();
  }

  Future<void> _removeFromWatchlist(WatchlistItem watchlistItem) async {
    await watchlistBox.delete(watchlistItem.key);
  }


  Future<double> _getLatestPrice(String symbol) async {
    //var apiKey = '0IEXC0UP6ELBV132';
    var apiUrl = 'https://dev.portal.tradebrains.in/api/search?keyword=$symbol';
    var response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var latestPrice = 10.0;
      return latestPrice;
    } else {
      throw Exception('Failed to fetch latest price');
    }
  }
}





