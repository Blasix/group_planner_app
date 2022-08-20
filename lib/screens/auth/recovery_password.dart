import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class PassRecScreen extends StatefulWidget {
  const PassRecScreen({Key? key}) : super(key: key);

  @override
  State<PassRecScreen> createState() => _PassRecScreenState();
}

class _PassRecScreenState extends State<PassRecScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pass recovery'),
      ),
    );
  }
}
