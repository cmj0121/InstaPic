import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'login.dart';
import 'index.dart';
import '../user.dart';
import '../requests.dart';


class UploadPage extends StatefulWidget {
  static const String route = '/upload';

  final String title;
  final double width;
  final double height;
  final int maxDescription;

  UploadPage(this.title, {
    this.width = 600,
    this.height = 400,
    // limit the input lenth to 32 chars
    this.maxDescription = 32,
  });

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<UploadPage> {
  Image? _image;
  String? _error_message;
  PlatformFile? _file;

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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

        return builder(context, username);
      },
    );
  }

  Widget builder(BuildContext context, String username) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          User(username),
        ]
      ),
      body: Center(
        child: uploadForm(context),
      ),
    );
  }

  Widget uploadForm(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                imageField(context),
                Visibility(
                  visible: _image != null,
                  child: Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onTap: () => setState( () { _image = null; } ),
                    ),
                  ),
                ),
              ]
            ),
          ),
          TextField(
            maxLength: widget.maxDescription,
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'description',
              hintText: 'memo',
            ),
          ),
          Opacity(
            opacity: _error_message != null ? 1.0 : 0.0,
            child: Text(
              _error_message ?? "<Error>",
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                color: Colors.red,
              ),
            )
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: TextButton(
              child: Text(
                'Uplaod',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => upload(),
            ),
          ),
        ],
      ),
    );
  }

  Widget imageField(BuildContext context) {
    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: imagePicker(context),
        ),
      ),
    );
  }

  Widget imagePicker(BuildContext context) {
    if (_image == null) {
      return InkWell(
        onTap: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['jpg', 'png'],
          );

          if (result != null) {
            PlatformFile file = result.files.single;

            setState(() {
              // get file
              _file = file;
              _image = Image.memory(file.bytes!);
            });
          }
        },
        child: Text(
          'select image',
        ),
      );
    }

    return _image!;
  }

  void upload() async {
    final resp = await api_upload_image(_file!, _controller.text);

    switch (resp.statusCode) {
      case 201:
        // upload success
        Navigator.of(context).pushReplacementNamed(IndexPage.route);
        break;
      default:
        setState( () {
          print('cannot upload: ${resp.statusCode}');
          _error_message = 'cannot upload: ${resp.statusCode}';
        });
        break;
    }
  }
}

// vim: set ts=2 sw=2 expandtab:
