// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.value,
    this.idPasien,
    this.idDokter,
    this.tipeUser,
    this.username,
    this.name,
    this.fotoProfil,
    this.tanggalLahir,
    this.phone,
    this.alamat,
    this.email,
    this.role,
  });

  String value;
  String idPasien;
  String idDokter;
  String tipeUser;
  String username;
  String name;
  String fotoProfil;
  String tanggalLahir;
  String phone;
  String alamat;
  String email;
  String role;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        value: json["value"],
        idPasien: json["id_pasien"],
        idDokter: json["id_dokter"],
        tipeUser: json["tipe_user"],
        username: json["username"],
        name: json["name"],
        fotoProfil: json["foto_profil"],
        tanggalLahir: json["tanggal_lahir"],
        phone: json["phone"],
        alamat: json["alamat"],
        email: json["email"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "id_pasien": idPasien,
        "id_dokter": idDokter,
        "tipe_user": tipeUser,
        "username": username,
        "name": name,
        "foto_profil": fotoProfil,
        "tanggal_lahir": tanggalLahir,
        "phone": phone,
        "alamat": alamat,
        "email": email,
        "role": role,
      };
}
