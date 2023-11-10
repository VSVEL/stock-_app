// HomeScreen.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:collection/collection.dart';
import '../models/company.dart';
import '../models/watchlist.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];

  Future<double> _getLatestPrice(String symbol) async {
    //var apiKey = '0IEXC0UP6ELBV132';
    var apiUrl = 'https://dev.portal.tradebrains.in/api/search?keyword=$symbol';
    var response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var latestPrice = data['Global Quote']['05. price'];
      return double.parse(latestPrice);
    } else {
      throw Exception('Failed to fetch latest price');
    }
  }

  late Box<WatchlistItem> watchlistBox;

  @override
  void initState() {
    super.initState();
    openWatchlistBox();
  }

  @override
  void dispose() {
    //watchlistBox.close();
    super.dispose();
  }

  void openWatchlistBox() async {
    watchlistBox = await Hive.openBox('watchlist');
  }

  void _addToWatchlist(Company company) async {
    try {
      var latestPrice = 10.0;

      // Check if the item with the same symbol already exists
      var existingItem = watchlistBox.values.firstWhereOrNull(
            (item) => item.symbol == company.symbol,
      );

      if (existingItem != null) {
        // Item with the same symbol already exists
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${company.company} is already in the watchlist')),
        );
      } else {
        // Item doesn't exist, add it to the watchlist
        var watchlistItem = WatchlistItem(
          symbol: company.symbol,
          latestPrice: latestPrice,
          company: company.company,
          type: company.type,
        );

        watchlistBox.add(watchlistItem);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${company.company} added to watchlist')),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  Future<void> _fetchCompanies(String keyword) async {
    final response = await http.get(
      Uri.parse('https://dev.portal.tradebrains.in/api/search?keyword=$keyword'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      var companies = json.decode(response.body);
      setState(() {
        _searchResults = companies.map((company) => Company.fromJson(company)).toList();
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trade Brains'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                _fetchCompanies(query);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                var company = _searchResults[index];
                return ListTile(
                  title: Text(_searchResults[index].company),
                  subtitle: Text('Symbol: ${_searchResults[index].symbol}'),
                  trailing: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      _addToWatchlist(company);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


