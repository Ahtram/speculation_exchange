import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:speculation_exchange/dialogs/busy_dialog.dart';
import 'package:speculation_exchange/system/data_provider.dart';
import 'package:speculation_exchange/system/env/env.dart';
import 'package:speculation_exchange/system/neon_walker.dart';
import 'package:speculation_exchange/widgets/shared/page_frame.dart';

class SpeculationPreviewBrowser extends ConsumerStatefulWidget {
  const SpeculationPreviewBrowser({this.queryParameters, super.key});

  //Query parameters.
  final Map<String, String>? queryParameters;

  @override
  ConsumerState<SpeculationPreviewBrowser> createState() => _SpeculationPreviewBrowserState();
}

class _SpeculationPreviewBrowserState extends ConsumerState<SpeculationPreviewBrowser> with AfterLayoutMixin {
  String? _eventName;

  List<String>? _speculations;

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    //Try read the parameters.
    if (widget.queryParameters != null) {
      _eventName = widget.queryParameters!['event'];
    }

    _loadExistSpeculations();
  }

  Future _loadExistSpeculations() async {
    if (!NeonWalker.hasInitialized()) {
      NeonWalker.init(endPoint: Env.nextcloudLoginUrl, loginName: Env.nextcloudLoginName, password: Env.nextcloudLoginPassword);
    }

    BusyDialog.show(context, message: '讀取中...');

    //Read from the exist _userName content.
    if (_eventName != null && _eventName!.isNotEmpty) {
      List<String> filePaths = await NeonWalker.listFiles(path: '/speculation_exchange/$_eventName/');
      if (filePaths.isNotEmpty) {
        _speculations = [];
        for (int i = 0; i < filePaths.length; ++i) {
          ref.read(busyDialogMessageProvider.notifier).state = '讀取中... [${i + 1}/${filePaths.length}]';
          Uint8List? fileContent = await NeonWalker.getFile(path: filePaths[i]);
          if (fileContent != null) {
            _speculations!.add(utf8.decode(fileContent));
          }
        }
        setState(() {});
      }
    }

    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(width: 128, height: 128, child: Image.asset('assets/images/newspaper.png')),
        ),
        Text(
          '現在已收集到的問題一覽',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 16,
        ),
        Card(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
        )),

        const SizedBox(
          height: 8,
        ),
        Visibility(
            visible: _speculations != null, child: Text('已收集共 [${_speculations != null ? _speculations!.length : 0}] 個問題')),
        const SizedBox(
          height: 8,
        ),
        ElevatedButton(
            onPressed: () async {
              context.pop();
            },
            child: const Text('返回')),
      ],
    );
  }
}
