library storage_service;

import 'dart:async';
import 'dart:io' as io;
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

String bucket = "users/";

class CloudStorageResult {
  final String url;
  final String? fileName;
  final int? fileSize;

  CloudStorageResult({required this.url, this.fileName, this.fileSize});
}

abstract class CloudStorageService {
  Future<CloudStorageResult> getFile(
      {required String bucket, required String fileName});
  FutureOr<CloudStorageResult> uploadFile({
    required File file,
    required String title,
    required String bucket,
  });
  Future deleteImage(String fileName);
}

class CloudStorageServiceAdapter implements CloudStorageService {
  @override
  Future<CloudStorageResult> getFile(
      {required String bucket, required String fileName}) async {
    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child(bucket + "/" + fileName);
    var downloadUrl = await firebaseStorageRef.getDownloadURL();
    return CloudStorageResult(
      url: downloadUrl,
      fileName: fileName,
    );
  }

  @override
  FutureOr<CloudStorageResult> uploadFile({
    required File file,
    required String title,
    required String bucket,
  }) async {
    try {
      var fileName = title + DateTime.now().millisecondsSinceEpoch.toString();
      final firebaseStorageRef =
          FirebaseStorage.instance.ref().child("/$bucket/$fileName");
      final uploadTask = kIsWeb
          ? firebaseStorageRef.putData(await file.readAsBytes())
          : firebaseStorageRef.putFile(io.File(file.path));

      var _storageTaskSnapshot = await uploadTask;
      int fileSize = _storageTaskSnapshot.totalBytes;
      var downloadUrl = await _storageTaskSnapshot.ref.getDownloadURL();
      String _url = downloadUrl.toString();
      return CloudStorageResult(
        url: _url,
        fileName: fileName + "_output.mp3",
        fileSize: fileSize,
      );
    } catch (e) {
      print('e $e');
      throw Exception(e);
    }
  }

  @override
  Future deleteImage(String fileName) async {
    final firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    try {
      await firebaseStorageRef.delete();
      return true;
    } catch (e) {
      return e.toString();
    }
  }
}
