import 'package:haloecg/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:haloecg/global_var.dart';

class OpaqueImageHome extends StatelessWidget {
  final imageUrl;
  final String role;

  const OpaqueImageHome({Key key, @required this.imageUrl, this.role})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          imageUrl,
          width: double.maxFinite,
          height: double.maxFinite,
          fit: BoxFit.fill,
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
