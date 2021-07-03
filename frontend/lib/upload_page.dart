import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import 'login_page.dart';
import 'user.dart';


// The upload page to upload image with optional description
class UploadPage extends StatefulWidget {
  static const String route = '/upload';

  final String title;
  final User? user;
  final double width;
  final double height;

  UploadPage({
    required this.title,
    this.user,
    this.width = 600,
    this.height = 400,
  });

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  Image? _image;
  User user = User.fromCookie();

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
        child: Container(
          width: widget.width,
          height: widget.height,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: imageZone(context),
                  ),
                ),
              ),
              TextField(
                // limit the input lenth to 32 chars
                maxLength: 32,
                decoration: InputDecoration(
                  labelText: 'description',
                  hintText: 'memo',
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: FlatButton(
                  child: Text(
                    'Uplaod',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () => uploadImage(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageZone(BuildContext context) {
    if (_image == null) {
      return InkWell(
        onTap: () => filePicker(),
        child: Center(
          child: Text(
            'Upload file',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      );
    }

    return Stack(
      children: <Widget>[
        Container(
          child: _image,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            child: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onTap: () {
              setState(() {
                _image = null;
              });
            },
          ),
        ),
      ]
    );
  }

  void uploadImage(BuildContext context) {
    if (_image == null) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: const Text('please select a image'),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.pop(context, 'Close'),
            ),
          ],
        ),
      );
      return ;
    }

    // upload image and back to privious page
    Navigator.of(context).pop();
  }

  void filePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );

    if (result != null) {
      PlatformFile file = result.files.single;

      setState(() {
        _image = Image.memory(file.bytes!);
      });
    }
  }
}

// vim: set ts=2 sw=2 expandtab:
