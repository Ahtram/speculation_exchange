
import 'package:flutter/material.dart';
import 'package:speculation_exchange/widgets/shared/page_frame.dart';

class SpeculationEdit extends StatefulWidget {
  const SpeculationEdit({super.key});

  @override
  State<SpeculationEdit> createState() => _SpeculationEditState();
}

class _SpeculationEditState extends State<SpeculationEdit> {
  @override
  Widget build(BuildContext context) {
    return PageFrame(children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
            width: 128,
            height: 128,
            child: Image.asset('images/checklist.png')),
      ),
      Text(
        '編輯您的思辨問題',
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
        height: 48,
      ),
    ]);
  }
}
