// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class HalamanTiga extends StatefulWidget {
  const HalamanTiga({super.key});

  @override
  State<HalamanTiga> createState() => _HalamanTigaState();
}

class _HalamanTigaState extends State<HalamanTiga> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text('Halaman Satu'),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      leading: Icon(Icons.abc),
      centerTitle: true,
      titleTextStyle: TextStyle(color: Colors.blue, fontSize: 24),
      actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
    ));
  }
}
