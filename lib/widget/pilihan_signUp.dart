import 'package:flutter/material.dart';

import '../pages/SignUp.dart';
import '../utils/const.dart';

class PilihanSignUp extends StatelessWidget {
  const PilihanSignUp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Constants.lightYellow,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
          backgroundColor: Constants.darkOrange,
          title: const Text(
            'Create Account',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.only(left: 0, right: 0),
          shrinkWrap: true,
          children: <Widget>[
            Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SignUp(role: 0),
                      ),
                    );
                  },
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Image.asset(
                            "assets/icon/pasien.png",
                            width: 30,
                            height: 30,
                          ),
                          Container(
                            child: Flexible(
                              child: Container(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Patient',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Color.fromRGBO(43, 112, 157, 1),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SignUp(role: 1),
                      ),
                    );
                  },
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Image.asset(
                            "assets/icon/Dokter.png",
                            width: 30,
                            height: 30,
                          ),
                          Container(
                            child: Flexible(
                              child: Container(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Doctor',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Color.fromRGBO(43, 112, 157, 1),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
