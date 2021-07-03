import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:universal_html/html.dart';


class CustomizedImage extends StatelessWidget {
  final String link;

  CustomizedImage(@required this.link);

  @override
  Widget build(BuildContext build) {
    return Card(
      // using cached_network_image to cache the image on local
      child: CachedNetworkImage(
        imageUrl: link,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => Icon(Icons.error),
        imageBuilder: (context, provider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: provider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      )
    );
  }
}

class InstaPicPage extends StatefulWidget {
  @override
  _InstaPicPage createState() => _InstaPicPage();
}

class _InstaPicPage extends State<InstaPicPage> {
  final String session_key = 'session';

  ScrollController _controller = ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

  bool _loading = false;
  List<CustomizedImage> _images = [];

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      if (!_loading && _controller.offset == _controller.position.maxScrollExtent) {
        setState(() {
          _loading = true;
        });
        fetchImage();
      }
    });

    fetchImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: <Widget>[
                  Expanded(
                    child: photo_page(context, constraints),
                  ),
                  Visibility(
                    visible: _loading,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: LinearProgressIndicator(
                        semanticsLabel: 'loading ...',
                      ),
                    ),
                  ),
                ],
              );
            }
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Photo',
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).pushNamed('/upload'),
      ),
    );
  }

  Widget photo_page(BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth > 1000) {
        return GridView.count(
          controller: _controller,
          crossAxisCount: 5,
          children: List.generate(_images.length, (index) => _images[index]),
        );
      } else if (constraints.maxWidth > 800) {
        return GridView.count(
          controller: _controller,
          crossAxisCount: 4,
          children: List.generate(_images.length, (index) => _images[index]),
        );
      } else if (constraints.maxWidth > 600) {
        return GridView.count(
          controller: _controller,
          crossAxisCount: 3,
          children: List.generate(_images.length, (index) => _images[index]),
        );
      }

      return GridView.count(
        controller: _controller,
        crossAxisCount: 2,
        children: List.generate(_images.length, (index) => _images[index]),
      );
  }

  Future<List<CustomizedImage>> fetchImage() async {
    Random random = new Random();

    print('fetching ...');
    final String link = 'https://dummyimage.com/250/ffffff/000000';
    List<CustomizedImage> imgs = List<CustomizedImage>.generate(random.nextInt(100), (_) => CustomizedImage(link)); 

    setState(() {
      _images.addAll(imgs);
      _loading = false;
    });

    return  _images;
  }
}

// vim: set ts=2 sw=2 expandtab:
