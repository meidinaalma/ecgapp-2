import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:haloecg/models/user_model.dart';
import 'package:haloecg/service/ApiService.dart';
import 'package:haloecg/utils/const.dart';
import 'package:haloecg/widget/column_builder.dart';
import 'package:haloecg/widget/container_obat.dart';
import 'package:haloecg/widget/container_rujukan.dart';
import 'package:http/http.dart' as http;

class PageSuratRujukan extends StatefulWidget {
  final String nama, fotoProfile, idDokter;
  final UserModel user;
  const PageSuratRujukan(
      {Key key, this.nama, this.fotoProfile, this.idDokter, this.user})
      : super(key: key);

  @override
  State<PageSuratRujukan> createState() => _PageSuratRujukanState();
}

class _PageSuratRujukanState extends State<PageSuratRujukan> {
  int jumlahResep = 1;
  int data = 1;
  String link = "http://haloecg.site/haloecgk/";
  String rujukan = "";
  StreamController _postsController;

  loadPosts() async {
    ApiService()
        .ambilDataObat(widget.idDokter, widget.user.idPasien)
        .then((res) async {
      _postsController.add(res);
      return res;
    });
  }

  void ambilDataRujukan() async {
    try {
      var url = link + "ambil_rujukan.php";
      var response = await http.post(url, body: {
        "id_dokter": widget.idDokter,
        "id_pasien": widget.user.idPasien,
      });
      final data = jsonDecode(response.body);
      if (data['total'] > 0) {
        setState(() {
          rujukan = data['keterangan'];
        });
      }
      print(data);
      print(widget.idDokter);
      print(widget.user.idPasien);
    } catch (e) {
      throw (e);
    }
  }

  @override
  void initState() {
    ambilDataRujukan();
    _postsController = new StreamController();
    loadPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.lightYellow,
      appBar: AppBar(
        backgroundColor: Constants.darkOrange,
        title: Text("Resep Obat dan Surat Rujukan"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        image: DecorationImage(
                          image: NetworkImage(widget.fotoProfile),
                        ),
                      ),
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
                ContainerRujukan(
                  rujukan: rujukan,
                ),
                StreamBuilder(
                  stream: _postsController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      data++;
                      // return Container();
                      String output = "{total: 0}";
                      print(snapshot);
                      if (snapshot.data.toString() == output) {
                        return ColumnBuilder(
                          itemBuilder: ((context, index) {
                            return ContainerObat();
                          }),
                          itemCount: jumlahResep,
                        );
                      } else {
                        print("data = ${snapshot.data['total']}");
                        // jumlahResep++;
                        return ColumnBuilder(
                          itemBuilder: ((context, index) {
                            return ContainerObat(
                              namaObat: snapshot.data['$index']['nama_obat'],
                              dosisObat: snapshot.data['$index']['dosis'],
                              jumlahObat: snapshot.data['$index']['jumlah'],
                              keterangan: snapshot.data['$index']['keterangan'],
                            );
                          }),
                          itemCount: int.parse(snapshot.data['total']),
                        );
                      }
                    } else {
                      return ColumnBuilder(
                        itemBuilder: ((context, index) {
                          return ContainerObat();
                        }),
                        itemCount: jumlahResep,
                      );
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
