import 'package:haloecg/models/user_model.dart';
import 'package:haloecg/pages/chatting.dart';
import 'package:flutter/material.dart';
import 'package:haloecg/pages/page_resep_dokter.dart';
import 'package:haloecg/pages/page_rujukan.dart';
import 'package:haloecg/service/ApiService.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:haloecg/utils/const.dart';

class DaftarChat extends StatefulWidget {
  final UserModel user;
  final bool isResep, isPasien;
  final String title;

  const DaftarChat(
      {Key key,
      this.user,
      this.isResep = false,
      this.title = "Chat",
      this.isPasien = false})
      : super(key: key);
  @override
  _DaftarChat createState() => _DaftarChat();
}

class _DaftarChat extends State<DaftarChat> {
  String link = "http://haloecg.site/haloecgk/";
  String id_doctor, id_pasien;
  var data;
  @override
  void initState() {
    ambilDataRiwayatChat();
    super.initState();
  }

  List dataRiwayatChat = [];

  void ambilDataRiwayatChat() async {
    var response;
    if (widget.user.tipeUser == '0' || widget.user.tipeUser == null) {
      var url = "${link}chat_pasien.php";
      response = await http.post(url, body: {
        "id_user": "${widget.user.idPasien}",
      });
      print(response);
      print("ambil data");
    } else {
      var url = "${link}chat_dokter.php";
      response = await http.post(url, body: {
        "id_dokter": "${widget.user.idDokter}",
      });
      print(widget.user.idDokter);
    }

    setState(() {
      dataRiwayatChat = json.decode(response.body);
      print(dataRiwayatChat);
    });
  }

  Widget listDaftarChat(BuildContext context, int index) {
    //print(dataRiwayatChat[index]);
    return GestureDetector(
      onTap: () {
        String idPasangan;
        if (widget.user.tipeUser == '0') {
          idPasangan = '${dataRiwayatChat[index]["id_dokter"]}';
        } else {
          idPasangan = '${dataRiwayatChat[index]["id_pasien"]}';
        }
        if (widget.isResep == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => PageResepDokter(
                    idPasien: idPasangan,
                    fotoProfile: '${dataRiwayatChat[index]["foto_profil"]}',
                    nama: '${dataRiwayatChat[index]["name"]}',
                    user: widget.user,
                  )),
            ),
          );
        } else if (widget.isPasien == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => PageSuratRujukan(
                    idDokter: idPasangan,
                    fotoProfile:
                        '$link${dataRiwayatChat[index]["foto_profil"]}',
                    nama: '${dataRiwayatChat[index]["name"]}',
                    user: widget.user,
                  )),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                fotoProfile: '${dataRiwayatChat[index]["foto_profil"]}',
                idPasangan: idPasangan,
                nama: '${dataRiwayatChat[index]["name"]}',
                user: widget.user,
              ),
            ),
          );
        }
      },
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(
                    '$link${dataRiwayatChat[index]["foto_profil"]}'),
                maxRadius: 25,
              ),
              Container(
                child: widget.user.tipeUser == '0'
                    ? Flexible(
                        child: Container(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${dataRiwayatChat[index]["name"]}',
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
                      )
                    : Flexible(
                        child: Container(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${dataRiwayatChat[index]["name"]}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromRGBO(43, 112, 157, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
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
        title: Text(widget.title),
      ),
      backgroundColor: widget.user.tipeUser == "0"
          ? Constants.lightYellow
          : Constants.lightGreen,
      body: ListView.builder(
          padding: EdgeInsets.only(left: 0, right: 0),
          shrinkWrap: true,
          itemCount: dataRiwayatChat == null ? 0 : dataRiwayatChat.length,
          itemBuilder: (BuildContext context, int index) =>
              listDaftarChat(context, index)),
    );
  }
}
