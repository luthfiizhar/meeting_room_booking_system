import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PictureDetail extends StatelessWidget {
  PictureDetail({
    super.key,
    this.image,
    this.urlImage,
  });

  Uint8List? image;
  String? urlImage;

  Map<String, String> requestHeader = {
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Access-Control-Allow-Origin': '*'
  };

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.
    return Dialog(
      child: urlImage == ""
          ? Image.memory(image!)
          : Image.network(urlImage!, fit: BoxFit.cover),
    );
  }
}
