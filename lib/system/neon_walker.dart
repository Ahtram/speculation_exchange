import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:nextcloud/nextcloud.dart';

//The next cloud webdav API static class.
class NeonWalker {
  //The nextCloud client.
  static NextcloudClient? _nextcloudClient;

  static const String _hrefPrefix = '/nextCloud/remote.php/webdav';

  //Initialize the class.
  static void init({required String endPoint, required String loginName, required String password}) {
    _nextcloudClient = NextcloudClient(Uri.parse(endPoint), loginName: loginName, password: password);
  }

  static bool hasInitialized() {
    return _nextcloudClient != null;
  }


  //Check if a path is exist. (File or dir)
  static Future<bool> isPathExist(String path) async {
    if (!hasInitialized()) {
      return false;
    }

    try {
      WebDavMultistatus webDavMultiStatuses = await _nextcloudClient!.webdav.propfind(PathUri.parse(path));
      for (WebDavResponse webDavResponse in webDavMultiStatuses.responses) {
        if (webDavResponse.href != null) {
          String responsePath = webDavResponse.href!.replaceFirst(_hrefPrefix, '');
          if (responsePath == path) {
            return true;
          }
        }
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  //List all directories under the path.
  static Future<List<String>> listDirectories({String? path}) async {
    if (!hasInitialized()) {
      return [];
    }

    List<String> returnValues = [];
    path ??= '/';

    try {
      WebDavMultistatus webDavMultiStatuses = await _nextcloudClient!.webdav.propfind(PathUri.parse(path));

      for (WebDavResponse webDavResponse in webDavMultiStatuses.responses) {

        if (webDavResponse.href != null) {
          if (webDavResponse.href!.endsWith('/')) {
            //This is a dir.
            String resPath = webDavResponse.href!.replaceFirst(_hrefPrefix, '');
            if (resPath != path) {
              returnValues.add(resPath);
            }
          } else {
            //This is a file. Do nothing.
          }
        }
      }
    } catch (e) {
      //Huh?
    }

    return returnValues;
  }

  //List all files under the path.
  static Future<List<String>> listFiles({String? path}) async {
    if (!hasInitialized()) {
      return [];
    }

    List<String> returnValues = [];
    path ??= '/';

    try {
      WebDavMultistatus webDavMultiStatuses = await _nextcloudClient!.webdav.propfind(PathUri.parse(path));

      for (WebDavResponse webDavResponse in webDavMultiStatuses.responses) {

        if (webDavResponse.href != null) {
          if (webDavResponse.href!.endsWith('/')) {
            //This is a dir. Do nothing.

          } else {
            //This is a file.
            String resPath = webDavResponse.href!.replaceFirst(_hrefPrefix, '');
            returnValues.add(resPath);
          }
        }
      }
    } catch (e) {
      //Huh?
    }

    return returnValues;
  }

  //Try create the directory.
  static Future<bool> createDirectory({required String path}) async {
    if (!hasInitialized()) {
      return false;
    }

    try {
      HttpClientResponse httpClientResponse = await _nextcloudClient!.webdav.mkcol(PathUri.parse(path));
      if (httpClientResponse.statusCode == HttpStatus.created) {
        return true;
      }
    } catch (e) {
      log('[NeonWalker.createDirectory]: $e');
    }

    return false;
  }

  //Try download a file at path.
  static Future<Uint8List?> getFile({required String path}) async {
    if (!hasInitialized()) {
      return null;
    }
    try {
      return await _nextcloudClient!.webdav.get(PathUri.parse(path));
    } catch (e) {
      log('[NeonWalker.getFile]: $e');
    }
    return null;
  }

  //Try upload a file at path.
  static Future<bool> putFile({required Uint8List file, required String path}) async {
    if (!hasInitialized()) {
      return false;
    }
    try {
      HttpClientResponse httpClientResponse = await _nextcloudClient!.webdav.put(file, PathUri.parse(path));
      log('[httpClientResponse.statusCode]: ${httpClientResponse.statusCode}');
      if (httpClientResponse.statusCode == HttpStatus.created || httpClientResponse.statusCode == HttpStatus.noContent) {
        return true;
      }
    } catch (e) {
      log('[NeonWalker.putFile]: $e');
    }
    return false;
  }

}
