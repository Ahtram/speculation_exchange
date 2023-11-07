
import 'package:flutter/material.dart';

class PageFrame extends StatelessWidget {
  const PageFrame({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 640,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: IntrinsicHeight(
              child: Column(
                children: children,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
