import 'dart:convert';
import 'dart:io';
import 'package:haloecg/pages/RiwayatDiagnosa.dart';
import 'package:haloecg/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For using PlatformException
// For performing some operations asynchronously
import 'dart:async';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:http/http.dart' as http;
import 'package:haloecg/utils/const.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';

class DetailDiagnosa extends StatefulWidget {
  DetailDiagnosa() : super();

  // final String title = "File Operations";
  @override
  _DetailDiagnosaState createState() => _DetailDiagnosaState();
}

class _DetailDiagnosaState extends State<DetailDiagnosa> {
  bool _animation;
  var ecgDatalist;

  List<String> daftarmenit = [];

  List<String> daftardetik = [];
  bool visible = false;
  final controllerDiagnosa = TextEditingController();
  String data_diagnosa = isi_diagnosa;

  // void ambilDiagnosa() async {
  //   var url = link + "ambil_diagnosa.php";

  //   try {
  //     var response = await http.post(url, body: {
  //       "id_user": id_user.toString(),
  //       "id_dokter": id_doctor.toString(),
  //       "menit": menit.text,
  //       "detik": detik.text,
  //       "tanggal": '${tanggallihatgrafik}',
  //     });
  //     Fluttertoast.showToast(msg: "berhasil mengambil data");
  //     print(response.body);
  //     final data = jsonDecode(response.body);
  //     setState(() {
  //       data_diagnosa = data.toString();
  //     });
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: "diagnosa kosong");
  //   }
  // }

  Future<List<EcgData>> ambilData() async {
    var url = link + "ambildetaildiagnosa.php";
    var response;

    response = await http.post(url, body: {
      "id_data_diagnosa": id_data_diagnosa,
    });

    var json = jsonDecode(response.body);
    print(response.body);
    if (response.statusCode != 0) {
      List<EcgData> ecgData = List<EcgData>.from(
          json.map((data) => EcgData.fromJson(data)).toList());
      setState(() {
        ecgDatalist = ecgData;
        //print((ecgDatalist[1].value1).toString());
      });
      return ecgData;
    }

    throw json["message"];
  }

  @override
  void initState() {
    //super.initState();
    _animation = true;
    //ambilMenit();
    //ambilDetik();
    ambilData();
    print(ecgDatalist);
    KeyboardVisibilityNotification().addNewListener(
      onChange: (visible) {
        print(visible);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            role == "0" ? Constants.lightYellow : Constants.lightGreen,
        appBar: AppBar(
          backgroundColor:
              role == "0" ? Constants.darkOrange : Constants.darkGreen,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
          title: const Text('Grafik sinyal ECG'),
        ),
        body: ListView(children: [
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
                          "Waktu awal",
                        )),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      ": " + "menit ${menitawal} detik ${detikawal}",
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
                          "Waktu akhir",
                        )),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      ": " + "menit ${menitakhir} detik ${detikakhir}",
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border.all(color: Color.fromRGBO(43, 112, 157, 1)),
                      borderRadius: new BorderRadius.all(Radius.circular(30))),
                  padding: const EdgeInsets.all(10.0),
                  child: SfCartesianChart(
                      //backgroundColor: Colors.amber,
                      enableAxisAnimation: _animation,
                      zoomPanBehavior: ZoomPanBehavior(enablePanning: true),
                      enableSideBySideSeriesPlacement: false,
                      plotAreaBorderWidth: 4,
                      plotAreaBorderColor: Colors.black38,
                      title: ChartTitle(
                          text: 'ECG DATA', alignment: ChartAlignment.near),
                      primaryXAxis: CategoryAxis(
                          interval: 20,
                          rangePadding: ChartRangePadding.auto,
                          axisLine: AxisLine(color: Colors.black38),
                          majorGridLines: MajorGridLines(width: 1),
                          minorGridLines: MinorGridLines(width: 1),
                          visibleMaximum: 60,
                          visibleMinimum: 0,
                          edgeLabelPlacement: EdgeLabelPlacement.shift),
                      primaryYAxis: NumericAxis(
                          minimum: -100,
                          maximum: 900,
                          interval: 100,
                          rangePadding: ChartRangePadding.additional,
                          axisLine: AxisLine(color: Colors.black38),
                          majorGridLines: MajorGridLines(width: 1),
                          minorGridLines: MinorGridLines(width: 1),
                          edgeLabelPlacement: EdgeLabelPlacement.hide),
                      series: getseries()),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Diagnosa : ",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 270,
                  width: 400,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border.all(color: Color.fromRGBO(43, 112, 157, 1)),
                      borderRadius: new BorderRadius.all(Radius.circular(30))),
                  //padding: const EdgeInsets.all(10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: role == "1"
                        ? TextField(
                            controller: controllerDiagnosa,
                            minLines: 10,
                            maxLines: 15,
                            autocorrect: false,
                            decoration: InputDecoration(
                              hintText: 'Tulis diagnosa disini',
                              filled: true,
                              fillColor: Color.fromRGBO(233, 232, 232, 1),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                          )
                        : Text(data_diagnosa),
                  ),
                ),
              ],
            ),
          )
        ]));
  }

  List<ChartSeries<EcgData, String>> getseries() {
    return <ChartSeries<EcgData, String>>[
      SplineSeries<EcgData, String>(
        color: Colors.green,
        dataSource: ecgDatalist,
        xValueMapper: (EcgData sales, _) => sales.value1,
        yValueMapper: (EcgData sales, _) => sales.value2,
      ),
    ];
  }
}

class EcgData {
  EcgData({this.value1, this.value2});

  final String value1;
  final int value2;

  factory EcgData.fromJson(Map<String, dynamic> json) {
    return new EcgData(
      value1: json["jam"],
      value2: int.parse(json["data"]),
    );
  }
}

class Minute {
  Minute({this.waktu});

  final String waktu;
  factory Minute.fromJson(Map<String, dynamic> json) {
    return new Minute(
      waktu: json["waktu"],
    );
  }
}

class Second {
  Second({this.waktu});

  final String waktu;
  factory Second.fromJson(Map<String, dynamic> json) {
    return new Second(
      waktu: json["detik"],
    );
  }
}
