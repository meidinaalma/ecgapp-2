import 'dart:convert';

import 'package:haloecg/models/jantung_model.dart';
import 'package:haloecg/models/user_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  String link = "http://haloecg.site/haloecgk/";
  // String link = "http://www.komputer-its.com/haloecg/";

  Future<UserModel> login(String email, String pass) async {
    try {
      var url = link + "login.php";
      var response =
          await http.post(url, body: {"email": email, "password": pass});
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } catch (e) {
      throw (e);
    }
  }

  Future<UserModel> getDetailUser(String email, String pass) async {
    try {
      var url = link + "pralogin.php";
      var response =
          await http.post(url, body: {"email": email, "password": pass});
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } catch (e) {
      throw (e);
    }
  }

  Future<String> signUp(
      String username, String email, String password, String role) async {
    try {
      var url = link + "signUp.php";
      var response = await http.post(url, body: {
        "username": username,
        "email": email,
        "password": password,
        "role": role,
      });
      dynamic data = jsonDecode(response.body);
      print(data);
      return data['value'];
    } catch (e) {
      throw (e);
    }
  }

  Future<UserModel> signUpDatapasien(
    String email,
    String password,
    String username,
    String fileImage,
    String fileName,
    String nama,
    String gender,
    String phone,
    String date,
    String alamat,
    String identitas,
  ) async {
    try {
      var url = link + "signUpPasien.php";
      var response = await http.post(url, body: {
        "nama_lengkap": nama,
        "username": username,
        "email": email,
        "password": password,
        "tipe_user": "0",
        "image": fileImage,
        "file_name": fileName,
        "jenis_kelamin": gender,
        "no_telepon": phone,
        "tanggal_lahir": date,
        "alamat": alamat,
        "no_identitas": identitas,
      });
      final data = jsonDecode(response.body);
      print(data);
      return UserModel.fromJson(data);
    } catch (e) {
      throw (e);
    }
  }

  Future<UserModel> signUpDataDokter(
    String nama,
    String username,
    String email,
    String password,
    String gender,
    String date,
    String phone,
    String identitas,
    String alamat,
    String fileImage,
    String fileName,
    String imageSertif,
    String sertifName,
    String imageSurat,
    String suratName,
  ) async {
    try {
      var url = link + "signUpDokter.php";
      var response = await http.post(url, body: {
        "image": fileImage,
        "file_name": fileName,
        "nama_lengkap": nama,
        "username": username,
        "email": email,
        "password": password,
        "tipe_user": "1",
        "jenis_kelamin": gender,
        "no_telepon": phone,
        "tanggal_lahir": date,
        "alamat": alamat,
        "no_identitas": identitas,
        "image_sertif": imageSertif,
        "images_sertif_name": sertifName,
        "image_surat": imageSurat,
        "images_surat_name": suratName,
      });
      final data = jsonDecode(response.body);
      print(data);
      return UserModel.fromJson(data);
    } catch (e) {
      throw (e);
    }
  }

  Future<List<UserModel>> ambilDataDokter() async {
    try {
      var url = link + "ambildataDokter.php";
      var response = await http.post(url, body: {});
      final data = jsonDecode(response.body) as List;
      List<UserModel> listUser =
          data.map((data) => UserModel.fromJson(data)).toList();
      return listUser;
    } catch (e) {
      throw (e);
    }
  }

  Future<dynamic> ambilDataObat(
    String idDokter,
    String idPasien,
  ) async {
    try {
      var url = link + "ambil_obat.php";
      var response = await http.post(url, body: {
        "id_dokter": idDokter,
        "id_pasien": idPasien,
      });
      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      throw (e);
    }
  }

  Future<JantungModel> ambilDataJantung(String idPasien, String jam) async {
    try {
      var url = link + "get_data_jantung.php";
      var response = await http.post(url, body: {
        "id_pasien": idPasien,
        "jam" : jam,
      });
      final Map<String, dynamic> parsed = jsonDecode(response.body);
      JantungModel data = JantungModel.fromJson(parsed);
      return data;
    } catch (e) {
      throw (e);
    }
  }
}
