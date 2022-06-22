import 'package:haloecg/widget/radial.dart';
import 'package:haloecg/utils/text_style.dart';
import 'package:flutter/material.dart';

class InfoDokter extends StatelessWidget {
  final String fotoProfile, namaDokter;

  const InfoDokter({Key key, this.fotoProfile, this.namaDokter})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    String link = "http://haloecg.site/haloecgk/";
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RadialProgress(
              width: 4,
              goalCompleted: 0.9,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(link + fotoProfile),
              )),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                namaDokter,
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
