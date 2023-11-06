import 'dart:developer';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speculation_exchange/system/data_provider.dart';
import 'package:speculation_exchange/widgets/shared/plain_button.dart';

class BusyDialog extends ConsumerStatefulWidget {
  const BusyDialog(
      {this.message = '',
      this.showCancelButton = false,
      this.onCancelPress,
      super.key});

  static void show(BuildContext context,
      {String message = '',
      bool showCancelButton = false,
      Function()? onCancelPress,
      Color? barrierColor = Colors.black87}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: barrierColor,
      builder: (BuildContext context) {
        return BusyDialog(
            message: message,
            showCancelButton: showCancelButton,
            onCancelPress: onCancelPress);
      },
    );
  }

  final String message;
  final bool showCancelButton;
  final Function()? onCancelPress;

  @override
  BusyDialogState createState() => BusyDialogState();
}

class BusyDialogState extends ConsumerState<BusyDialog> with AfterLayoutMixin {
  bool _showCancelButton = false;

  @override
  void initState() {
    _showCancelButton = widget.showCancelButton;
    super.initState();
  }

  @override
  afterFirstLayout(BuildContext context) {
    setState(() {
      ref.read(busyDialogMessageProvider.notifier).state = widget.message;
    });
  }

  @override
  Widget build(BuildContext context) {
    String message = ref.watch(busyDialogMessageProvider);

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: FractionalOffset.center,
            width: 128,
            height: 128,
            child: const CircularProgressIndicator(),
          ),
          Text(
            message,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),

          //Cancel button.
          SizedBox(
            height: 80,
            child: Visibility(
              visible: _showCancelButton,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 160,
                    child: PlainButton(
                      text: 'Cancel',
                      onPressed: () {
                        setState(() {
                          _showCancelButton = false;
                        });
                        widget.onCancelPress?.call();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
