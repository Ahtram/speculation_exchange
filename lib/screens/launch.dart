
import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Launch extends StatefulWidget {
  const Launch({super.key});

  @override
  State<Launch> createState() => _LaunchState();
}

class _LaunchState extends State<Launch> with AfterLayoutMixin {

  //Check parameters...
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    //Check params...

    //This is for users.
    //Go welcome.
    context.go('/Welcome');
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
