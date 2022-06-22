import 'package:flutter/material.dart';
import 'package:haloecg/models/user_model.dart';
import 'package:haloecg/widget/chat_dokter.dart';
import 'package:haloecg/widget/chat_pasien.dart';
import 'package:http/http.dart' as http;
import 'package:haloecg/pages/AddECGsignal.dart';
import 'package:haloecg/pages/RiwayatECG.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:async';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:haloecg/utils/const.dart';

class ChatScreen extends StatefulWidget {
  final String fotoProfile, nama, idPasangan;
  final UserModel user;

  const ChatScreen(
      {Key key, this.idPasangan, this.fotoProfile, this.nama, this.user})
      : super(key: key);

  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _textController = new TextEditingController();

  String templateChat =
      "Ini merupakan chat otomatis. Pertanyaan berikut harus dijawab sebelum melakukan telekonsul. Cukup dijawab menggunakan nomor dan jawaban. Berikut pertanyaannya:\n1. Apakah ada nyeri dada kiri? Apakah nyeri bisa dilokalisir spesifik tempatnya?\n2. Rasa nyeri apakah seperti tertindih beban berat? Tersayat2/tersobek2? Tajam? Ditusuk2?\n3. Apakah nyeri menjalar hingga ke lengan kiri/punggung/rahang?\n4. Berapa lama durasi apabila serangan / nyeri?\n5. Apakah nyeri dada membaik dengan istirahat? Apakah membaik dengan obat?\n6. Keluhan nyeri dada apakah sering muncul?\n7. Apakah ada faktor yg memicu munculnya serangan? (Mis. Setiap malam hari, setiap habis aktivitas, dll.) atau muncul tidak tentu?\n8. Apakah ada rasa menyesak atau panas di dada?\n9. Apakah saat ini ada rasa lebih mudah lelah setelah melakukan aktivitas normal yg sebelumnya tidak membuat lelah?\n10. Apakah lebih merasa nyaman apabila tidur dengan bantal ditumpuk tinggi?\n11. Apakah sering merasa sesak di malam hari hingga terbangun dari tidur?\n12. Apakah ada riwayat kedua kaki bengkak? Perut membesar?\n13. Apakah pernah / sedang merokok?\n14. Apakah memiliki penyakit Diabetes Melitus, Hipertensi, Dyslipidemia?\n15. Apakah ada rasa berdenyut di perut?\n16. Apakah sering ada rasa berdebar?\n17. Apakah ada riwayat sering pingsan?";

  String link = "http://haloecg.site/haloecgk/";
  var tanggalsekarang = DateTime.now();
  ScrollController scroll = ScrollController(initialScrollOffset: 50);
  bool _isComposing = false;
  bool tampilkanProfil = false;
  List dataChat = [];
  String foto;
  Timer _timer;
  int lenght_pesan = 0;
  bool visible = false;
  String idUser;
  bool adaPesan = false;

  void ambilDataPasanganChat() async {
    var url = link + "penerimaChat.php";
    var response = await http.post(url, body: {
      "id_penerima": widget.idPasangan,
    });
    // print(response.body);
    final profilpenerima = json.decode(response.body);

    setState(() {
      String urlFoto = profilpenerima['foto'];
      foto = "$link$urlFoto";
    });
  }

  void ambilDataRiwayat() async {
    var url = link + "lihat_chat.php";
    var response;
    if (widget.user.tipeUser == '0') {
      idUser = widget.user.idPasien;
      response = await http
          .post(url, body: {"id_dokter": widget.idPasangan, "id_user": idUser});
    } else {
      idUser = widget.user.idDokter;
      response = await http
          .post(url, body: {"id_dokter": idUser, "id_user": widget.idPasangan});
    }

    print("response lihat chat" + response.body.toString());

    setState(() {
      dataChat = json.decode(response.body);
      lenght_pesan = dataChat.length;
    });
  }

  kirimChat() async {
    if (adaPesan == true) {
      TimeOfDay selectedTime = TimeOfDay.now();
      var waktu = selectedTime.format(context);
      var url = link + "kirimChat.php";
      if (widget.user.tipeUser == '0') {
        await http.post(url, body: {
          "id_user": idUser,
          "id_dokter": widget.idPasangan,
          "pesan": _textController.text,
          "waktu": waktu.toString(),
          "tanggal": tanggalsekarang.toString(),
          "pengirim": widget.user.tipeUser,
        });
      } else {
        await http.post(url, body: {
          "id_user": widget.idPasangan,
          "id_dokter": idUser,
          "pesan": _textController.text,
          "waktu": waktu.toString(),
          "tanggal": tanggalsekarang.toString(),
          "pengirim": widget.user.tipeUser,
        });
      }
      _textController.clear();
      if (scroll.hasClients) {
        scroll.animateTo(0.0,
            duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
      }
    } else {
      Fluttertoast.showToast(msg: "Masukkan pesan terlebih dahulu");
    }
  }

  templateChatDokter() async {
    if (adaPesan == true) {
      TimeOfDay selectedTime = TimeOfDay.now();
      var waktu = selectedTime.format(context);
      var url = link + "kirimChat.php";
      var response = await http.post(url, body: {
        "id_user": idUser,
        "id_dokter": widget.idPasangan,
        "pesan": templateChat,
        "waktu": waktu.toString(),
        "tanggal": tanggalsekarang.toString(),
        "pengirim": "1",
      });
      _textController.clear();
      if (scroll.hasClients) {
        scroll.animateTo(0.0,
            duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
      }
      setState(() {
        lenght_pesan += 1;
      });
    } else {
      Fluttertoast.showToast(msg: "Masukkan pesan terlebih dahulu");
    }
  }

  Widget listChat(BuildContext context, int index, int length) {
    print(dataChat);
    if (dataChat[index]["pengirim"] == widget.user.tipeUser) {
      if (length == 1) {
        templateChatDokter();
        ambilDataRiwayat();
        return ChatPasien(
          pesan: dataChat[index]["pesan"],
          jam: dataChat[index]["jam"],
        );
      } else {
        return ChatPasien(
          pesan: dataChat[index]["pesan"],
          jam: dataChat[index]["jam"],
        );
      }
    } else {
      return ChatDokter(
        foto: '$link${widget.fotoProfile}',
        pesan: dataChat[index]["pesan"],
        jam: dataChat[index]["jam"],
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      ambilDataRiwayat();
    });
    if (scroll.hasClients) {
      scroll.animateTo(scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
    }
    KeyboardVisibilityNotification().addNewListener(
      onChange: (visible) {
        print(visible);
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: widget.user.tipeUser == "0"
            ? Constants.darkOrange
            : Constants.darkGreen,
        title: new Text(widget.nama),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
        actions: widget.user.tipeUser == "0"
            ? <Widget>[
                IconButton(
                    icon: Image.asset(
                      "assets/icon/pulse2.png",
                      width: 50,
                      height: 50,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddECGsignal(),
                        ),
                      );
                    }),
                IconButton(
                    icon: Icon(
                      Icons.list,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RiwayatECG(),
                        ),
                      );
                    })
              ]
            : <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.list,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RiwayatECG(),
                        ),
                      );
                    })
              ],
      ),
      backgroundColor: widget.user.tipeUser == "0"
          ? Constants.lightYellow
          : Constants.lightGreen,
      body: new Container(
        color: widget.user.tipeUser == "0"
            ? Constants.lightYellow
            : Constants.lightGreen,
        child: new Column(
          children: <Widget>[
            new Flexible(
              child: new ListView.builder(
                controller: scroll,
                padding: new EdgeInsets.all(10.0),
                reverse: true,
                itemBuilder: (_, int index) => listChat(
                  context,
                  index,
                  lenght_pesan,
                ),
                itemCount: dataChat.length,
              ),
            ),
            new Divider(
              height: 1.0,
              color: Colors.transparent,
            ),
            new Container(
              decoration: new BoxDecoration(color: Colors.white),
              child: tempatTulisPesan(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget tempatTulisPesan() {
    return new IconTheme(
      data: new IconThemeData(color: Color.fromRGBO(43, 112, 157, 1)),
      child: new Container(
        height: 50,
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35.0),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 3),
                blurRadius: 5,
                color: Color.fromRGBO(43, 112, 157, 1))
          ],
        ),
        child: new Row(
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            new Flexible(
              child: new TextField(
                controller: _textController,
                //onSubmitted: _handleSubmitted,
                onChanged: _handleChanged,
                decoration: InputDecoration(
                    hintText: 'Ketik pesan...',
                    hintStyle:
                        new TextStyle(color: Color.fromRGBO(43, 112, 157, 1)),
                    border: InputBorder.none),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? new RaisedButton(
                      child: new Text('Kirim'),
                      onPressed: _isComposing
                          ? () {
                              //_handleSubmitted(_textController.text);
                              // kirimChat();
                            }
                          : null,
                    )
                  : new IconButton(
                      icon: new Icon(Icons.send),
                      onPressed: _isComposing
                          ? () {
                              //_handleSubmitted(_textController.text);
                              _textController.text.isEmpty
                                  ? adaPesan = false
                                  : adaPesan = true;
                              kirimChat();
                            }
                          : null,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleChanged(String text) {
    setState(() {
      _isComposing = text.length > 0;
    });
  }
}
