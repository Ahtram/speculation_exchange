
import 'dart:io';

import 'package:path/path.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

Future buildExportWeb() async {
  //1. Generate the aab with flutter command
  stdout.write('== Generate web with flutter command ==\n');
  Process process = await Process.start(
      'flutter',
      [
        'build',
        'web',
        '--base-href',
        '/speculation_exchange/',
        '--web-renderer',
        'html'
      ],
      runInShell: true);
  await stdout.addStream(process.stdout);
  stdout.write('🍌\n');

  //2. Export the built aab file to desktop
  stdout.write('== Export the built web file to docs ==\n');
  String scriptPath = dirname(Platform.script.toFilePath(windows: Platform.isWindows));
  Directory scriptDir = Directory(scriptPath);
  String projectPath = dirname(scriptDir.path);

  //Try copy web files.
  Directory webBuildDir = Directory('$projectPath/build/web/');
  Directory exportDir = Directory('$projectPath/docs/');

  //Clear stuffs.
  if (exportDir.existsSync()) {
    await exportDir.delete(recursive: true);
  }

  //Make sure we have the docs dir.
  if (!exportDir.existsSync()) {
    await exportDir.create();
  }

  if (webBuildDir.existsSync()) {
    stdout.write('Copying to exportDir...\n');
    await _copyDirectory(webBuildDir, exportDir);
    stdout.write('🍌🍌 Export web from [$webBuildDir] to [$exportDir] complete!\n');
  } else {
    stdout.write('Oops! webBuildDir not exist!\n');
  }
}

//Thanks for:
//https://gist.github.com/thosakwe/681056e86673e73c4710cfbdfd2523a8
Future<void> _copyDirectory(Directory source, Directory destination) async {
  await for (var entity in source.list(recursive: false)) {
    if (entity is Directory) {
      var newDirectory =
      Directory(join(destination.absolute.path, basename(entity.path)));
      await newDirectory.create();
      await _copyDirectory(entity.absolute, newDirectory);
    } else if (entity is File) {
      await entity.copy(join(destination.path, basename(entity.path)));
    }
  }
}