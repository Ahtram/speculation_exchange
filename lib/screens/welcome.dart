import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nextcloud/nextcloud.dart';

import 'package:speculation_exchange/dialogs/busy_dialog.dart';
import 'package:speculation_exchange/dialogs/simple_alert.dart';
import 'package:speculation_exchange/system/define.dart';
import 'package:speculation_exchange/system/global.dart';
import 'package:speculation_exchange/widgets/shared/page_frame.dart';

class Welcome extends StatefulWidget {
  const Welcome({this.queryParameters, super.key});

  //Query parameters.
  final Map<String, String>? queryParameters;

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with AfterLayoutMixin {
  final TextEditingController _nameEditingController = TextEditingController();

  String? _eventName;

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    //Let's try read from prefs.
    String? playerName = prefs.getString(playerNamePrefKey);
    if (playerName != null) {
      _nameEditingController.text = playerName;
    }

    //Try read the event name.
    if (widget.queryParameters != null) {
      _eventName = widget.queryParameters!['event'];
    }

    setState(() { });

    _testNextCloud();
  }

  Future _testNextCloud() async {
    log('[_testNextCloud]');
    try {
      NextcloudClient nextCloudClient = NextcloudClient(
          Uri.parse('https://uni-team.xyz/nextCloud/'),
          loginName: 'keeper',
          password: 'storagekeeper');

      String hrefPrefix = '/nextCloud/remote.php/webdav';

      WebDavMultistatus webDavMultiStatuses = await nextCloudClient.webdav.propfind(PathUri.parse('/'));

      for (WebDavResponse webDavResponse in webDavMultiStatuses.responses) {

        if (webDavResponse.href != null) {
          if (webDavResponse.href!.endsWith('/')) {
            //This is a dir.
            String path = webDavResponse.href!.replaceFirst(hrefPrefix, '');
            log('[Directory]: $path');

            //Try read the content of this file.
            // WebDavMultistatus subWebDavMultiStatuses = await nextCloudClient.webdav.propfind(PathUri.parse(path));
            // for (WebDavResponse subWebDavResponse in subWebDavMultiStatuses.responses) {
            //   if (subWebDavResponse.href != null) {
            //     if (subWebDavResponse.href!.endsWith('/')) {
            //       String subPath = subWebDavResponse.href!.replaceFirst(hrefPrefix, '');
            //       log('[Sub Directory]: $subPath');
            //     } else {
            //       String subPath = subWebDavResponse.href!.replaceFirst(hrefPrefix, '');
            //       log('[Sub File]: $subPath | ${subWebDavResponse.toXmlElement()}');
            //     }
            //   }
            // }

          } else {
            //This is a file.
            String path = webDavResponse.href!.replaceFirst(hrefPrefix, '');
            log('[File]: $path');

            if (path.endsWith('.md')) {
              //Test print the content.
              Uint8List file = await nextCloudClient.webdav.get(PathUri.parse(path));
              String fileContent = utf8.decode(file);
              log ('[File Content]: $fileContent');
            }

          }
        }
        // for (WebDavPropstat webDavPropStat in webDavResponse.propstats) {
        //   //Todo: WTF is there anything worth here???
        //   // log('[webDavPropStat.status]: ${webDavPropStat.status}');
        //   log(webDavPropStat.prop.toXmlElement().toString());
        // }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_eventName != null && _eventName!.isNotEmpty) {
      return PageFrame(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
                width: 128,
                height: 128,
                child: Image.asset('assets/images/bookmark.png')),
          ),
          Text(
            '歡迎參加活動 [$_eventName]!',
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
            height: 48,
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
              onPressed: _trySubmitUserName,
              child: const Text('Let\'s go!')),
          // const SizedBox(
          //   height: 64,
          // ),
          // Text(version),
        ],
      );
    } else {
      //No event name? This is not legal.
      return const PageFrame(
        children: [
          Text('無活動名稱'),
        ],
      );
    }
  }

  //嘗試設定 User Name.
  Future _trySubmitUserName() async {
    if (_nameEditingController.text.isEmpty) {
      await showSimpleAlert(context, 'Oops!', '需要您的名稱！或者暱稱也可以喔！');
    } else if (_nameEditingController.text.contains(' ')) {
      await showSimpleAlert(context, 'Oops!', '名稱不可含有空白字元。');
    } else {

      //Save the user name to pref. We'll just use prefs as a global var.
      await prefs.setString(playerNamePrefKey, _nameEditingController.text);

      if (mounted) {
        BusyDialog.show(context, message: '讀取中...', showCancelButton: true, onCancelPress: () {
          context.pop();
        });
      }

      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        Map<String, String> params = {
          'event': _eventName!,
          'user': _nameEditingController.text,
        };

        context.go('/SpeculationEdit', extra: params);
      }
    }
  }
}
