import 'package:flutter/material.dart';

void main() {
  runApp(const DBproApp());
}

class DBproApp extends StatelessWidget {
  const DBproApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DBpro',
      theme: ThemeData(useMaterial3: true),
      home: const Scaffold(
        body: SafeArea(
          child: Center(
            child: Text('DBpro Mobile'),
          ),
        ),
      ),
    );
  }
}
