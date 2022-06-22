import 'package:haloecg/utils/const.dart';
import 'package:haloecg/utils/text_style.dart';
import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final String firstText, secondText;
  final Widget icon;

  const MenuCard(
      {Key key,
      @required this.firstText,
      @required this.secondText,
      @required this.icon})
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: icon,
            ),
            Text(firstText, style: titleStyle),
            Text(secondText, style: subTitleStyle),
          ],
        ),
      ),
    );
  }
}
