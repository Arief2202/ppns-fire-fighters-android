// ignore_for_file: file_names, camel_case_types, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_constructors_in_immutables, use_build_context_synchronously, sized_box_for_whitespace, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:ppns_fire_fighters/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'dart:developer';
import 'package:table_sticky_headers/table_sticky_headers.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:ppns_fire_fighters/globals.dart' as globals;


class InspeksiApar extends StatefulWidget {
  InspeksiApar({Key? key}) : super(key: key);

  @override
  _InspeksiAparState createState() => _InspeksiAparState();
}

class _InspeksiAparState extends State<InspeksiApar> {
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
          decoration: new BoxDecoration(color: Colors.white),
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment.topRight,
                  child: Column(children: [
                    SizedBox(height: 50),
                    IconButton(
                        iconSize: 40,
                        icon: const Icon(Icons.logout),
                        onPressed: () async {
                          Alert(
                            context: context,
                            type: AlertType.info,
                            title: "Do you want to Logout ?",
                            buttons: [
                              DialogButton(
                                  child: Text(
                                    "No",
                                    style:
                                        TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              DialogButton(
                                  child: Text(
                                    "Yes",
                                    style:
                                        TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () async {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.remove('user_id');
                                    await prefs.remove('user_role');
                                    await prefs.remove('user_name');
                                    await prefs.remove('user_email');
                                    await prefs.remove('user_password');
                                    setState(() {
                                      globals.user_id = "";
                                      globals.user_role = "";
                                      globals.user_name = "";
                                      globals.user_email = "";
                                      globals.user_password = "";
                                      globals.isLoggedIn = false;
                                    });
                                    // Navigator.pop(context);
                                    Phoenix.rebirth(context);
                                  }),
                            ],
                          ).show();
                        }),
                  ])),
              Align(
                  alignment: Alignment.topLeft,
                  child: Column(children: [
                    Container(
                      margin: new EdgeInsets.only(left: 30.0, right: 20.0, top: 40),
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
                  alignment: Alignment.topLeft,
                  child: Column(children: [
                    Container(
                      margin: new EdgeInsets.only(left: 20.0, right: 10.0, top: 135),
                      child: 
                          Text(
                            "Inspeksi APAR",
                            style: TextStyle(
                              fontFamily: "SanFrancisco",
                              decoration: TextDecoration.none,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                              color: Color.fromARGB(255, 255, 50, 50)
                            ),
                          ),
                    ),
                  ]
                )
              ),
              Align(
                  alignment: Alignment.topRight,
                  child: Column(children: [                    
                     Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height-180,
                        margin: new EdgeInsets.only(top: 180),
                        // decoration: new BoxDecoration(color: const Color.fromARGB(49, 244, 67, 54)),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    for(int a =1; a<=10; a++) Container(
                                      margin: EdgeInsets.only(top:20),
                                      child: TextField(
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Data $a',
                                          labelStyle: TextStyle(fontSize: 20),
                                          // errorText: _error[1] ? 'Value Can\'t Be Empty' : null,
                                        ),
                                      ),                                      // controller: _data[1],
                                    ),
                                    
                                      Container(
                                        margin: EdgeInsets.only(top: 20, bottom: 50),                                        
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          child: Text("Submit"),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                    )
                  ]
                  )
              )
              
            ],
          ),
        ),
      ),
    );
  }
}