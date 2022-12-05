import 'dart:io';

import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatefulWidget {
  CustomBottomAppBar({Key? key}) : super(key: key);

  @override
  State<CustomBottomAppBar> createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("/search");
            },
            icon: const Icon(
              Icons.search,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("/list");
            },
            icon: const Icon(
              Icons.list,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
