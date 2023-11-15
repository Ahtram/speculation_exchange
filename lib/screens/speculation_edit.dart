
import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:speculation_exchange/widgets/shared/page_frame.dart';

class SpeculationEdit extends StatefulWidget {
  const SpeculationEdit({this.queryParameters, super.key});

  //Query parameters.
  final Map<String, String>? queryParameters;

  @override
  State<SpeculationEdit> createState() => _SpeculationEditState();
}

class _SpeculationEditState extends State<SpeculationEdit> with AfterLayoutMixin {

  final TextEditingController _speculationEditingController = TextEditingController();

  String? _eventName;
  String? _userName;

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    //Try read the parameters.
    if (widget.queryParameters != null) {
      _eventName = widget.queryParameters!['event'];
      _userName = widget.queryParameters!['user'];
    }

    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    return PageFrame(children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
            width: 128,
            height: 128,
            child: Image.asset('assets/images/checklist.png')),
      ),
      Text(
        '您好! [$_userName]',
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
      const SizedBox(
        height: 8,
      ),
      Text(
        '請編輯您的思辨問題',
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
      const SizedBox(
        height: 16,
      ),
      Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '哲學問題、技術問題、生活問題、或者任何觀點。',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          )),

      const SizedBox(
        height: 16,
      ),

      Expanded(
        child: TextField(
          controller: _speculationEditingController,
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.multiline,
          enableSuggestions: false,
          enableIMEPersonalizedLearning: false,
          autocorrect: false,
          decoration: const InputDecoration(
            isDense: true,
            hintText: '隨便來點東西吧...',
          ),
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.left,
          maxLines: null,
          expands: true,
          onTap: () {},
        ),
      ),

      const SizedBox(
        height: 16,
      ),

      ElevatedButton(
          onPressed: _trySubmitSpeculation,
          child: const Text('完成編輯')),

      const SizedBox(
        height: 48,
      ),

      Text(
        '[$_eventName]',
        style: Theme.of(context).textTheme.bodySmall,
        textAlign: TextAlign.center,
      ),

    ]);
  }

  Future _trySubmitSpeculation() async {
    //Todo
  }

}
