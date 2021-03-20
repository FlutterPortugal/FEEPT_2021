import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key key, @required this.onSearch}) : super(key: key);

  final Function onSearch;
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _textController = TextEditingController();
  bool _validate = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 25,
        horizontal: MediaQuery.of(context).size.width * .05,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 15,
            offset: Offset(8, 6),
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        style: TextStyle(color: Colors.black),
        maxLines: 1,
        controller: _textController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.grey),
          errorText: _validate ? null : null,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          icon: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
          contentPadding: EdgeInsets.only(
            left: 0,
            bottom: 11,
            top: 11,
            right: 15,
          ),
          hintText: "Search Location",
        ),
        onSubmitted: (value) {
          this.widget.onSearch(value);
          setState(() => this._textController.clear());
        },
      ),
    );
  }
}
