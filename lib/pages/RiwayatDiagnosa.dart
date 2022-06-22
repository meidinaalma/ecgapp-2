//import 'package:charts_flutter/flutter.dart';
import 'package:haloecg/global_var.dart';
import 'package:haloecg/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:haloecg/ChartECG.dart';
import 'package:haloecg/pages/DetailDiagnosa.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class RiwayatDiagnosa extends StatefulWidget {
  @override
  _RiwayatDiagnosaState createState() => _RiwayatDiagnosaState();
}

String isi_diagnosa = "";
String menitawal = "", menitakhir = "";
String detikawal = "", detikakhir = "";

class _RiwayatDiagnosaState extends State<RiwayatDiagnosa> {
  @override
  void initState() {
    ambilDataRiwayatDiagnosa();
    super.initState();
  }

  List dataRiwayatDiagnosa = [];

  void ambilDataRiwayatDiagnosa() async {
    var response;
    print("id pasien = " +
        id_pasien.toString() +
        ", id dokter = " +
        id_doctor.toString());
    var url = link + "RiwayatDiagnosa.php";
    response = await http.post(url, body: {
      "id_pasien": "${id_pasien}",
      "id_dokter": "${id_doctor}",
      "tanggal": "${tanggallihatgrafik}"
    });

    print(response);

    setState(() {
      dataRiwayatDiagnosa = json.decode(response.body);

      print(dataRiwayatDiagnosa);
    });
  }

  Widget ListRiwayatECG(BuildContext context, int index) {
    //print(dataRiwayatDiagnosa[index]);
    return GestureDetector(
      onTap: () {
        id_data_diagnosa = '${dataRiwayatDiagnosa[index]["id_data_diagnosa"]}';
        isi_diagnosa = '${dataRiwayatDiagnosa[index]["isi_diagnosa"]}';
        menitawal = '${dataRiwayatDiagnosa[index]["menit_awal"]}';
        detikawal = '${dataRiwayatDiagnosa[index]["detik_awal"]}';
        menitakhir = '${dataRiwayatDiagnosa[index]["menit_akhir"]}';
        detikakhir = '${dataRiwayatDiagnosa[index]["detik_akhir"]}';
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DetailDiagnosa()));
      },
      child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // CircleAvatar(
                  //   backgroundImage: NetworkImage(
                  //       '${link}${dataRiwayatDiagnosa[index]["profilePicture"]}'),
                  //   maxRadius: 25,
                  // ),
                  Container(
                      child: Flexible(
                          child: Container(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        '${dataRiwayatDiagnosa[index]["isi_diagnosa"]}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromRGBO(43, 112, 157, 1),
                                        )),
                                    SizedBox(height: 10),
                                    Text(
                                        '${dataRiwayatDiagnosa[index]["tanggal_diagnosa"]}' +
                                            " " +
                                            '${dataRiwayatDiagnosa[index]["waktu_diagnosa"]}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 14)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        "menit : " +
                                            '${dataRiwayatDiagnosa[index]["menit_awal"]}' +
                                            " " +
                                            "detik : " +
                                            '${dataRiwayatDiagnosa[index]["detik_awal"]}' +
                                            " ---> " +
                                            "menit : " +
                                            '${dataRiwayatDiagnosa[index]["menit_akhir"]}' +
                                            " " +
                                            "detik : " +
                                            '${dataRiwayatDiagnosa[index]["detik_akhir"]}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 14)),
                                  ]))))
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
        centerTitle: true,
        title: Text("Riwayat Diagnosa"),
        backgroundColor:
            role == "0" ? Constants.darkOrange : Constants.darkGreen,
      ),
      backgroundColor:
          role == "0" ? Constants.lightYellow : Constants.lightGreen,
      body: ListView(
        children: [
          Container(
              child: Column(
            children: [
              Container(
                  padding: EdgeInsets.only(top: 30, left: 20, right: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                              height: 20,
                              width: 100,
                              child: Text(
                                "Nama pasien",
                              )),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            ": " + '${name}',
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Container(
                              height: 20,
                              width: 100,
                              child: Text(
                                "Tanggal",
                              )),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            ": " + '${tanggallihatgrafik}',
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 20,
                            width: 100,
                            child: Text(
                              "Waktu rekaman",
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            ": " + '${jamlihatgrafik}',
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Container(
                              height: 20,
                              width: 100,
                              child: Text(
                                "Nama dokter",
                              )),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            ": " + '${doctor_name}',
                          ),
                        ],
                      )
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.all(10),
                    shrinkWrap: true,
                    itemCount: dataRiwayatDiagnosa == null
                        ? 0
                        : dataRiwayatDiagnosa.length,
                    itemBuilder: (BuildContext context, int index) =>
                        ListRiwayatECG(context, index)),
              )
            ],
          ))
        ],
      ),
    );
  }
}
