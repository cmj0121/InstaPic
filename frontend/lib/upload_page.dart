import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';


class UploadPage extends StatefulWidget {
  final double width;
  final double height;

  UploadPage({
    this.width = 600,
    this.height = 400,
  });

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  Image? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  onPressed: () => Navigator.of(context).pop(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget imageZone(BuildContext context) {
    if (_image == null) {
      return dropZone(context);
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

  Widget dropZone(BuildContext context) {
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
