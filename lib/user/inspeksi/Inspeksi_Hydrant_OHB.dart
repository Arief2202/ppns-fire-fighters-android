// ignore_for_file: file_names, camel_case_types, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_constructors_in_immutables, use_build_context_synchronously, sized_box_for_whitespace, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:ppns_fire_fighters/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:convert';

class InspeksiHydrantOHB extends StatefulWidget {
  InspeksiHydrantOHB({required this.nomor, required this.id, Key? key}) : super(key: key);
  String nomor;
  String id;
  @override
  _InspeksiHydrantOHBState createState() => _InspeksiHydrantOHBState(nomor: nomor);
}

class _InspeksiHydrantOHBState extends State<InspeksiHydrantOHB> {
  _InspeksiHydrantOHBState({required this.nomor});
  DateTime now = DateTime.now();
  static List<String> monthName = [
    "Januari",
    "Februari",
    "Maret",
    "April",
    "Mei",
    "Juni",
    "Juli",
    "Agustus",
    "September",
    "Oktober",
    "November",
    "Desember",
  ];
  String nomor;

  String kondisi_tabung = "";
  String segel_pin = "";
  String tuas_pegangan= "";
  String label_segitiga = "";
  String label_instruksi = "";
  String kondisi_selang = "";
  String tekanan_tabung = "";
  String posisi = "";

  @override
  void initState() {
    super.initState();

  }

  void updateState(String _var){
    setState(() {
      kondisi_tabung = _var;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          decoration: new BoxDecoration(color: Colors.white),
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment.topCenter,
                  child: Column(children: [
                    Container(
                      margin:
                          new EdgeInsets.only(top: 35),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            'assets/img/logoHorizontal.png',
                            width: MediaQuery.of(context).size.width - 120,
                          ),
                        ],
                      ),
                    ),
                  ])),
              Align(
                  alignment: Alignment.topCenter,
                  child: Column(children: [
                    Container(
                      margin: new EdgeInsets.only(top: 110),
                      child: Text(
                        "Inspeksi APAR",
                        style: TextStyle(
                            fontFamily: "SanFrancisco",
                            decoration: TextDecoration.none,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: Color.fromARGB(255, 255, 50, 50)),
                      ),
                    ),
                  ])),

              Align(
                  alignment: Alignment.topLeft,
                  child: Column(children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 215,
                      margin: new EdgeInsets.only(top: 150),
                      // decoration: new BoxDecoration(color: const Color.fromARGB(49, 244, 67, 54)),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [           
                                  SizedBox(height: 20),
                                  disabledInput("Nomor", "${nomor}"), 
                                  SizedBox(height: 20),
                                  disabledInput("Email Inspektor", "${globals.user_email}"),   
                                  SizedBox(height: 20),
                                  disabledInput("Tanggal Inspeksi", "${now.day} ${monthName[now.month-1]} ${now.year}"),                
                                  Questions(title: "Kondisi Tabung :", option: ["Baik", "Rusak"], onChange: (String? value) {setState(() {kondisi_tabung = value!;});log("Kondisi Tabung : ${kondisi_tabung}");}),
                                  Questions(title: "Segel Pin :", option: ["Terpasang", "Lepas", "Tidak ada pin"], onChange: (String? value) {setState(() {segel_pin = value!;});log("Segel Pin : ${segel_pin}");}),
                                  Questions(title: "Tuas Pegangan (Handle) :", option: ["Baik", "Rusak"], onChange: (String? value) {setState(() {tuas_pegangan = value!;});log("Tuas pegangan : ${tuas_pegangan}");}),
                                  Questions(title: "Label (Tanda Segitiga Merah) :", option: ["Tersedia", "Tidak Tersedia"], onChange: (String? value) {setState(() {label_segitiga = value!;});log("Label Segitiga : ${label_segitiga}");}),
                                  Questions(title: "Label (Instruksi Penggunaan APAR) :", option: ["Terbaca", "Tidak Terbaca", "Tidak Ada"], onChange: (String? value) {setState(() {label_instruksi = value!;});log("Label Instruksi : ${label_instruksi}");}),
                                  Questions(title: "Kondisi Selang :", option: ["Baik", "Rusak", "Lainnya"], onChange: (String? value) {setState(() {kondisi_selang = value!;});log("Kondisi Selang : ${kondisi_selang}");}),
                                  Questions(title: "Tekanan Tabung (Posisi Jarum) :", option: ["Tepat di hijau", "Kurang dari hijau", "Lebih dari hijau", "Tidak tersedia"], onChange: (String? value) {setState(() {tekanan_tabung = value!;});log("Tekanan Tabung : ${tekanan_tabung}");}),
                                  Questions(title: "Posisi Alat Pemadam Api :", option: ["Tidak terhalang / Mudah Dijangkau / Terlihat", "Terhalang"], onChange: (String? value) {setState(() {posisi = value!;});log("Posisi : ${posisi}");}),
                                  Padding(padding: EdgeInsets.all(20))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ])),

                  Align(
                  alignment: Alignment.bottomRight,
                  child: Column(children: [
                    Container(
                      margin: new EdgeInsets.only(left:20, right: 20, top: MediaQuery.of(context).size.height-60),
                      child: 
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white
                          ),
                          onPressed: () async{     
                            var url = Uri.parse("http://${globals.endpoint}/api_inspeksi_apar.php?create&user_id=${globals.user_id}&apar_id=${widget.id}&kondisi_tabung=${kondisi_tabung}&segel_pin=${segel_pin}&tuas_pegangan=${tuas_pegangan}&label_segitiga=${label_segitiga}&label_instruksi=${label_instruksi}&kondisi_selang=${kondisi_selang}&tekanan_tabung=${tekanan_tabung}&posisi=${posisi}");  
                            try {
                              final response = await http.get(url).timeout(
                                const Duration(seconds: 1),
                                onTimeout: () {
                                  return http.Response('Error', 408);
                                },
                              );
                              if (response.statusCode == 200) {
                                
                                  Alert(
                                    context: context,
                                    type: AlertType.success,
                                    title: "Inspeksi Berhasil!",
                                    buttons: [
                                      DialogButton(
                                          child: Text(
                                            "Close",
                                            style:
                                                TextStyle(color: Colors.white, fontSize: 20),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          }),
                                    ],
                                  ).show();
                              }
                              else{
                                
                                  Alert(
                                    context: context,
                                    type: AlertType.error,
                                    title: "Inspeksi Gagal!\nHubungi Admin",
                                    buttons: [
                                      DialogButton(
                                          child: Text(
                                            "Close",
                                            style:
                                                TextStyle(color: Colors.white, fontSize: 20),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }),
                                    ],
                                  ).show();
                              }
                            } on Exception catch (_) {}
                          }, 
                          child: Text("Submit")
                        ),
                    ),
                  ]
                )
              ),

            ],
          ),
        ),
      ),
    );
  }
}

Widget disabledInput(String title, String noApar){
  return Container(
      padding: EdgeInsets.only(left: 20, right: 30),
      height: 30,
      child: TextField(
          enabled: false, 
          style: TextStyle(fontSize: 14),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: title,
            labelStyle: TextStyle(fontSize: 14),
            contentPadding: EdgeInsets.only(left: 10, bottom: 10)
            // errorText: _error[1] ? 'Value Can\'t Be Empty' : null,
          ),
          controller: TextEditingController(text: "${noApar}"),
        )
    );
}

class Questions extends StatefulWidget {
  Questions({required this.title, required this.option, required this.onChange,Key? key}) : super(key: key);
  List<String> option;
  String title;
  final Function onChange;
  @override
  _QuestionsState createState() => _QuestionsState(option: option, title: title);
}

class _QuestionsState  extends State<Questions> {
  _QuestionsState({required this.title, required this.option});
  List<String> option;
  String title;
  String output = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      output = option.first;
      WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onChange(output);
    });
    });
  }

  @override
  Widget build(BuildContext context) { 
    return Container(
      child : Column(
        children: [
          SizedBox(
            width: 500,
            height: 30,
            child: ListTile(
              title: Text(title),
            ),
          ),
          for(int i=0; i<option.length; i++)
            SizedBox(
              width: 500,
              height: 30,
              child: ListTile(
                title: Text(option[i]),
                leading: Radio<String>(
                  value: option[i],
                  groupValue: output,
                  onChanged: (String? value) {
                    setState(() {
                      output = value!;
                    });
                    if(output != "Lainnya")widget.onChange(value);
                  },
                ),
              ),
            ),
            if(output == "Lainnya") Container(
              margin: EdgeInsets.only(top: 20, left:30, right: 30),
              // height: 60,
              child: TextField(
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Lainnya',
                  labelStyle: TextStyle(fontSize: 20),
                  // errorText: _error[1] ? 'Value Can\'t Be Empty' : null,
                ),
                onChanged: (value){
                  if(value != null && value != ""){
                    widget.onChange(value);
                  }
                },
              ), // controller: _data[1],
            ),
        ]
      ),
    );
  }
}