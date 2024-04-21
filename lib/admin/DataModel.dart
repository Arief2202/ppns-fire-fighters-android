
// ignore_for_file: camel_case_types, unnecessary_null_comparison, file_names, non_constant_identifier_names
import 'dart:convert';

class DataAparAPI {
  DataAparAPI({
    required this.status,
    required this.pesan,
    required this.data,
  });
  String status;
  String pesan;
  List<List<String>> data;
  
  factory DataAparAPI.fromJson(Map<String, dynamic> json) => DataAparAPI(
    status: json["status"],
    pesan: json["pesan"],
    data: objectToArray(json["data"]),
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

// List<List<String>> makeData() {
//   final List<List<String>> output = [];
//   for (int i = 0; i < columns; i++) {
//     final List<String> row = [];
//     for (int j = 0; j < rows; j++) {
//       row.add('Col$j Row$i');
//     }
//     output.add(row);
//   }
//   return output;
// }

class DataAparModel{
  DataAparModel({
    required this.id,
    required this.nomor,
    required this.lokasi,
    required this.tanggal_kadaluarsa,
    required this.timestamp
  });
  String id;
  String nomor;
  String lokasi;
  String tanggal_kadaluarsa;
  String timestamp;

  factory DataAparModel.fromJson(Map<String, dynamic> json) => DataAparModel(
    id: json["id"],
    nomor: json["nomor"],
    lokasi: json["lokasi"],
    tanggal_kadaluarsa: json["tanggal_kadaluarsa"],
    timestamp: json["timestamp"]
  );
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