// To parse this JSON data, do
//
//     final jantungModel = jantungModelFromJson(jsonString);

import 'dart:convert';

JantungModel jantungModelFromJson(String str) =>
    JantungModel.fromJson(json.decode(str));

String jantungModelToJson(JantungModel data) => json.encode(data.toJson());

class JantungModel {
  JantungModel({
    this.value,
    this.message,
    this.content,
  });

  String value;
  String message;
  List<Content> content;

  factory JantungModel.fromJson(Map<String, dynamic> json) => JantungModel(
        value: json["value"],
        message: json["message"],
        content:
            List<Content>.from(json["content"].map((x) => Content.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "message": message,
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
      };
}

class Content {
  Content({
    this.idR,
    this.idPasien,
    this.tanggalRekam,
    this.jamRekam,
    this.totalR,
  });

  String idR;
  String idPasien;
  DateTime tanggalRekam;
  String jamRekam;
  String totalR;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        idR: json["id_r"],
        idPasien: json["id_pasien"],
        tanggalRekam: DateTime.parse(json["tanggal_rekam"]),
        jamRekam: json["jam_rekam"],
        totalR: json["total_r"],
      );

  Map<String, dynamic> toJson() => {
        "id_r": idR,
        "id_pasien": idPasien,
        "tanggal_rekam":
            "${tanggalRekam.year.toString().padLeft(4, '0')}-${tanggalRekam.month.toString().padLeft(2, '0')}-${tanggalRekam.day.toString().padLeft(2, '0')}",
        "jam_rekam": jamRekam,
        "total_r": totalR,
      };
}
