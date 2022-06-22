import 'package:haloecg/utils/const.dart';
import 'package:flutter/material.dart';

class OpaqueImage extends StatelessWidget {
  final String imageUrl;
  final String role;

  const OpaqueImage({Key key, @required this.imageUrl, @required this.role})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            imageUrl,
            width: double.maxFinite,
            height: double.maxFinite,
            fit: BoxFit.fill,
          ),
        ),
        Container(
          color: role == "1"
              ? Constants.darkGreen.withOpacity(0.85)
              : Constants.darkOrange.withOpacity(0.85),
        ),
      ],
    );
  }
}
