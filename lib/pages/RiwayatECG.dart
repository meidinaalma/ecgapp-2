import 'package:haloecg/global_var.dart';
import 'package:haloecg/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:haloecg/ChartECG.dart';
import 'package:haloecg/pages/RiwayatDiagnosa.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RiwayatECG extends StatefulWidget {
  @override
  _RiwayatECGState createState() => _RiwayatECGState();
}

final bulan = TextEditingController();
final tahun = TextEditingController();

class _RiwayatECGState extends State<RiwayatECG> {
  @override
  void initState() {
    //ambilDataRiwayatECG();
    super.initState();
  }

  List dataRiwayatECG = [];

  void ambilDataRiwayatECG() async {
    var response;
    print("id pasien = " +
        id_pasien.toString() +
        ", id dokter = " +
        id_doctor.toString());
    if (role == "0") {
      var url = link + "RiwayatECGkususP.php";
      response = await http.post(url, body: {
        "id_pasien": "${id_pasien}",
        "bulan": "${bulan.text}",
        "tahun": "${tahun.text}",
        "id_dokter": "${id_doctor}"
      });
    } else {
      var url = link + "RiwayatECGkususD.php";
      response = await http.post(url, body: {
        "id_dokter": "${id_doctor}",
        "bulan": "${bulan.text}",
        "tahun": "${tahun.text}",
        "id_pasien": "${id_pasien}"
      });
    }
    print(response);

    setState(() {
      dataRiwayatECG = json.decode(response.body);

      print(dataRiwayatECG);
    });
  }

  Widget ListRiwayatECG(BuildContext context, int index) {
    //print(dataRiwayatECG[index]);
    return GestureDetector(
      onTap: () {
        // role == "0"
        //     ? {id_pasien = id_user, id_doctor = '${dataRiwayatECG[index]["id_dokter"]}'}
        //     : {id_pasien = '${dataRiwayatECG[index]["id_pasien"]}', id_doctor = id_user};
        doctor_name = '${dataRiwayatECG[index]["nama_lengkap"]}';
        tanggallihatgrafik = '${dataRiwayatECG[index]["tanggal"]}';
        jamlihatgrafik = "${dataRiwayatECG[index]["clock"]}";
        print("id pasien = " +
            id_pasien.toString() +
            ", id dokter = " +
            id_doctor.toString());
        role == "1"
            ? Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChartECGsignal()))
            : Navigator.push(context,
                MaterialPageRoute(builder: (context) => RiwayatDiagnosa()));
      },
      child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <
                Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(
                    '${link}${dataRiwayatECG[index]["profilePicture"]}'),
                maxRadius: 25,
              ),
              Container(
                  child: role == '0'
                      ? Flexible(
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
                                    Text(
                                        '${dataRiwayatECG[index]["nama_lengkap"]}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromRGBO(43, 112, 157, 1),
                                        )),
                                    SizedBox(height: 10),
                                    Text(
                                        '${dataRiwayatECG[index]["tanggal"]}' +
                                            " " +
                                            '${dataRiwayatECG[index]["clock"]}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 14)),
                                  ])))
                      : Flexible(
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
                                    SizedBox(
                                      height: 17,
                                    ),
                                    Text(
                                        '${dataRiwayatECG[index]["nama_lengkap"]}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Color.fromRGBO(
                                                43, 112, 157, 1))),
                                    SizedBox(height: 10),
                                    Text(
                                        '${dataRiwayatECG[index]["tanggal"]}' +
                                            " " +
                                            '${dataRiwayatECG[index]["clock"]}',
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
    var maskFormatter2digit = new MaskTextInputFormatter(
        mask: '##',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);
    var maskFormatter4digit = new MaskTextInputFormatter(
        mask: '####',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
          centerTitle: true,
          title: Text("Riwayat ECG"),
          backgroundColor:
              role == "0" ? Constants.darkOrange : Constants.darkGreen,
        ),
        backgroundColor:
            role == "0" ? Constants.lightYellow : Constants.lightGreen,
        body: Container(
          child: Column(
            children: [
              Container(
                height: 70,
                //margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 3),
                        blurRadius: 5,
                        color: Color.fromRGBO(43, 112, 157, 1))
                  ],
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                        child: TextFormField(
                      controller: bulan,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Input bulan terlebih dahulu';
                        } else if (value.length != 10) {
                          return 'Input bulan dengan benar';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "masukkan bulan mm",
                      ),
                      inputFormatters: [maskFormatter2digit],
                    )),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                        child: TextFormField(
                      controller: tahun,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Input tahun terlebih dahulu';
                        } else if (value.length != 10) {
                          return 'Input tahun dengan benar';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "masukkan tahun yyyy",
                      ),
                      inputFormatters: [
                        maskFormatter4digit
                        // MaskedInputFormatter('0000',
                        //     anyCharMatcher: RegExp(
                        //         r'^(0[1-9]|1[012])[-/.](0[1-9]|[12][0-9]|3[01])[-/.](19|20)\\d\\d$'))
                      ],
                    )),
                    SizedBox(
                      width: 20,
                    ),
                    IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () => {ambilDataRiwayatECG()}),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              new Divider(
                height: 1.0,
                color: Colors.transparent,
              ),
              SizedBox(
                height: 10,
              ),
              Flexible(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.all(10),
                    shrinkWrap: true,
                    itemCount:
                        dataRiwayatECG == null ? 0 : dataRiwayatECG.length,
                    itemBuilder: (BuildContext context, int index) =>
                        ListRiwayatECG(context, index)),
              )
            ],
          ),
        ));
  }
}
