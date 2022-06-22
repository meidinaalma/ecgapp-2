import 'package:flutter/material.dart';

class ChatDokter extends StatelessWidget {
  const ChatDokter({Key key, this.foto, this.pesan, this.jam})
      : super(key: key);

  final String foto, pesan, jam;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(foto),
              minRadius: 20,
              maxRadius: 20,
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.65,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
                borderRadius: new BorderRadius.only(
                  topRight: const Radius.circular(20.0),
                  bottomLeft: const Radius.circular(20.0),
                  bottomRight: const Radius.circular(20.0),
                ),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '$pesan',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '$jam',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color.fromRGBO(43, 112, 157, 1),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
