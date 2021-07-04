import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';


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

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
              onPressed: () => {}
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
              print('upload file ${file.name}');
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
}

// vim: set ts=2 sw=2 expandtab:
