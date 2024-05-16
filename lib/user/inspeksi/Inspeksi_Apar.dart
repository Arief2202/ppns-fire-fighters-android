// ignore_for_file: file_names, camel_case_types, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_constructors_in_immutables, use_build_context_synchronously, sized_box_for_whitespace, sort_child_properties_last, non_constant_identifier_names, no_logic_in_create_state, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, must_be_immutable

import 'package:flutter/material.dart';
import 'package:ppns_fire_fighters/DisabledInput.dart';
import 'package:ppns_fire_fighters/RadioForm.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:ppns_fire_fighters/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:developer';

class InspeksiApar extends StatefulWidget{
  InspeksiApar({required this.nomor, required this.id, Key? key}) : super(key: key);
  String nomor;
  String id;
  @override
  _InspeksiAparState createState() => _InspeksiAparState(noApar: nomor);
}

class _InspeksiAparState extends State<InspeksiApar>{
  _InspeksiAparState({required this.noApar});
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
  TextEditingController alasan = TextEditingController(text: '');
  String noApar;
  String tersedia = "Tersedia";
  String kondisi_tabung = "-";
  String segel_pin = "-";
  String tuas_pegangan= "-";
  String label_segitiga = "-";
  String label_instruksi = "-";
  String kondisi_selang = "-";
  String tekanan_tabung = "-";
  String posisi = "-";

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment.topCenter,
                  child: Column(children: [
                    Container(
                      margin: EdgeInsets.only(top: 35),
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
                      margin: EdgeInsets.only(top: 110),
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
                      margin: EdgeInsets.only(top: 150),
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
                                  disabledInput("No Apar", "${noApar}"), 
                                  SizedBox(height: 20),
                                  disabledInput("Email Inspektor", "${globals.user_email}"),   
                                  SizedBox(height: 20),
                                  disabledInput("Tanggal Inspeksi", "${now.day} ${monthName[now.month-1]} ${now.year}"),                
                                  RadioForm(title: "Apakah APAR Tersedia ?", option: ["Tersedia", "Tidak"], onChange: (String? value) {setState(() {tersedia = value!;});log("Apakah Apar Tersedia : ${tersedia}");}),
                                  if(tersedia == "Tidak") Container(
                                      margin: EdgeInsets.only(top: 30, left:15, right: 15),
                                      // height: 60,
                                      child: TextField(
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Alasan Tidak Tersedia',
                                          labelStyle: TextStyle(fontSize: 20),
                                          // errorText: _error[1] ? 'Value Can\'t Be Empty' : null,
                                        ),
                                        onChanged: (value){

                                        },
                                        controller: alasan,
                                      ),
                                    ),
                                    if(tersedia == "Tidak") SizedBox(height: MediaQuery.of(context).size.height-400),
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
                      margin: EdgeInsets.only(left:20, right: 20, top: MediaQuery.of(context).size.height-60),
                      child: 
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white
                          ),
                          onPressed: () async{     
                            if(tersedia == "Tersedia"){                              
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                      return InspeksiApar2(nomor: widget.nomor, id: widget.id);
                                  }),
                                );
                            }
                            else{
                              var url = Uri.parse("http://${globals.endpoint}/api_inspeksi_apar.php?create&user_id=${globals.user_id}&apar_id=${widget.id}&tersedia=${tersedia}&alasan=${tersedia == "Tersedia" ? "-" : alasan.text}&kondisi_tabung=${kondisi_tabung}&segel_pin=${segel_pin}&tuas_pegangan=${tuas_pegangan}&label_segitiga=${label_segitiga}&label_instruksi=${label_instruksi}&kondisi_selang=${kondisi_selang}&tekanan_tabung=${tekanan_tabung}&posisi=${posisi}");  
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
                            }
                          }, 
                          child: Text(tersedia == "Tersedia" ? "Next" : "Submit")
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

class InspeksiApar2 extends StatefulWidget {
  InspeksiApar2({required this.nomor, required this.id, Key? key}) : super(key: key);
  String nomor;
  String id;
  @override
  _InspeksiAparState2 createState() => _InspeksiAparState2(noApar: nomor);
}

class _InspeksiAparState2 extends State<InspeksiApar2> {
  _InspeksiAparState2({required this.noApar});
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
  String noApar;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment.topCenter,
                  child: Column(children: [
                    Container(
                      margin: EdgeInsets.only(top: 35),
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
                      margin: EdgeInsets.only(top: 110),
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
                      margin: EdgeInsets.only(top: 150),
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
                                  disabledInput("No Apar", "${noApar}"), 
                                  SizedBox(height: 20),
                                  disabledInput("Email Inspektor", "${globals.user_email}"),   
                                  SizedBox(height: 20),
                                  disabledInput("Tanggal Inspeksi", "${now.day} ${monthName[now.month-1]} ${now.year}"),                
                                  RadioForm(title: "Kondisi Tabung :", option: ["Baik", "Rusak"], onChange: (String? value) {setState(() {kondisi_tabung = value!;});log("Kondisi Tabung : ${kondisi_tabung}");}),
                                  RadioForm(title: "Segel Pin :", option: ["Terpasang", "Lepas", "Tidak ada pin"], onChange: (String? value) {setState(() {segel_pin = value!;});log("Segel Pin : ${segel_pin}");}),
                                  RadioForm(title: "Tuas Pegangan (Handle) :", option: ["Baik", "Rusak"], onChange: (String? value) {setState(() {tuas_pegangan = value!;});log("Tuas pegangan : ${tuas_pegangan}");}),
                                  RadioForm(title: "Label (Tanda Segitiga Merah) :", option: ["Tersedia", "Tidak Tersedia"], onChange: (String? value) {setState(() {label_segitiga = value!;});log("Label Segitiga : ${label_segitiga}");}),
                                  RadioForm(title: "Label (Instruksi Penggunaan APAR) :", option: ["Terbaca", "Tidak Terbaca", "Tidak Ada"], onChange: (String? value) {setState(() {label_instruksi = value!;});log("Label Instruksi : ${label_instruksi}");}),
                                  RadioForm(title: "Kondisi Selang :", option: ["Baik", "Rusak", "Lainnya"], onChange: (String? value) {setState(() {kondisi_selang = value!;});log("Kondisi Selang : ${kondisi_selang}");}),
                                  RadioForm(title: "Tekanan Tabung (Posisi Jarum) :", option: ["Tepat di hijau", "Kurang dari hijau", "Lebih dari hijau", "Tidak tersedia"], onChange: (String? value) {setState(() {tekanan_tabung = value!;});log("Tekanan Tabung : ${tekanan_tabung}");}),
                                  RadioForm(title: "Posisi Alat Pemadam Api :", option: ["Terlihat", "Terhalang"], onChange: (String? value) {setState(() {posisi = value!;});log("Posisi : ${posisi}");}),
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
                      margin: EdgeInsets.only(left:20, right: 20, top: MediaQuery.of(context).size.height-60),
                      child: 
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white
                          ),
                          onPressed: () async{     
                            var url = Uri.parse("http://${globals.endpoint}/api_inspeksi_apar.php?create&user_id=${globals.user_id}&apar_id=${widget.id}&tersedia=Tersedia&alasan=-&kondisi_tabung=${kondisi_tabung}&segel_pin=${segel_pin}&tuas_pegangan=${tuas_pegangan}&label_segitiga=${label_segitiga}&label_instruksi=${label_instruksi}&kondisi_selang=${kondisi_selang}&tekanan_tabung=${tekanan_tabung}&posisi=${posisi}");  
                            try {
                              final response = await http.get(url).timeout(
                                const Duration(seconds: 1),
                                onTimeout: () {
                                  return http.Response('Error', 408);
                                },
                              );
                              if (response.statusCode == 200) {

                                  Alert(
                                    onWillPopActive: true,
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