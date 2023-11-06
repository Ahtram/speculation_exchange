import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:speculation_exchange/dialogs/busy_dialog.dart';
import 'package:speculation_exchange/dialogs/simple_alert.dart';
import 'package:speculation_exchange/system/define.dart';
import 'package:speculation_exchange/system/global.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with AfterLayoutMixin {
  final TextEditingController _nameEditingController = TextEditingController();

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    //Let's try read from prefs.
    String? playerName = prefs.getString(playerNamePrefKey);
    if (playerName != null) {
      _nameEditingController.text = playerName;
    }
  }

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
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(
                      MdiIcons.bookOpenVariant,
                      size: 64,
                    ),
                  ),
                  Text(
                    '歡迎!',
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
                      '這是一個關於任何問題都可以透過他人來思辨的活動: \n\n在這個活動中，您可以提出任何的問題，包含: 哲學問題、技術問題、生活問題、或者任何觀點，我們將會有一位大師來反饋意見給您。',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  )),
                  const SizedBox(
                    height: 64,
                  ),
                  Text(
                    '該怎麼稱呼您?',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: 240,
                    child: TextField(
                      controller: _nameEditingController,
                      textInputAction: TextInputAction.done,
                      enableSuggestions: false,
                      enableIMEPersonalizedLearning: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        isDense: true,
                        hintText: '您的名稱將在活動中被使用',
                      ),
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (_nameEditingController.text.isEmpty) {
                          await showSimpleAlert(context, 'Oops!', '需要您的名稱！或者暱稱也可以喔！');
                        } else if (_nameEditingController.text.contains(' ')) {
                          await showSimpleAlert(context, 'Oops!', '名稱不可含有空白字元。');
                        } else {
                          //Set the user name.
                          //Save to pref?
                          await prefs.setString(playerNamePrefKey, _nameEditingController.text);

                          if (mounted) {
                            BusyDialog.show(context, message: '讀取中...', showCancelButton: true, onCancelPress: () {
                              context.pop();
                            });
                          }

                          // context.go('/SpeculationEdit');
                        }
                      },
                      child: const Text('Let\'s go!')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
