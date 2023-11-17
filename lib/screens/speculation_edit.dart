
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speculation_exchange/dialogs/busy_dialog.dart';
import 'package:speculation_exchange/dialogs/simple_alert.dart';
import 'package:speculation_exchange/system/env/env.dart';
import 'package:speculation_exchange/system/neon_walker.dart';
import 'package:speculation_exchange/widgets/shared/page_frame.dart';

import 'package:nextcloud/nextcloud.dart';

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

    _loadExistContent();
  }

  Future _loadExistContent() async {
    if (!NeonWalker.hasInitialized()) {
      NeonWalker.init(endPoint: Env.nextcloudLoginUrl, loginName: Env.nextcloudLoginName, password: Env.nextcloudLoginPassword);
    }

    BusyDialog.show(context, message: '讀取中...');

    //Read from the exist _userName content.
    if (_eventName != null && _eventName!.isNotEmpty) {
      if (_userName != null && _userName!.isNotEmpty) {
        //Try find the file for the user of this event.
        Uint8List? existContent = await NeonWalker.getFile(path: '/speculation_exchange/$_eventName/$_userName.txt');
        if (existContent != null && existContent.isNotEmpty) {
          //Found exist content.
          _speculationEditingController.text = utf8.decode(existContent);
          setState(() {

          });
        }
      }
    }

    if (mounted) {
      context.pop();
    }
  }

  // Future _testNextCloud() async {
  //   log('[_testNextCloud]');
  //   try {
  //     NextcloudClient nextCloudClient = NextcloudClient(
  //         Uri.parse('https://uni-team.xyz/nextCloud/'),
  //         loginName: 'keeper',
  //         password: 'storagekeeper');
  //
  //     String hrefPrefix = '/nextCloud/remote.php/webdav';
  //
  //     WebDavMultistatus webDavMultiStatuses = await nextCloudClient.webdav.propfind(PathUri.parse('/'));
  //
  //     for (WebDavResponse webDavResponse in webDavMultiStatuses.responses) {
  //
  //       if (webDavResponse.href != null) {
  //         if (webDavResponse.href!.endsWith('/')) {
  //           //This is a dir.
  //           String path = webDavResponse.href!.replaceFirst(hrefPrefix, '');
  //           log('[Directory]: $path');
  //
  //           //Try read the content of this file.
  //           // WebDavMultistatus subWebDavMultiStatuses = await nextCloudClient.webdav.propfind(PathUri.parse(path));
  //           // for (WebDavResponse subWebDavResponse in subWebDavMultiStatuses.responses) {
  //           //   if (subWebDavResponse.href != null) {
  //           //     if (subWebDavResponse.href!.endsWith('/')) {
  //           //       String subPath = subWebDavResponse.href!.replaceFirst(hrefPrefix, '');
  //           //       log('[Sub Directory]: $subPath');
  //           //     } else {
  //           //       String subPath = subWebDavResponse.href!.replaceFirst(hrefPrefix, '');
  //           //       log('[Sub File]: $subPath | ${subWebDavResponse.toXmlElement()}');
  //           //     }
  //           //   }
  //           // }
  //
  //         } else {
  //           //This is a file.
  //           String path = webDavResponse.href!.replaceFirst(hrefPrefix, '');
  //           log('[File]: $path');
  //
  //           if (path.endsWith('.md')) {
  //             //Test print the content.
  //             Uint8List file = await nextCloudClient.webdav.get(PathUri.parse(path));
  //             String fileContent = utf8.decode(file);
  //             log ('[File Content]: $fileContent');
  //
  //             if (mounted) {
  //               await showSimpleAlert(context, 'md found!', fileContent);
  //             }
  //           }
  //         }
  //       }
  //
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  // Future<void> _configureAmplify() async {
  //   try {
  //     final auth = AmplifyAuthCognito();
  //     final storage = AmplifyStorageS3();
  //     await Amplify.addPlugins([auth, storage]);
  //
  //     // call Amplify.configure to use the initialized categories in your app
  //     await Amplify.configure(amplifyconfig);
  //   } on Exception catch (e) {
  //     safePrint('An error occurred configuring Amplify: $e');
  //   }
  // }

  // Future _testDO() async {
  //   log('[_testDO]');
  //   //Test DO Space
  //   Spaces spaces = Spaces(
  //     region: 'open-dump.sgp1',
  //     accessKey: Env.doSpaceAccessKey,
  //     secretKey: Env.doSpaceSecret,
  //   );
  //
  //   for (String name in await spaces.listAllBuckets()) {
  //     log('bucket: $name');
  //     Bucket bucket = spaces.bucket(name);
  //     await for (BucketContent content in bucket.listContents(maxKeys: 3)) {
  //       log('key: ${content.key}');
  //     }
  //   }
  // }

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

      // Text(
      //   '[$_eventName]',
      //   style: Theme.of(context).textTheme.bodySmall,
      //   textAlign: TextAlign.center,
      // ),
      //
      // const SizedBox(
      //   height: 8,
      // ),

      TextButton(
          onPressed: _openPreviewBrowser,
          child: const Text('查看當前收集到的問題')),

    ]);
  }

  Future _trySubmitSpeculation() async {
    if (_speculationEditingController.text.isNotEmpty) {
      BusyDialog.show(context, message: '上傳中...');
      bool putResult = false;

      if (_eventName != null && _eventName!.isNotEmpty) {
        bool eventDirExist = await NeonWalker.isPathExist('/speculation_exchange/$_eventName/');
        if (!eventDirExist) {
          //Create the dir.
          await NeonWalker.createDirectory(path: '/speculation_exchange/$_eventName/');
        }

        if (_userName != null && _userName!.isNotEmpty) {
          //Try find the file for the user of this event.
          putResult = await NeonWalker.putFile(file: Uint8List.fromList(utf8.encode(_speculationEditingController.text)), path: '/speculation_exchange/$_eventName/$_userName.txt');
        }
      }

      if (mounted) {
        context.pop();
      }

      if (mounted) {
        if (putResult) {
          await showSimpleAlert(context, 'Ya!', '儲存成功！');
        } else {
          await showSimpleAlert(context, 'Oh No!', '儲存失敗！');
        }
      }
    }
  }

  Future _openPreviewBrowser() async {
    if (_eventName != null && _eventName!.isNotEmpty) {
      Map<String, String> params = {
        'event': _eventName!,
      };

      await context.push('/SpeculationPreviewBrowser', extra: params);
    }
  }

}
