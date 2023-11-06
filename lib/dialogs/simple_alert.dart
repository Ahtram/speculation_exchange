import 'package:flutter/material.dart';
import 'package:speculation_exchange/dialogs/styled_dialog_frame.dart';

Future<bool> showSimpleAlert(BuildContext context, String title, String content,
    {Function()? onConfirm, Function()? onCancel, bool hasCancelButton = false}) async {
  bool result = await showDialog(
    context: context,
    builder: (dialogContext) {
      return StyledDialogFrame(
        hasCancelButton: hasCancelButton,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              content,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ]),
        onConfirm: () async {
          Navigator.pop(context, true);
          onConfirm?.call();
        },
        onCancel: () {
          Navigator.pop(context, false);
          onCancel?.call();
        },
      );
    },
  );

  //Delay a bit for preventing red screen.
  await Future.delayed(const Duration(milliseconds: 200));

  return result;
}
