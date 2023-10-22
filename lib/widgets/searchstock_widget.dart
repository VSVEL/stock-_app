import 'package:flutter/material.dart';
class SearchStockWidget extends StatefulWidget {

  final symbol;

  final name;
  const SearchStockWidget({Key? key, this.symbol, this.name}) : super(key: key);

  @override
  State<SearchStockWidget> createState() => _SearchStockWidgetState();
}

class _SearchStockWidgetState extends State<SearchStockWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: TextStyle(fontSize: 24),
              ),
              Text(widget.symbol, style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
