import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'upload.dart';
import 'login.dart';
import '../image.dart';
import '../requests.dart';


class IndexPage extends StatefulWidget {
  static const String route = '/';

  final String title;

  IndexPage(this.title);

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<IndexPage> {
  bool _loading = false;
  String? _username;
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
    fetchImage();
  }

  @override
  Widget build(BuildContext context) {
    _username = ModalRoute.of(context)!.settings.arguments as String?;

    return FutureBuilder<String>(
      future: api_username(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // show the loading page
          return CircularProgressIndicator();
        }

        final String username = snapshot.data!;
        if (username == '') {
          WidgetsBinding.instance?.addPostFrameCallback(
             (_) => Navigator.of(context).pushReplacementNamed(LoginPage.route)
          );
        }

        return builder(context);
      },
    );
  }

  Widget builder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => indexPage(context, constraints),
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

  Widget indexPage(BuildContext context, BoxConstraints constraints) {
    return Column(
      children: <Widget>[
        Expanded(
          child: rwdIndexPage(context, constraints),
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

  Widget rwdIndexPage(BuildContext context, BoxConstraints constraints) {
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
    final resp = await api_get_image(_username, '');

    switch (resp.statusCode) {
      case 200:
        List data = json.decode(utf8.decode(resp.bodyBytes));
        print('${data}');
        List<CustomizedImage> images = data.map( (item) => CustomizedImage.fromJson(item) ).toList();

        print('fetch ${images.length} posts');
        setState(() {
          _images.addAll(images);
          _loading = images.length > 0 ? false : true;
        });
        break;
      default:
        print('Unknown error: ${resp.statusCode}');
        break;
    }
  }
}

// vim: set ts=2 sw=2 expandtab:
