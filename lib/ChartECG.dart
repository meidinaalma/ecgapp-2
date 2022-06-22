import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haloecg/cubit/jantung_cubit.dart';
import 'package:haloecg/global_var.dart';
import 'package:flutter/material.dart';
// For performing some operations asynchronously
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:haloecg/models/user_model.dart';
import 'package:haloecg/pages/jantung_page.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'package:haloecg/utils/const.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ChartECGsignal extends StatefulWidget {
  final UserModel user;
  final String idDokter, idPasien, namaUser;
  ChartECGsignal(
      {@required this.user, this.idDokter, this.idPasien, this.namaUser})
      : super();

  // final String title = "File Operations";
  @override
  _ChartECGsignalState createState() => _ChartECGsignalState();
}

bool maxim = false, minim = false;

int menitawal, menitakhir, detikawal, detikakhir, waktuawal, waktuakhir;
final menit = TextEditingController();
final parameter = TextEditingController();
final detik = TextEditingController();
double vismax = 100;

class _ChartECGsignalState extends State<ChartECGsignal> {
  bool _animation;
  var ecgDatalist;

  List<String> daftarmenit = [];

  List<String> daftardetik = [];
  bool visible = false;
  final controllerDiagnosa = TextEditingController();
  String data_diagnosa = "";

  void kirimDiagnosa() async {
    DateTime sekarang = DateTime.now();
    String tanggal_diagnosa = DateFormat('yyyy-MM-dd').format(sekarang);
    TimeOfDay selectedTime = TimeOfDay.now();
    var jam = selectedTime.format(context);
    var url = link + "isi_diagnosa.php";

    if (controllerDiagnosa.text != "") {
      var response = await http.post(url, body: {
        "isi_diagnosa": controllerDiagnosa.text,
        "tanggal_diagnosa": tanggal_diagnosa.toString(),
        "waktu_diagnosa": jam.toString(),
        "id_pasien": id_pasien.toString(),
        "id_dokter": id_doctor.toString(),
        "menit0": menitawal.toString(),
        "detik0": detikawal.toString(),
        "menit1": menitakhir.toString(),
        "detik1": detikakhir.toString(),
        "tanggal": '${tanggallihatgrafik}',
      });
      Fluttertoast.showToast(msg: "berhasil mengirim diagnosa");
    } else {
      Fluttertoast.showToast(
          msg: "diagnosa kosong, isi form diagnosa terlebih dahulu");
    }
  }

  void konversiawal() {
    int limit = 15 * 60;
    waktuawal = (int.parse(menit.text) * 60) + int.parse(detik.text);
    waktuakhir = waktuawal + int.parse(parameter.text);
    if (waktuakhir > limit) {
      waktuakhir = limit;
    }
  }

  void konversiakhir() {
    menitawal = (waktuawal / 60).toInt();
    detikawal = waktuawal % 60;
    menitakhir = (waktuakhir / 60).toInt();
    detikakhir = waktuakhir % 60;
    print("menit0: " +
        menitawal.toString() +
        " detik0: " +
        detikawal.toString() +
        ", menit1: " +
        menitakhir.toString() +
        " detik1: " +
        detikakhir.toString());
  }

  void selanjutnya() {
    int limit = 15 * 60;
    vismax = 100;
    if (maxim == false) {
      minim = false;
      waktuawal = waktuakhir;
      waktuakhir = waktuakhir + int.parse(parameter.text);
      if (waktuakhir > limit) {
        waktuakhir = limit;
        maxim = true;
      }
    }
  }

  void sebelumnya() {
    int limit = 0 * 60;
    vismax = 100;
    if (minim == false) {
      maxim = false;
      waktuakhir = waktuawal;
      waktuawal = waktuawal - int.parse(parameter.text);
      if (waktuawal < limit) {
        waktuawal = limit;
        minim = true;
      }
    }
  }

  void ambilDiagnosa() async {
    var url = link + "ambil_diagnosa.php";

    try {
      var response;
      widget.user.tipeUser == "0"
          ? response = await http.post(url, body: {
              "id_pasien": widget.user.idPasien.toString(),
              "id_dokter": id_doctor.toString(),
              "menit": menit.text,
              "detik": detik.text,
              "tanggal": '${tanggallihatgrafik}',
            })
          : response = await http.post(url, body: {
              "id_pasien": id_pasien.toString(),
              "id_dokter": widget.user.idDokter.toString(),
              "menit": menit.text,
              "detik": detik.text,
              "tanggal": '${tanggallihatgrafik}',
            });
      Fluttertoast.showToast(msg: "berhasil mengambil data");
      print(response.body);
      final data = jsonDecode(response.body);
      setState(() {
        data_diagnosa = data.toString();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "diagnosa kosong");
    }
  }

  // void ambilMenit() async {
  //   var url = link + "ambilMenit.php";
  //   try {
  //     var response = await http.post(url, body: {
  //       "id_pasien": id_user.toString(),
  //       "id_dokter": id_doctor.toString(),
  //       "tanggal": tanggallihatgrafik.toString()
  //     });
  //     var json = jsonDecode(response.body);
  //     print(response.body);
  //     List<Minute> datamenit =
  //         List<Minute>.from(json.map((data) => Minute.fromJson(data)).toList());
  //     setState(() {
  //       for (int i = 0; i < datamenit.length; i++) {
  //         daftarmenit.add((datamenit[i].waktu).toString());
  //         //print(daftarmenit[i]);
  //       }
  //     });
  //   } catch (e) {
  //     //menit = '0';
  //     Fluttertoast.showToast(msg: "Tidak ada data");
  //   }
  // }

  // void ambilDetik() async {
  //   var url = link + "ambilDetik.php";
  //   try {
  //     var response = await http.post(url, body: {
  //       "id_pasien": id_user.toString(),
  //       "id_dokter": id_doctor.toString(),
  //       "tanggal": tanggallihatgrafik.toString(),
  //       "waktu": menit
  //     });
  //     var json = jsonDecode(response.body);
  //     print(response.body);
  //     List<Second> datadetik =
  //         List<Second>.from(json.map((data) => Second.fromJson(data)).toList());
  //     setState(() {
  //       for (int i = 0; i < datadetik.length; i++) {
  //         daftardetik.add((datadetik[i].waktu).toString());
  //         //print(daftarmenit[i]);
  //       }
  //     });
  //   } catch (e) {
  //     //detik = '0';
  //     Fluttertoast.showToast(msg: "Tidak ada data");
  //   }
  // }

  Future<List<EcgData>> ambilData() async {
    print("id_user: ${widget.idPasien}");
    print("id_dokter: ${widget.user.idDokter}");
    var url = link + "ambildataECG.php";
    var response;
    if (widget.user.tipeUser == "0") {
      response = await http.post(url, body: {
        "id_pasien": widget.user.idPasien.toString(),
        "id_dokter": id_doctor.toString(),
        "menit0": menitawal.toString(),
        "detik0": detikawal.toString(),
        "menit1": menitakhir.toString(),
        "detik1": detikakhir.toString(),
        "tanggal": tanggallihatgrafik.toString(),
        "waktu_rekaman": jamlihatgrafik.toString()
      });
    } else {
      response = await http.post(url, body: {
        "id_pasien": id_pasien.toString(),
        "id_dokter": widget.user.idDokter.toString(),
        "menit0": menitawal.toString(),
        "detik0": detikawal.toString(),
        "menit1": menitakhir.toString(),
        "detik1": detikakhir.toString(),
        "tanggal": tanggallihatgrafik.toString(),
        "waktu_rekaman": jamlihatgrafik.toString()
      });
    }
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
    //ambilData();
    print(ecgDatalist);
    KeyboardVisibilityNotification().addNewListener(
      onChange: (visible) {
        print(visible);
      },
    );
    //ambilDiagnosa();
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
        backgroundColor: widget.user.tipeUser == "0"
            ? Constants.lightYellow
            : Constants.lightGreen,
        appBar: AppBar(
          backgroundColor: widget.user.tipeUser == "0"
              ? Constants.darkOrange
              : Constants.darkGreen,
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
                      width: 100,
                      child: Text(
                        "Nama pasien",
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(
                        widget.user.tipeUser == "0"
                            ? ": ${widget.user.name}"
                            : ": ${widget.namaUser}",
                      ),
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
                    Expanded(
                      child: Text(
                        widget.user.tipeUser == "0"
                            ? ": ${widget.namaUser}"
                            : ": ${widget.user.name}",
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                margin:
                    EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color.fromRGBO(43, 112, 157, 1)),
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
                        visibleMaximum: vismax,
                        visibleMinimum: 0,
                        edgeLabelPlacement: EdgeLabelPlacement.shift),
                    primaryYAxis: NumericAxis(
                        minimum: 0,
                        maximum: 900,
                        interval: 100,
                        rangePadding: ChartRangePadding.additional,
                        axisLine: AxisLine(color: Colors.black38),
                        majorGridLines: MajorGridLines(width: 1),
                        minorGridLines: MinorGridLines(width: 1),
                        edgeLabelPlacement: EdgeLabelPlacement.hide),
                    series: getseries()),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      context
                          .read<JantungCubit>()
                          .getDataJantung(id_pasien.toString(), jamlihatgrafik);
                      return JantungPage(
                        idPasien: id_pasien,
                      );
                    }),
                  );
                },
                child: Text("Lihat Detak Jantung"),
              ),
              Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(width: 40),
                      Container(
                          height: 20,
                          width: 70,
                          child: Text(
                            "menit awal",
                          )),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        height: 20,
                        width: 30,
                        child: menitawal == null
                            ? Text("")
                            : Text(
                                ": " + '${menitawal.toString()}',
                              ),
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Container(
                        height: 20,
                        width: 70,
                        child: Text(
                          "menit akhir",
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      menitakhir == null
                          ? Text("")
                          : Text(
                              ": " + '${menitakhir.toString()}',
                            ),
                      SizedBox(width: 40),
                    ],
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 40),
                      Container(
                          height: 20,
                          width: 70,
                          child: Text(
                            "detik awal",
                          )),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        height: 20,
                        width: 30,
                        child: detikawal == null
                            ? Text("")
                            : Text(
                                ": " + '${detikawal.toString()}',
                              ),
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Container(
                          height: 20,
                          child: Text(
                            "detik akhir",
                          )),
                      SizedBox(
                        width: 20,
                      ),
                      detikakhir == null
                          ? Text("")
                          : Text(
                              ": " + '${detikakhir.toString()}',
                            ),
                      SizedBox(width: 40),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text('menit ke-'),
                      SizedBox(width: 10),
                      Container(
                        padding: EdgeInsets.only(top: 15),
                        height: 40,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 3),
                              blurRadius: 5,
                              color: Color.fromRGBO(43, 112, 157, 1),
                            )
                          ],
                        ),
                        child: TextFormField(
                          controller: menit,
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 1.0),
                              ),
                              hintText: "(0-14)"),
                          inputFormatters: [maskFormatter2digit],
                        ),
                      ),

                      SizedBox(
                        width: 20,
                      ),
                      Text('detik ke-'),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 15),
                          height: 40,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 3),
                                blurRadius: 5,
                                color: Color.fromRGBO(43, 112, 157, 1),
                              )
                            ],
                          ),
                          child: TextFormField(
                            controller: detik,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 1.0),
                                ),
                                hintText: "(1-59)"),
                            inputFormatters: [maskFormatter2digit],
                          )),
                      // DropdownButton(
                      //   items: daftardetik
                      //       .map<DropdownMenuItem<String>>((String value) {
                      //     return DropdownMenuItem<String>(
                      //       value: value,
                      //       child: Text(value),
                      //     );
                      //   }).toList(),
                      //   onChanged: (value) => setState(() => detik = value),
                      //   value: detik,
                      // ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('parameter range'),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 15),
                      height: 40,
                      width: 70,
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
                      child: TextFormField(
                        controller: parameter,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 1.0),
                            ),
                            hintText: "detik"),
                        inputFormatters: [maskFormatter2digit],
                      )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    color: Colors.orangeAccent,
                    onPressed: () =>
                        {sebelumnya(), konversiakhir(), ambilData()},
                    child: Text('Sebelumnya'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  RaisedButton(
                    color: Colors.orangeAccent,
                    onPressed: () =>
                        {selanjutnya(), konversiakhir(), ambilData()},
                    child: Text('Selanjutnya'),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                color: Colors.orangeAccent,
                onPressed: () => {konversiawal(), ambilData(), ambilDiagnosa()},
                child: Text('Tampilkan'),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: 270,
                width: 400,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color.fromRGBO(43, 112, 157, 1)),
                    borderRadius: new BorderRadius.all(Radius.circular(30))),
                //padding: const EdgeInsets.all(10.0),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: widget.user.tipeUser == "1"
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
              widget.user.tipeUser == "1"
                  ? RaisedButton(
                      color: Colors.orangeAccent,
                      onPressed: () => kirimDiagnosa(),
                      child: Text('Upload data diagnosa'),
                    )
                  : SizedBox(
                      height: 10,
                    )
            ],
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
