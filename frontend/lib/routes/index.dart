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
  List<CustomizedImage> _images = [];
  ScrollController _controller = ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

  @override
  Widget build(BuildContext context) {
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
}

// vim: set ts=2 sw=2 expandtab:
