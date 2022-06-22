import 'package:haloecg/global_var.dart';
import 'package:haloecg/models/user_model.dart';
import 'package:haloecg/pages/chatting.dart';
import 'package:flutter/material.dart';
import 'package:haloecg/pages/Login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:haloecg/utils/const.dart';

class Settings extends StatefulWidget {
  final UserModel user;

  const Settings({Key key, @required this.user}) : super(key: key);
  @override
  _Settings createState() => _Settings();
}

class _Settings extends State<Settings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
          backgroundColor: widget.user.tipeUser == "0"
              ? Constants.darkOrange
              : Constants.darkGreen,
          centerTitle: true,
          title: Text("Settings"),
        ),
        backgroundColor: widget.user.tipeUser == "0"
            ? Constants.lightYellow
            : Constants.lightGreen,
        body: ListView(padding: EdgeInsets.only(left: 0, right: 0), children: [
          Card(
              child: Container(
            padding: const EdgeInsets.all(10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.edit),
                  Container(
                      child: Flexible(
                          child: Container(
                              // constraints: BoxConstraints(
                              //   maxWidth: MediaQuery.of(context).size.width * 0.9,
                              //   minHeight: MediaQuery.of(context).size.width * 0.15,
                              //   maxHeight: MediaQuery.of(context).size.width * 0.15,
                              // ),
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Edit Profil',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromRGBO(43, 112, 157, 1),
                                        )),
                                    SizedBox(height: 10),
                                    // Text('${dataRiwayatChat[index]["hospital"]}',
                                    //     maxLines: 1,
                                    //     overflow: TextOverflow.ellipsis,
                                    //     style: TextStyle(fontSize: 14)),
                                  ]))))
                ]),
          )),
          GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => Login()),
                    (Route<dynamic> route) => false);
              },
              child: Card(
                  child: Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.logout),
                      Container(
                          child: Flexible(
                              child: Container(
                                  // constraints: BoxConstraints(
                                  //   maxWidth: MediaQuery.of(context).size.width * 0.9,
                                  //   minHeight: MediaQuery.of(context).size.width * 0.15,
                                  //   maxHeight: MediaQuery.of(context).size.width * 0.15,
                                  // ),
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('Logout',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Color.fromRGBO(
                                                  43, 112, 157, 1),
                                            )),
                                        SizedBox(height: 10),
                                        // Text('${dataRiwayatChat[index]["hospital"]}',
                                        //     maxLines: 1,
                                        //     overflow: TextOverflow.ellipsis,
                                        //     style: TextStyle(fontSize: 14)),
                                      ]))))
                    ]),
              )))
        ]));
  }
}
