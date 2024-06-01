// ignore_for_file: file_names, camel_case_types, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_constructors_in_immutables, use_build_context_synchronously, sized_box_for_whitespace, sort_child_properties_last, non_constant_identifier_names, no_logic_in_create_state, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, must_be_immutable

import 'package:flutter/material.dart';
import 'package:ppns_fire_fighters/DisabledInput.dart';
import 'package:ppns_fire_fighters/RadioForm.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:ppns_fire_fighters/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:developer';

class InspeksiHydrantIHB extends StatefulWidget {
  InspeksiHydrantIHB({required this.nomor, required this.id, Key? key}) : super(key: key);
  String nomor;
  String id;
  @override
  _InspeksiHydrantIHBState createState() => _InspeksiHydrantIHBState(nomor: nomor);
}

class _InspeksiHydrantIHBState extends State<InspeksiHydrantIHB> {
  _InspeksiHydrantIHBState({required this.nomor});
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

  String kondisi_kotak = "";
  String posisi_kotak = "";
  String kondisi_nozzle= "";
  String kondisi_selang = "";
  String jenis_selang = "";
  String kondisi_coupling = "";
  String kondisi_landing_valve = "";
  String kondisi_tray = "";

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
                      margin:
                          EdgeInsets.only(top: 35),
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
                        "Inspeksi Hydrant IHB",
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
                                  disabledInput("Nomor", "${nomor}"), 
                                  SizedBox(height: 20),
                                  disabledInput("Email Inspektor", "${globals.user_email}"),   
                                  SizedBox(height: 20),
                                  disabledInput("Tanggal Inspeksi", "${now.day} ${monthName[now.month-1]} ${now.year}"),                
                                  RadioForm(title: "Kondisi Kotak :", option: ["Bersih", "Kotor", "Lainnya"], onChange: (String? value) {setState(() {kondisi_kotak = value!;});log("Kondisi Kotak : ${kondisi_kotak}");}),
                                  RadioForm(title: "Posisi Kotak :", option: ["Tidak Terhalang", "Terhalang"], onChange: (String? value) {setState(() {posisi_kotak = value!;});log("Posisi Kotak : ${posisi_kotak}");}),
                                  RadioForm(title: "Kondisi Nozzle :", option: ["Baik", "Rusak", "Lainnya"], onChange: (String? value) {setState(() {kondisi_nozzle = value!;});log("Kondisi Nozzle : ${kondisi_nozzle}");}),
                                  RadioForm(title: "Kondisi Selang :", option: ["Baik", "Bocor", "Lainnya"], onChange: (String? value) {setState(() {kondisi_selang = value!;});log("Kondisi Selang : ${kondisi_selang}");}),
                                  RadioForm(title: "Jenis Selang :", option: ["Kanvas hose", "Rubber hose"], onChange: (String? value) {setState(() {jenis_selang = value!;});log("Jenis Selang : ${jenis_selang}");}),
                                  RadioForm(title: "Kondisi Coupling :", option: ["Baik", "Rusak", "Lainnya"], onChange: (String? value) {setState(() {kondisi_coupling = value!;});log("Kondisi Coupling : ${kondisi_coupling}");}),
                                  RadioForm(title: "Kondisi Landing Valve :", option: ["Baik", "Rusak", "Lainnya"], onChange: (String? value) {setState(() {kondisi_landing_valve = value!;});log("Kondisi Landing Valve : ${kondisi_landing_valve}");}),
                                  RadioForm(title: "Kondisi Tray :", option: ["Baik", "Rusak", "Lainnya"], onChange: (String? value) {setState(() {kondisi_tray = value!;});log("Kondisi Tray : ${kondisi_tray}");}),
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
                            var url = Uri.parse("http://${globals.endpoint}/api_inspeksi_ihb.php?create&user_id=${globals.user_id}&hydrant_id=${widget.id}&kondisi_kotak=${kondisi_kotak}&posisi_kotak=${posisi_kotak}&kondisi_nozzle=${kondisi_nozzle}&kondisi_selang=${kondisi_selang}&jenis_selang=${jenis_selang}&kondisi_coupling=${kondisi_coupling}&kondisi_landing_valve=${kondisi_landing_valve}&kondisi_tray=${kondisi_tray}");  
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