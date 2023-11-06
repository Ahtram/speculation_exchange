
import 'package:flutter/material.dart';

class Launch extends StatefulWidget {
  const Launch({super.key});

  @override
  State<Launch> createState() => _LaunchState();
}

class _LaunchState extends State<Launch> {

  //Check parameters...

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Launch'),
      ),
    );
  }
}
