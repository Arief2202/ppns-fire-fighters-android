
// ignore_for_file: camel_case_types, unnecessary_null_comparison, file_names, non_constant_identifier_names
import 'dart:convert';

class DataAPIApar {
  DataAPIApar({
    required this.status,
    required this.pesan,
    required this.data,
  });
  
  String status;
  String pesan;
  List<List<String>> data;
  
  factory DataAPIApar.fromJson(Map<String, dynamic> json) => DataAPIApar(
    status: json["status"],
    pesan: json["pesan"],
    data: objectToArrayApar(json["data"]),
  );
}

class DataAPIHydrant {
  DataAPIHydrant({
    required this.status,
    required this.pesan,
    required this.data,
  });
  
  String status;
  String pesan;
  List<List<String>> data;
  
  factory DataAPIHydrant.fromJson(Map<String, dynamic> json) => DataAPIHydrant(
    status: json["status"],
    pesan: json["pesan"],
    data: objectToArrayHydrant(json["data"]),
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
class DataInspeksiAparAPI {
  DataInspeksiAparAPI({
    required this.status,
    required this.pesan,
    required this.data,
  });
  String status;
  String pesan;
  List<List<String>> data;
  
  factory DataInspeksiAparAPI.fromJson(Map<String, dynamic> json) => DataInspeksiAparAPI(
    status: json["status"],
    pesan: json["pesan"],
    data: objectToArrayInspeksiApar(json["data"]),
  );
}
class DataInspeksiOHBAPI {
  DataInspeksiOHBAPI({
    required this.status,
    required this.pesan,
    required this.data,
  });
  String status;
  String pesan;
  List<List<String>> data;
  
  factory DataInspeksiOHBAPI.fromJson(Map<String, dynamic> json) => DataInspeksiOHBAPI(
    status: json["status"],
    pesan: json["pesan"],
    data: objectToArrayInspeksiOHB(json["data"]),
  );
}
class DataInspeksiIHBAPI {
  DataInspeksiIHBAPI({
    required this.status,
    required this.pesan,
    required this.data,
  });
  String status;
  String pesan;
  List<List<String>> data;
  
  factory DataInspeksiIHBAPI.fromJson(Map<String, dynamic> json) => DataInspeksiIHBAPI(
    status: json["status"],
    pesan: json["pesan"],
    data: objectToArrayInspeksiIHB(json["data"]),
  );
}

List<List<String>> objectToArrayApar(List<dynamic> data) {
  final List<List<String>> output = [];
  for(int a=0; a< data.length; a++){
    final List<String> row = [];
    row.add(data[a]['id']);
    row.add(data[a]['jenis_pemadam']);
    row.add(data[a]['nomor']);
    row.add(data[a]['lokasi']);
    row.add(data[a]['tanggal_kadaluarsa']);
    row.add(data[a]['timestamp']);
    output.add(row);
  }
  return output;
}
List<List<String>> objectToArrayHydrant(List<dynamic> data) {
  final List<List<String>> output = [];
  for(int a=0; a< data.length; a++){
    final List<String> row = [];
    row.add(data[a]['id']);
    row.add(data[a]['nomor']);
    row.add(data[a]['lokasi']);
    row.add(data[a]['timestamp']);
    output.add(row);
  }
  return output;
}

List<List<String>> objectToArrayInspeksiApar(List<dynamic> data) {
  final List<List<String>> output = [];
  for(int a=0; a< data.length; a++){
    final List<String> row = [];
    row.add(data[a]['id']);
    row.add(data[a]['user']['email']);
    row.add(data[a]['apar']['nomor']);
    row.add(data[a]['apar']['jenis_pemadam']);
    row.add(data[a]['apar']['lokasi']);
    row.add(data[a]['apar']['tanggal_kadaluarsa']);
    row.add(data[a]['tersedia']);
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

List<List<String>> objectToArrayInspeksiOHB(List<dynamic> data) {
  final List<List<String>> output = [];
  for(int a=0; a< data.length; a++){
    final List<String> row = [];
    row.add(data[a]['id']);
    row.add(data[a]['user']['email']);
    row.add(data[a]['hydrant']['nomor']);
    row.add(data[a]['hydrant']['lokasi']);
    row.add(data[a]['kondisi_kotak']);
    row.add(data[a]['posisi_kotak']);
    row.add(data[a]['kondisi_nozzle']);
    row.add(data[a]['kondisi_selang']);
    row.add(data[a]['jenis_selang']);
    row.add(data[a]['kondisi_coupling']);
    row.add(data[a]['tuas_pembuka']);
    row.add(data[a]['kondisi_outlet']);
    row.add(data[a]['penutup_cop']);
    row.add(data[a]['flushing_hydrant']);
    row.add(data[a]['tekanan_hydrant']);
    row.add(data[a]['created_at']);
    output.add(row);
  }
  return output;
}
List<List<String>> objectToArrayInspeksiIHB(List<dynamic> data) {
  final List<List<String>> output = [];
  for(int a=0; a< data.length; a++){
    final List<String> row = [];
    row.add(data[a]['id']);
    row.add(data[a]['user']['email']);
    row.add(data[a]['hydrant']['nomor']);
    row.add(data[a]['hydrant']['lokasi']);
    row.add(data[a]['kondisi_kotak']);
    row.add(data[a]['posisi_kotak']);
    row.add(data[a]['kondisi_nozzle']);
    row.add(data[a]['kondisi_selang']);
    row.add(data[a]['jenis_selang']);
    row.add(data[a]['kondisi_coupling']);
    row.add(data[a]['kondisi_landing_valve']);
    row.add(data[a]['kondisi_tray']);
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