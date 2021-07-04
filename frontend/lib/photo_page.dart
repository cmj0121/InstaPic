import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

import 'config.dart';
import 'upload_page.dart';
import 'login_page.dart';
import 'user.dart';


// the image widget to show the upload image
class CustomizedImage extends StatelessWidget {
  final String? link;
  final String? desc;
  final String? username;

  CustomizedImage({
    @required this.link,
    @required this.desc,
    @required this.username,
  });

  factory CustomizedImage.fromJson(Map<String, String> json) {
    return CustomizedImage(
      link: json['link']!,
      desc: json['desc']!,
      username: json['username']!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Expanded(
            child: CachedNetworkImage(
              imageUrl: link!,
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
            ),
          ),
          Text(
            desc ?? '',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          TextButton(
            child: Text(
              username ?? '',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            onPressed: () => Navigator.of(context).pushNamed(InstaPicPage.route),
          ),
        ],
      ),
    );
  }
}

// the main InstaPic photo viewer
class InstaPicPage extends StatefulWidget {
  static const String route = '/';

  final String title;

  InstaPicPage({
    required this.title,
  });

  @override
  _InstaPicState createState() => _InstaPicState();
}

class _InstaPicState extends State<InstaPicPage> {
  final String session_key = 'session';

  bool _loading = false;
  User user = User.fromCookie();
  List<CustomizedImage> _images = [];
  ScrollController _controller = ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

  @override
  void initState() {
    super.initState();

    // load more image when scroll to bottom
    _controller.addListener(() {
      if (!_loading && _controller.offset == _controller.position.maxScrollExtent) {
        setState(() {
          _loading = true;
        });
        fetchImage();
      }
    });

    // load first images
    fetchImage();
  }

  @override
  Widget build(BuildContext context) {
    if (user.username == null) {
      return UserLoginPage(title: widget.title);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          user,
        ],
      ),
      body: Center(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: <Widget>[
                  Expanded(
                    child: photoPage(context, constraints),
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
        onPressed: () => Navigator.of(context).pushNamed(UploadPage.route),
      ),
    );
  }

  Widget photoPage(BuildContext context, BoxConstraints constraints) {
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

  void fetchImage() async {
    Random random = new Random();

    final resp = await http.get(
      baseURI.replace(path: '/api/posts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorizer': user.session(),
      },
    );

    switch (resp.statusCode) {
      case 200:
        List data = json.decode(utf8.decode(resp.bodyBytes));
        List<CustomizedImage> images = data.map( (item) => CustomizedImage.fromJson(item) ).toList();

        setState(() {
          _images.addAll(images);
          _loading = images.length > 0 ? false : true;
        });
        break;
      case 401:
        print('not login yet');
        Navigator.of(context).pushReplacementNamed(UserLoginPage.route);
        break;
      default:
        print('Unknown error: ${resp.statusCode}');
        break;
    }
  }
}

// vim: set ts=2 sw=2 expandtab:
