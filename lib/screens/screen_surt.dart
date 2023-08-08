import 'package:flutter/material.dart';

class SurtScreen extends StatefulWidget {
  const SurtScreen({super.key});

  @override
  State<SurtScreen> createState() => _SurtScreenState();
}

class _SurtScreenState extends State<SurtScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SuRT Demo'),
      ),
      body: Container(),
    );
  }
}
