// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

Future<List<Photo>> fetchPhotos(
    http.Client client, int page, int pageSize) async {
  final response = await client.get(Uri.parse(
      'https://jsonplaceholder.typicode.com/photos?_page=$page&_limit=$pageSize'));

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
  final http.Client httpClient = http.Client();
  late StreamSubscription<ConnectivityResult> _subscription;
  bool _isConnected = false;

  static const _pageSize = 20;

  final PagingController<int, Photo> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _subscribeToConnectivityChanges();

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  void _checkConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      setState(() {
        _isConnected = true;
      });
      _pagingController.refresh();
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
        _pagingController.refresh();
      } else {
        setState(() {
          _isConnected = false;
        });
      }
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await fetchPhotos(httpClient, pageKey, _pageSize);

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    httpClient.close();
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo App',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
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
              ? RefreshIndicator(
                  onRefresh: () => Future.sync(
                    () => _pagingController.refresh(),
                  ),
                  child: PagedListView<int, Photo>(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<Photo>(
                      animateTransitions: false,
                      transitionDuration: const Duration(milliseconds: 500),
                      itemBuilder: (context, item, index) => PhotoList(
                        photos: [item],
                      ),
                    ),
                  ),
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
    return Column(
      children: photos.map((photo) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: Image.network(
              photo.thumbnailUrl,
              errorBuilder: (context, error, stackTrace) =>
                  Image.asset('assets/no-image.png'),
            ),
            title: Text(photo.title),
            subtitle: Text('ID: ${photo.id}'),
          ),
        );
      }).toList(),
    );
  }
}

// This project included functions...
//1. Get JsonHolder data from internet and show with list. (http)
//2. Check internet connection and refresh data depends on internet connection. (connectivity_plus *but version down)
//3. show error message when missing data on list for showing.
//4. fetch 20 data per one time to show with list. (infinite_scroll_pagination)