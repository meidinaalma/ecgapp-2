import 'package:haloecg/widget/radial.dart';
import 'package:haloecg/utils/text_style.dart';
import 'package:flutter/material.dart';

class MyInfo extends StatelessWidget {
  const MyInfo({Key key, this.imgUrl, this.name}) : super(key: key);
  final String imgUrl;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RadialProgress(
            width: 4,
            goalCompleted: 0.9,
            child: CircleAvatar(
              radius: 90,
              backgroundImage: NetworkImage(imgUrl),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                name,
                style: whiteNameTextStyle,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
