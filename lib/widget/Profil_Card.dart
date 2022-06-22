import 'package:haloecg/utils/const.dart';
import 'package:haloecg/utils/text_style.dart';
import 'package:flutter/material.dart';

class ProfilCard extends StatelessWidget {
  final String firstText, secondText;
  final Widget icon;
  final double widhh;

  const ProfilCard(
      {Key key,
      @required this.firstText,
      @required this.secondText,
      @required this.icon,
      @required this.widhh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          top: 16,
          bottom: 24,
          right: 16,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: icon,
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            Text(
              firstText,
              style: dataprofilstyle,
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.04),
            Text(":"),
            SizedBox(width: MediaQuery.of(context).size.width * 0.04),
            Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * widhh,
                ),
                child: Column(
                  children: [
                    Text(
                      secondText,
                      style: profilstyle,
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
