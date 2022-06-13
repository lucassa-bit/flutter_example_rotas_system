import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_html/html.dart' as html;

abstract class DownloadService {
  Future<void> download({required String url, required BuildContext context, required String fileName});
}

class WebDownloadService implements DownloadService {
  @override
  Future<void> download({required String url, required BuildContext context, required String fileName}) async {
    var windowReference = html.window.open(url, '_blank');
  }
}

class MobileDownloadService implements DownloadService {
  @override
  Future<void> download({required String url, required BuildContext context, required String fileName}) async{
    bool hasPermission = await _requestWritePermission();
    if (!hasPermission) return;

    const dir = '/storage/emulated/0/Download/';

    Dio dio = Dio();
    await dio.download(url, "$dir/$fileName.xlsx");

    final snackBar = SnackBar(
        content:
        Text('o arquivo se encontra $dir$fileName.xlsx'));
    Navigator.of(context, rootNavigator: true).pop();
    ScaffoldMessenger.of(context)
        .showSnackBar(snackBar);
  }

  Future<bool> _requestWritePermission() async {
    await Permission.storage.request();
    return await Permission.storage.request().isGranted;
  }
}