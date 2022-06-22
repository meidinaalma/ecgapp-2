import 'package:flutter/material.dart';

class ChatPasien extends StatelessWidget {
  const ChatPasien({Key key, this.pesan, this.jam}) : super(key: key);

  final String pesan, jam;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.65,
              ),
              decoration: BoxDecoration(
                color: Color.fromRGBO(43, 112, 157, 1),
                border: Border.all(color: Color.fromRGBO(43, 112, 157, 1)),
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(15.0),
                  bottomLeft: const Radius.circular(15.0),
                  bottomRight: const Radius.circular(15.0),
                ),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '$pesan',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '$jam',
                    style: TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 10,
                      color: Color.fromRGBO(138, 205, 231, 1),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      //),
    );
  }
}
