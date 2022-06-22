import 'package:haloecg/models/user_model.dart';
import 'package:haloecg/pages/chatting.dart';
import 'package:flutter/material.dart';
import 'package:haloecg/service/ApiService.dart';
import 'package:haloecg/widget/opaque_imageHome.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:haloecg/utils/const.dart';

import 'package:haloecg/utils/text_style.dart';
import 'package:haloecg/widget/Profil_Card.dart';
import 'package:haloecg/widget/opaque_image.dart';
import 'package:haloecg/widget/Info_dokter.dart';

class DaftarDokter extends StatefulWidget {
  final UserModel user;

  const DaftarDokter({Key key, this.user}) : super(key: key);
  @override
  _DaftarDokter createState() => _DaftarDokter();
}

class _DaftarDokter extends State<DaftarDokter> {
  String link = "http://haloecg.site/haloecgk/";
  String id_doctor,
      id_penerima,
      name_dok,
      foto_profil_dok,
      phone_dok,
      alamat_dok,
      email_dok;
  DateTime tanggal_lahir_dok;
  List<UserModel> dokter;

  @override
  void initState() {
    ambilDataDokter();
    super.initState();
  }

  List dataRiwayatChat = [];

  void ambilDataDokter() async {
    List<UserModel> user = await ApiService().ambilDataDokter();
    setState(() {
      dokter = user;
    });
  }

  Future<void> profDokter() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, //user must tap a button!
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.fromLTRB(30, 50, 30, 50),
          color: Colors.white,
          child: profileDokter(context),
        );
      },
    );
  }

  Widget profileDokter(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Stack(
                  children: <Widget>[
                    OpaqueImageHome(
                      imageUrl: "assets/images/kardiologi.jpg",
                      role: "0",
                      //"assets/images/robby.jpg",
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.arrow_back),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  color: Colors.white,
                                  iconSize: 30,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Profil",
                                    textAlign: TextAlign.left,
                                    style: headingTextStyle,
                                  ),
                                ),
                              ],
                            ),
                            InfoDokter(
                              fotoProfile: foto_profil_dok,
                              namaDokter: name_dok,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                    color: widget.user.tipeUser == "0"
                        ? Constants.lightYellow
                        : Constants.lightGreen,
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.all(8),
                      children: [
                        ProfilCard(
                          firstText: "Tanggal \n lahir",
                          secondText: DateFormat('dd-MM-yyyy')
                              .format(tanggal_lahir_dok),
                          icon: Icon(
                            Icons.calendar_today,
                            size: 30,
                          ),
                          widhh: 0.3,
                        ),

                        ProfilCard(
                          firstText: "Email",
                          secondText: email_dok,
                          icon: Icon(
                            Icons.email,
                            size: 30,
                          ),
                          widhh: 0.2,
                        ),
                        ProfilCard(
                          firstText: "HP.",
                          secondText: phone_dok,
                          icon: Icon(
                            Icons.phone,
                            size: 30,
                          ),
                          widhh: 0.3,
                        ),
                        ProfilCard(
                          firstText: "Alamat",
                          secondText: alamat_dok,
                          icon: Icon(
                            Icons.home_outlined,
                            size: 30,
                          ),
                          widhh: 0.2,
                        )
                        //   ],
                        // )
                      ],
                    )),
              ),
              new Divider(
                height: 10.0,
                color: Colors.transparent,
              ),
              new Container(
                decoration: new BoxDecoration(color: Colors.white),
                child: GestureDetector(
                    child: Icon(
                      Icons.chat,
                      color: Constants.darkOrange,
                      size: 30,
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          fotoProfile: foto_profil_dok,
                          idPasangan: id_doctor,
                          nama: name_dok,
                          user: widget.user,
                        ),
                      ));
                    }),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Widget listDaftarChat(BuildContext context, int index) {
    //print(dataRiwayatChat[index]);
    return GestureDetector(
      onTap: () {
        setState(() {
          id_doctor = '${dokter[index].idDokter}';
          id_penerima = "${widget.user.idPasien}";
          name_dok = '${dokter[index].name}';
          foto_profil_dok = '${dokter[index].fotoProfil}';
          tanggal_lahir_dok = DateTime.parse('${dokter[index].tanggalLahir}');
          phone_dok = '${dokter[index].phone}';
          alamat_dok = '${dokter[index].alamat}';
          email_dok = '${dokter[index].email}';
          // print(id_doctor);
          // print(id_penerima);
          // print(name_dok);
          // print(foto_profil_dok);
          profDokter();
        });
      },
      child: Card(
          child: Container(
        padding: const EdgeInsets.all(10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage('$link${dokter[index].fotoProfil}'),
            maxRadius: 25,
          ),
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
                    Text('${dokter[index].name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromRGBO(43, 112, 157, 1),
                        )),
                    SizedBox(height: 10),
                    // Text('${dataRiwayatChat[index]["hospital"]}',
                    //     maxLines: 1,
                    //     overflow: TextOverflow.ellipsis,
                    //     style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
          ),
        ]),
      )),
    );
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
        title: Text("Daftar Dokter"),
      ),
      backgroundColor: widget.user.tipeUser == "0"
          ? Constants.lightYellow
          : Constants.lightGreen,
      body: ListView.builder(
          padding: EdgeInsets.only(left: 0, right: 0),
          shrinkWrap: true,
          itemCount: dokter == null ? 0 : dokter.length,
          itemBuilder: (BuildContext context, int index) =>
              listDaftarChat(context, index)),
    );
  }
}
