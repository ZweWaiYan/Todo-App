import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

  if (response.statusCode == 200) {
    return compute(parsePhoto, response.body);
  } else {
    throw Exception('Failed to load photos');
  }
}

List<Photo> parsePhoto(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

class Photo {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  const Photo({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      albumId: json['albumId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
}

class PhotoListPage extends StatefulWidget {
  const PhotoListPage({super.key});

  @override
  State<PhotoListPage> createState() => _PhotoListPageState();
}

class _PhotoListPageState extends State<PhotoListPage> {
  late Future<List<Photo>> futurePhotos;
  final http.Client httpClient = http.Client();
  late StreamSubscription<ConnectivityResult> _subscription;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _subscribeToConnectivityChanges();
  }

  void _checkConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      setState(() {
        _isConnected = true;
      });
      _fetchData();
    } else {
      setState(() {
        _isConnected = false;
      });
    }
  }

  void _subscribeToConnectivityChanges() {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        setState(() {
          _isConnected = true;
        });
        _fetchData();
      } else {
        setState(() {
          _isConnected = false;
        });
      }
    });
  }

  Future<void> _fetchData() async {
    setState(() {
      futurePhotos = fetchPhotos(httpClient);
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    httpClient.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photot App',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue, //use your hex code here
        ),
      ),
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Photo Lists',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: _isConnected
              ? FutureBuilder<List<Photo>>(
                  future: futurePhotos,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('An error has occurred!'),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _fetchData,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasData) {
                      return RefreshIndicator(
                        onRefresh: _fetchData,
                        child: PhotoList(photos: snapshot.data!),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No internet connection'),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _checkConnectivity,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class PhotoList extends StatelessWidget {
  const PhotoList({super.key, required this.photos});

  final List<Photo> photos;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.network(
            photos[index].thumbnailUrl,
            errorBuilder: (context, error, stackTrace) =>
                Image.asset('assets/no-image.png'),
          ),
          title: Text(photos[index].title),
          subtitle: Text('Album ID: ${photos[index].albumId}'),
          dense: true,
          onTap: () {},
        );
      },
    );
  }
}


// This project included functions...
//1. Get JsonHolder data from internet and show with list. (http)
//2. Check internet connection and refresh data depends on internet connection. (connectivity_plus *but version down)
//3. show error message when missing data on list for showing.