import 'dart:async';
import 'dart:convert';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:haloecg/models/user_model.dart';
import 'package:haloecg/service/ApiService.dart';
import 'package:haloecg/utils/const.dart';
import 'package:haloecg/widget/column_builder.dart';
import 'package:haloecg/widget/container_input_obat.dart';
import 'package:haloecg/widget/container_input_rujukan.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:haloecg/widget/my_button.dart';

class PageResepDokter extends StatefulWidget {
  final String idPasien, fotoProfile, nama;
  final UserModel user;
  const PageResepDokter(
      {Key key, this.idPasien, this.fotoProfile, this.nama, this.user})
      : super(key: key);

  @override
  State<PageResepDokter> createState() => _PageResepDokterState();
}

class _PageResepDokterState extends State<PageResepDokter> {
  String link = "http://haloecg.site/haloecgk/";
  final TextEditingController _controllerRujukan = TextEditingController();
  List<TextEditingController> _controllerNama = new List();
  List<TextEditingController> _controllerDosis = new List();
  List<TextEditingController> _controllerKeterangan = new List();
  List<TextEditingController> _controllerJumlah = new List();
  int jumlahResep = 1;
  var tanggalsekarang = DateTime.now();
  // final _key = new GlobalKey<FormState>();
  StreamController _postsController;

  loadPosts() async {
    ApiService()
        .ambilDataObat(widget.user.idDokter, widget.idPasien)
        .then((res) async {
      _postsController.add(res);
      return res;
    });
  }

  @override
  void initState() {
    ambilDataRujukan();
    _postsController = new StreamController();
    loadPosts();
    super.initState();
  }

  void ambilDataRujukan() async {
    try {
      var url = link + "ambil_rujukan.php";
      var response = await http.post(url, body: {
        "id_dokter": widget.user.idDokter,
        "id_pasien": widget.idPasien,
      });
      final data = jsonDecode(response.body);
      if (data['total'] > 0) {
        _controllerRujukan.text = data['keterangan'];
      }
    } catch (e) {
      throw (e);
    }
  }

  Future kirimRujukan() async {
    if (_controllerRujukan.text.isNotEmpty) {
      try {
        var url = link + "kirim_rujukan.php";
        await http.post(url, body: {
          "id_dokter": widget.user.idDokter,
          "id_pasien": widget.idPasien,
          "tanggal": tanggalsekarang.toString(),
          "keterangan": _controllerRujukan.text,
        });
      } catch (e) {
        throw (e);
      }
    }
  }

  Future kirimObat() async {
    for (int i = 0; i < _controllerNama.length; i++) {
      if (_controllerNama[i].text.isNotEmpty &&
          _controllerDosis[i].text.isNotEmpty &&
          _controllerKeterangan[i].text.isNotEmpty &&
          _controllerJumlah[i].text.isNotEmpty) {
        String tanggal = DateFormat('yyyy-mm-dd').format(tanggalsekarang);
        try {
          // print(widget.user.idDokter);
          // print(widget.idPasien);
          // print(tanggal);
          // print(_controllerNama[i].text);
          // print(_controllerDosis[i].text);
          // print(_controllerJumlah[i].text);
          // print(_controllerKeterangan[i].text);
          var url = link + "kirim_resep.php";
          var response = await http.post(url, body: {
            "id_dokter": widget.user.idDokter,
            "id_pasien": widget.idPasien,
            "tanggal": tanggalsekarang.toString(),
            "obat": _controllerNama[i].text,
            "dosis": _controllerDosis[i].text,
            "jumlah": _controllerJumlah[i].text,
            "keterangan": _controllerKeterangan[i].text,
          });
          // print(widget.user.idDokter);
          print(i);
          print(response.body);
          Fluttertoast.showToast(
              msg: "Berhasil Mengirim Surat Rujukan dan Resep Obat");
        } catch (e) {
          throw (e);
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controllerRujukan.dispose();
    for (int i = 0; i < _controllerNama.length; i++) {
      _controllerNama[i].dispose();
      _controllerDosis[i].dispose();
      _controllerKeterangan[i].dispose();
      _controllerJumlah[i].dispose();
    }
  }

  void addController() async {
    _controllerNama.add(new TextEditingController());
    _controllerDosis.add(new TextEditingController());
    _controllerKeterangan.add(new TextEditingController());
    _controllerJumlah.add(new TextEditingController());
  }

  void removeController() {
    _controllerNama.removeLast();
    _controllerDosis.removeLast();
    _controllerKeterangan.removeLast();
    _controllerJumlah.removeLast();
  }

  // check() {
  //   if (_controllerNama.isNotEmpty) {
  //     final form = _key.currentState;
  //     if (form.validate()) {
  //       form.save();
  //     }
  //   }
  // }

  void isiDataController(dynamic data, int index) {
    _controllerNama[index].text = data['$index']['nama_obat'];
    _controllerJumlah[index].text = data["$index"]['jumlah'];
    _controllerDosis[index].text = data["$index"]['dosis'];
    _controllerKeterangan[index].text = data["$index"]['keterangan'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.lightGreen,
      appBar: AppBar(
        backgroundColor: Constants.darkGreen,
        title: Text("Resep Obat dan Surat Rujukan"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  child: Image.network("$link${widget.fotoProfile}"),
                ),
                Text(
                  widget.nama,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(Icons.chat),
              ],
            ),
            ContainerInputRujukan(
              controllerRujukan: _controllerRujukan,
            ),
            Expanded(
              child: StreamBuilder(
                // initialData: false,
                stream: _postsController.stream,
                builder: (context, snapshot) {
                  String output = "{total: 0}";
                  if (snapshot.hasData) {
                    if (snapshot.data.toString() == output) {
                      return ColumnBuilder(
                        itemBuilder: ((context, index) {
                          addController();
                          return ContainerInputObat(
                            controllerNama: _controllerNama[index],
                            controllerDosis: _controllerDosis[index],
                            controllerKeterangan: _controllerKeterangan[index],
                            controllerJumlah: _controllerJumlah[index],
                          );
                        }),
                        itemCount: jumlahResep,
                      );
                    } else {
                      return ColumnBuilder(
                        itemBuilder: ((context, index) {
                          addController();

                          isiDataController(snapshot.data, index);
                          return ContainerInputObat(
                            controllerNama: _controllerNama[index],
                            controllerDosis: _controllerDosis[index],
                            controllerKeterangan: _controllerKeterangan[index],
                            controllerJumlah: _controllerJumlah[index],
                          );
                        }),
                        itemCount: int.parse(snapshot.data['total']),
                      );
                    }
                  } else {
                    return ColumnBuilder(
                      itemBuilder: ((context, index) {
                        addController();
                        return ContainerInputObat(
                          controllerNama: _controllerNama[index],
                          controllerDosis: _controllerDosis[index],
                          controllerKeterangan: _controllerKeterangan[index],
                          controllerJumlah: _controllerJumlah[index],
                        );
                      }),
                      itemCount: jumlahResep,
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (jumlahResep != 1) {
                        jumlahResep -= 1;
                        removeController();
                      }
                    });
                  },
                  child: Icon(Icons.remove_circle_rounded),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      jumlahResep += 1;
                      addController();
                    });
                  },
                  child: Icon(Icons.add_circle_rounded),
                ),
              ],
            ),
            SizedBox(height: 15),
            GestureDetector(
              onTap: () async {
                // check();
                await kirimRujukan();
                await kirimObat();
                Navigator.pop(context);
              },
              child: MyButton(text: "Kirim Resep dan Rujukan"),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
