import 'package:flutter/material.dart'
    show
        AppBar,
        BuildContext,
        Center,
        MaterialApp,
        Scaffold,
        StatelessWidget,
        Text,
        Widget,
        runApp;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Flutter'),
        ),
        body: const Center(
          child: const Text('Hello World'),
        ),
      ),
    );
  }
}
