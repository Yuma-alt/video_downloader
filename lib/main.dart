import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  void _downloadVideo() {
    print('Downloading video from: $_url');
    // ここに実際のダウンロード処理を実装します
  }
}
