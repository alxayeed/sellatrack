import 'package:flutter/material.dart';

class SellaTrackApp extends StatelessWidget {
  const SellaTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SellaTrack',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const Scaffold(body: Center(child: Text("Welcome to SellaTrack!"))),
    );
  }
}
