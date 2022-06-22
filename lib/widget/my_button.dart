import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key key, @required this.text}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 60),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), color: Colors.deepOrange
          //Color.fromRGBO(49, 39, 79, 1),
          ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
