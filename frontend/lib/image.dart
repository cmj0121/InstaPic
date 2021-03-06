import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'route.dart';


// the image widget to show the upload image
class CustomizedImage extends StatelessWidget {
  final String id;
  final String link;
  final String desc;
  final String username;

  CustomizedImage({
    required this.id,
    required this.link,
    required this.desc,
    required this.username,
  });

  factory CustomizedImage.fromJson(Map<String, dynamic> json) {
    return CustomizedImage(
      id: json['id'],
      link: json['link'],
      desc: json['desc'],
      username: json['username'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Expanded(
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
            ),
          ),
          Text(
            desc,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          TextButton(
            child: Text(
              username,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => IndexPage(user_filter: username)
            )),
          ),
        ],
      ),
    );
  }
}

// vim: set ts=2 sw=2 expandtab:
