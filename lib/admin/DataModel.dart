
// ignore_for_file: camel_case_types, unnecessary_null_comparison, file_names, non_constant_identifier_names
import 'dart:convert';

class DataAPI {
  DataAPI({
    required this.status,
    required this.pesan,
    required this.data,
  });
  
  String status;
  String pesan;
  List<List<String>> data;
  
  factory DataAPI.fromJson(Map<String, dynamic> json) => DataAPI(
    status: json["status"],
    pesan: json["pesan"],
    data: objectToArray(json["data"]),
  );
}

class DataUserAPI {
  DataUserAPI({
    required this.status,
    required this.pesan,
    required this.data,
  });
  String status;
  String pesan;
  List<List<String>> data;
  
  factory DataUserAPI.fromJson(Map<String, dynamic> json) => DataUserAPI(
    status: json["status"],
    pesan: json["pesan"],
    data: objectToArrayUser(json["data"]),
  );
}
class DataInspeksiAPI {
  DataInspeksiAPI({
    required this.status,
    required this.pesan,
    required this.data,
  });
  String status;
  String pesan;
  List<List<String>> data;
  
  factory DataInspeksiAPI.fromJson(Map<String, dynamic> json) => DataInspeksiAPI(
    status: json["status"],
    pesan: json["pesan"],
    data: objectToArrayInspeksi(json["data"]),
  );
}

List<List<String>> objectToArray(List<dynamic> data) {
  final List<List<String>> output = [];
  for(int a=0; a< data.length; a++){
    final List<String> row = [];
    row.add(data[a]['id']);
    row.add(data[a]['nomor']);
    row.add(data[a]['lokasi']);
    row.add(data[a]['tanggal_kadaluarsa']);
    row.add(data[a]['timestamp']);
    output.add(row);
  }
  return output;
}

List<List<String>> objectToArrayInspeksi(List<dynamic> data) {
  final List<List<String>> output = [];
  for(int a=0; a< data.length; a++){
    final List<String> row = [];
    row.add(data[a]['id']);
    row.add(data[a]['user']['email']);
    row.add(data[a]['apar']['nomor']);
    row.add(data[a]['apar']['lokasi']);
    row.add(data[a]['apar']['tanggal_kadaluarsa']);
    row.add(data[a]['kondisi_tabung']);
    row.add(data[a]['segel_pin']);
    row.add(data[a]['tuas_pegangan']);
    row.add(data[a]['label_segitiga']);
    row.add(data[a]['label_instruksi']);
    row.add(data[a]['kondisi_selang']);
    row.add(data[a]['tekanan_tabung']);
    row.add(data[a]['posisi']);
    row.add(data[a]['created_at']);
    output.add(row);
  }
  return output;
}
List<List<String>> objectToArrayUser(List<dynamic> data) {
  final List<List<String>> output = [];
  for(int a=0; a< data.length; a++){
    final List<String> row = [];
    row.add(data[a]['id']);
    row.add(data[a]['role']);
    row.add(data[a]['name']);
    row.add(data[a]['email']);
    row.add(data[a]['password']);
    row.add(data[a]['created_at']);
    output.add(row);
  }
  return output;
}

class Json {
  static String? tryEncode(data) {
    try {
      return jsonEncode(data);
    } catch (e) {
      return null;
    }
  }

  static dynamic tryDecode(data) {
    try {
      return jsonDecode(data);
    } catch (e) {
      return null;
    }
  }

}