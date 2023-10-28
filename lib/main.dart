import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
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
  if (_url == null || _url.isEmpty) {
    print("URL is empty");
    return;
  }

  try {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      final videoData = response.bodyBytes;

      // 保存先のディレクトリを取得
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/downloaded_video.mp4';

      // ファイルに動画データを書き込む
      final file = File(filePath);
      await file.writeAsBytes(videoData);

      print("Video saved to $filePath");
    } else {
      print("Failed to download video. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("An error occurred: $e");
  }
}
}
