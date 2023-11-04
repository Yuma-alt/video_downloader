import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Downloader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _url = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Downloader'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter Video URL',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _url = value;
                });
              },
            ),
            SizedBox(height: 20), // スペーシングを追加
            ElevatedButton(
              child: Text('Download Video'),
              onPressed: _downloadVideo,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadVideo() async {
    // パーミッションの要求
    await requestPermission();

    if (_url.isEmpty) {
      print("URL is empty");
      return;
    }

    try {
      final response = await http.get(Uri.parse(_url));

      if (response.statusCode == 200) {
        final videoData = response.bodyBytes;

        // ビデオファイルを一時的に内部ストレージに保存
        final tempDir = await getApplicationDocumentsDirectory();
        final tempFile = File('${tempDir.path}/temp_video.mp4');
        await tempFile.writeAsBytes(videoData);

        // ビデオを外部ストレージのダウンロードディレクトリに移動
        final savedPath = await saveVideo(tempFile);

        print("Video saved to $savedPath");
      } else {
        print("Failed to download video. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  Future<void> requestPermission() async {
    await Permission.storage.request();
    if (await Permission.manageExternalStorage.request().isGranted) {
      // 外部ストレージへのアクセスが許可された後の処理
    }
  }

  Future<String> saveVideo(File videoFile) async {
    final Directory? directory = await getExternalStorageDirectory();
    if (directory == null) {
      throw Exception('Cannot find the external directory');
    }

    // Downloadディレクトリへのパスを作成
    final String downloadPath = '${directory.path}/Download';
    final downloadDir = Directory(downloadPath);

    // Downloadディレクトリが存在しない場合は作成
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }

    // 新しいファイルパス
    final String newPath = '$downloadPath/downloaded_video.mp4';

    // 動画ファイルを新しいパスにコピー
    final File newVideo = await videoFile.copy(newPath);

    return newVideo.path;
  }

  Future<String> saveFileToDownloadsDirectory(File file) async {
    // External storage directory (Downloads folder)
    Directory? downloadsDirectory = await getExternalStorageDirectory();

    // Path to the Downloads directory
    String downloadsPath = downloadsDirectory!.path;

    // Creating a new file name with the current time stamp
    String newFileName =
        'downloaded_video_${DateTime.now().millisecondsSinceEpoch}.mp4';

    // Full path for the new file in Downloads
    String fullPath = '$downloadsPath/$newFileName';

    // Copying the file to the new path
    File newFile = await file.copy(fullPath);

    return newFile.path;
  }
}
