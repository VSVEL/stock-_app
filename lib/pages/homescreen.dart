// HomeScreen.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/watchlist.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Company> _searchResults = [];

  Future<double> _getLatestPrice(String symbol) async {
    var apiKey = 'GCZ1Z8BJJMXEWVDA';
    var apiUrl = 'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$symbol&apikey=$apiKey';
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
    watchlistBox.close();
    super.dispose();
  }

  void openWatchlistBox() async {
    watchlistBox = await Hive.openBox<WatchlistItem>('watchlist');
  }

  void _addToWatchlist(Company company) async {
    try {
      var latestPrice = await _getLatestPrice(company.symbol);
      var watchlistItem = WatchlistItem(
        symbol: company.symbol,
        latestPrice: latestPrice,
      );
      watchlistBox.add(watchlistItem);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${company.name} added to watchlist')),
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _fetchCompanies(String keyword) async {
    final response = await http.get(
      Uri.parse('https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=$keyword&apikey=GCZ1Z8BJJMXEWVDA'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      if (data.containsKey('bestMatches')) {
        final companies = data['bestMatches'] as List<dynamic>;
        setState(() {
          _searchResults = companies.map((company) => Company.fromJson(company)).toList();
        });
      } else {
        setState(() {
          _searchResults = [];
        });
      }
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
                  title: Text(_searchResults[index].name),
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

class Company {
  final String name;
  final String symbol;

  Company({
    required this.name,
    required this.symbol,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['2. name'] as String,
      symbol: json['1. symbol'] as String,
    );
  }
}
