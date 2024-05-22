// ignore_for_file: file_names, camel_case_types, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_constructors_in_immutables, use_build_context_synchronously, sized_box_for_whitespace, sort_child_properties_last, must_be_immutable, override_on_non_overriding_member, unnecessary_this, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:ppns_fire_fighters/user/inspeksi/Inspeksi_Apar.dart';
import 'package:ppns_fire_fighters/user/inspeksi/Inspeksi_Hydrant_OHB.dart';
import 'package:ppns_fire_fighters/user/inspeksi/inspeksi_Hydrant_IHB.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:ppns_fire_fighters/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:ppns_fire_fighters/admin/DataModel.dart';

class InputNomor extends StatefulWidget {
  InputNomor({required this.code, Key? key}) : super(key: key);
  String code;
  @override
  _InputNomorState createState() => _InputNomorState();
}

class _InputNomorState extends State<InputNomor> {
  TextEditingController nomor = TextEditingController(text: '');
  String id = "0";

  @override
  void initState() {
    super.initState();
  }

  bool checked = false;

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
                      margin: EdgeInsets.only(top: 40),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            'assets/img/logoHorizontal.png',
                            width: MediaQuery.of(context).size.width - 70,
                          ),
                        ],
                      ),
                    ),
                  ])),
              Align(
                  alignment: Alignment.topRight,
                  child: Column(children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 180,
                      margin: EdgeInsets.only(top: 180),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width / 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 20),
                                    child: TextField(
                                      controller: nomor,
                                      obscureText: false,
                                      onChanged: (value) {
                                        setState(() {
                                          checked = false;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: widget.code == 'apar'
                                            ? 'No APAR'
                                            : 'No Hydrant',
                                        labelStyle: TextStyle(fontSize: 20),
// errorText: _error[1] ? 'Value Can\'t Be Empty' : null,
                                      ),
                                    ), // controller: _data[1],
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: 20, bottom: 50),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          foregroundColor: Colors.white),
                                      onPressed: () async {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();

                                        var url = Uri.parse(
                                            "http://${globals.endpoint}/api_apar.php?search&nomor=${nomor.text}");
                                        if (widget.code == "hydrantOHB") {
                                          url = Uri.parse(
                                              "http://${globals.endpoint}/api_hydrant.php?search&jenis=ohb&nomor=${nomor.text}");
                                        }
                                        if (widget.code == "hydrantIHB") {
                                          url = Uri.parse(
                                              "http://${globals.endpoint}/api_hydrant.php?search&jenis=ihb&nomor=${nomor.text}");
                                        }
                                        try {
                                          final response =
                                              await http.get(url).timeout(
                                            const Duration(seconds: 1),
                                            onTimeout: () {
                                              return http.Response(
                                                  'Error', 408);
                                            },
                                          );
                                          if (response.statusCode == 200) {
                                            var respon =
                                                Json.tryDecode(response.body);
                                            if (respon['inspection']) {
                                              if (this.mounted) {
                                                setState(() {
                                                  checked = true;
                                                  id = respon['data']['id'];
                                                });
                                              }
                                              Alert(
                                                context: context,
                                                type: AlertType.success,
                                                title:
                                                    "${widget.code == 'apar' ? "APAR" : "Hydrant"} belum di inspeksi",
                                                content: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 10),
                                                    Text(
                                                      """
Nomor  : ${respon['data']['nomor']}
Lokasi : ${respon['data']['lokasi']}
"""+(widget.code == 'apar' ? "Kadaluarsa : ${respon['data']['tanggal_kadaluarsa']}":""),
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    )
                                                  ],
                                                ),
                                                buttons: [
                                                  DialogButton(
                                                      child: Text(
                                                        "Close",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) {
                                                            if(widget.code == 'hydrantOHB') return InspeksiHydrantOHB(nomor: nomor.text, id: id);
                                                            else if(widget.code == 'hydrantIHB') return InspeksiHydrantIHB(nomor: nomor.text, id: id);
                                                            else return InspeksiApar(nomor: nomor.text, id: id);
                                                          }),
                                                        );
                                                      }),
                                                ],
                                              ).show();
                                            } else {
                                              if (this.mounted) {
                                                setState(() {
                                                  checked = false;
                                                });
                                              }
                                              Alert(
                                                context: context,
                                                type: AlertType.error,
                                                title:
                                                    "${widget.code == 'apar' ? "APAR" : "Hydrant"} telah di inspeksi bulan ini!",
                                                content: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 10),
                                                    Text(
                                                      """
Email Inspektor  : ${respon['data_user']['email']}
Tanggal Inspeksi : ${respon['data_inspeksi']['created_at']}
""",
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    )
                                                  ],
                                                ),
                                                buttons: [
                                                  DialogButton(
                                                      child: Text(
                                                        "Close",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      }),
                                                ],
                                              ).show();
                                            }
                                          } else {
                                            if (this.mounted) {
                                              setState(() {
                                                checked = false;
                                              });
                                            }
                                            Alert(
                                              context: context,
                                              type: AlertType.error,
                                              title:
                                                  "Nomor ${widget.code == 'apar' ? "APAR" : "Hydrant"}  tidak ditemukan di database!",
                                              buttons: [
                                                DialogButton(
                                                    child: Text(
                                                      "Close",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    }),
                                              ],
                                            ).show();
                                          }
                                        } on Exception catch (_) {}
                                      },
                                      child: Text("Check"),
                                    ),
                                  ),
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
                      margin: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: MediaQuery.of(context).size.height - 60),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white),
                          onPressed: !checked
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                        if(widget.code == 'hydrantOHB') return InspeksiHydrantOHB(nomor: nomor.text, id: id);
                                        else if(widget.code == 'hydrantIHB') return InspeksiHydrantIHB(nomor: nomor.text, id: id);
                                        else return InspeksiApar(nomor: nomor.text, id: id);
                                    }),
                                  );
                                },
                          child: Text("Next")),
                    ),
                  ])),
            ],
          ),
        ),
      ),
    );
  }
}
