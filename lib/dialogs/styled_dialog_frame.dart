import 'package:flutter/material.dart';

class StyledDialogFrame extends StatelessWidget {
  const StyledDialogFrame(
      {required this.child,
      this.onConfirm,
      this.onCancel,
      this.confirmButtonText = '',
      this.cancelButtonText = '',
      this.hasConfirmButton = true,
      this.hasCancelButton = true,
      super.key});

  final Widget child;
  final Function()? onConfirm;
  final Function()? onCancel;
  final String confirmButtonText;
  final String cancelButtonText;
  final bool hasConfirmButton;
  final bool hasCancelButton;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.5),
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: Container()),
                  IntrinsicWidth(
                    stepWidth: 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: Container()),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                child,
                                const SizedBox(
                                  height: 16,
                                ),
                                //Buttons
                                _buttons(context),
                              ],
                            ),
                          ),
                        ),
                        Flexible(child: Container()),
                      ],
                    ),
                  ),
                  Expanded(child: Container()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttons(BuildContext context) {
    if (hasCancelButton && hasConfirmButton) {
      return _cancelConfirmButtons(context);
    } else if (hasConfirmButton) {
      return _confirmButton(context);
    } else if (hasCancelButton) {
      return _cancelButton(context);
    } else {
      return Container();
    }
  }

  Widget _cancelConfirmButtons(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5)))),
                onPressed: onCancel,
                child: Text(
                  cancelButtonText.isNotEmpty ? cancelButtonText : '取消',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium,
                )),
          ),
          Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5)))),
                onPressed: onConfirm,
                child: Text(
                  confirmButtonText.isNotEmpty ? confirmButtonText : '確定',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium,
                )),
          ),
        ],
      ),
    );
  }

  Widget _confirmButton(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    )),
                onPressed: onConfirm,
                child: Text(
                  confirmButtonText.isNotEmpty ? confirmButtonText : '確定',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium,
                )),
          ),
        ],
      ),
    );
  }

  Widget _cancelButton(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    )),
                onPressed: onCancel,
                child: Text(
                  confirmButtonText.isNotEmpty ? confirmButtonText : '取消',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium,
                )),
          ),
        ],
      ),
    );
  }
}
