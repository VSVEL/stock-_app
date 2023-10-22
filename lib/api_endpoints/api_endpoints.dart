import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../models/company.dart';

class StockApi {
  String? stockSymbol;

  StockApi({this.stockSymbol});

  Future<List<SearchStock>?> getStockData() async {
    var response = await http.get(Uri.parse(
        'https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=' +
            stockSymbol! +
            '&apikey=0IEXC0UP6ELBV132'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      // Check if the 'bestMatches' key exists in the response
      if (data.containsKey('bestMatches')) {
        // Access the 'bestMatches' list and map it to SearchStock objects
        final List result = data['bestMatches'];
        return result.map((e) => SearchStock.fromJson(e)).toList();
      } else {
        print('Invalid API response: Missing key "bestMatches".');
        return null;
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }
}