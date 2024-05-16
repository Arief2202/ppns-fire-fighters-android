// ignore_for_file: file_names, camel_case_types, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_constructors_in_immutables, use_build_context_synchronously, curly_braces_in_flow_control_structures, unused_import

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ppns_fire_fighters/loginPage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:ppns_fire_fighters/globals.dart' as globals;
import 'package:http/http.dart' as http;

class LandingPage extends StatefulWidget {
  LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  List<TextEditingController> _data = [TextEditingController()];
  bool status = false;
  // Timer ?timer;
  @override
  void initState() {
    super.initState();
    getEndpoint();
    for(int a=0; a<10; a++) cancelTimer();
    // timer = Timer.periodic(Duration(milliseconds: 1000), (Timer t) => cancelTimer());
  }

  void cancelTimer(){
      if(globals.timerNotif != null) globals.timerNotif!.cancel();    
      if(globals.timerData != null) globals.timerData!.cancel();
  }

  void getEndpoint() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? endpoint = prefs.getString('endpoint');
    if(endpoint != null){
      setState(() {
        _data[0].text = endpoint;
        globals.endpoint = endpoint;
      });
    }
    else{
      _data[0].text = "0.0.0.0";
      globals.endpoint = "0.0.0.0";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.topRight,
          child: Column(
            children: [              
              SizedBox(height: MediaQuery.of(context).size.width / 15),
              IconButton(
                iconSize: 40,
                icon: const Icon(Icons.settings),
                onPressed: () {                                
                  Alert(
                    context: context,
                    // type: AlertType.info,
                    desc: "Setting API",
                    content: Column(
                      children: <Widget>[
                        SizedBox(height: MediaQuery.of(context).size.width / 15),
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'IP Endpoint',
                            labelStyle: TextStyle(fontSize: 20),
                          ),
                          controller: _data[0],
                        ),
                      ],
                    ),
                    buttons: [
                      DialogButton(
                          child: Text(
                            "Save",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () async {
                            if(_data[0].text.isEmpty){          
                              status = false;
                              Alert(
                                context: context,
                                type: AlertType.error,
                                title: "Value Cannot be Empty!",
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "OK",
                                      style: TextStyle(color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  )
                                ],
                              ).show();
                            }
                            else{
                              var url = Uri.parse('http://' + _data[0].text + '/checkConnection.php');
                              try{
                                  final response = await http.get(url).timeout(
                                  const Duration(seconds: globals.httpTimeout),
                                  onTimeout: () {
                                    // Time has run out, do what you wanted to do.
                                    return http.Response('Error', 408); // Request Timeout response status code
                                  },
                                );
                              // context.loaderOverlay.hide();
                                if (response.statusCode == 200) {
                                  Alert(
                                    context: context,
                                    type: AlertType.success,
                                    title: "Connection OK",
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "OK",
                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                        ),
                                        onPressed: () async {
                                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                                          setState(() {
                                            globals.endpoint = _data[0].text;
                                            prefs.setString("endpoint", _data[0].text);
                                          });
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        }
                                      )
                                    ],
                                  ).show();
                                }
                                else{
                                  Alert(
                                    context: context,
                                    type: AlertType.error,
                                    title: "Connection Failed!",
                                    desc: "Please check Endpoint IP",
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "OK",
                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                      )
                                    ],
                                  ).show();
                                }
                              } on Exception catch (_) {
                                Alert(
                                  context: context,
                                  type: AlertType.error,
                                  title: "Connection Failed!",
                                  desc: "Please check Endpoint IP",
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "OK",
                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                    )
                                  ],
                                ).show();
                                // rethrow;
                              }
                            }
                          }
                      ),
                    ],
                  ).show();
                },
              ),
            ]
          )
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/img/logoVertical.png',
                width: MediaQuery.of(context).size.width / 1.5,
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 20),
                width: double.infinity,
                height: MediaQuery.of(context).size.width / 10,
                child: ElevatedButton(
                  onPressed: () async {
                        var url = Uri.parse('http://' + globals.endpoint + '/checkConnection.php');
                        try{
                            final response = await http.get(url).timeout(
                            const Duration(seconds: globals.httpTimeout),
                            onTimeout: () {
                              // Time has run out, do what you wanted to do.
                              return http.Response('Error', 408); // Request Timeout response status code
                            },
                          );
                        // context.loaderOverlay.hide();
                          if (response.statusCode == 200) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return LoginPage();
                              }),
                            );
                          }
                          else{
                            Alert(
                              context: context,
                              type: AlertType.error,
                              title: "Connection Failed!",
                              desc: "Please check Endpoint IP",
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    "OK",
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                )
                              ],
                            ).show();
                          }
                        } on Exception catch (_) {
                          Alert(
                            context: context,
                            type: AlertType.error,
                            title: "Connection Failed!",
                            desc: "Please check Endpoint IP",
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "OK",
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => Navigator.pop(context),
                              )
                            ],
                          ).show();
                          // rethrow;
                        }
                  },
                  child: Text(
                    "Log in",
                    style: TextStyle(fontSize: MediaQuery.of(context).size.width / 20),
                  ),
                ),
              ),
              // SizedBox(height: MediaQuery.of(context).size.width / 15),
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 20),
              //   width: double.infinity,
              //   height: MediaQuery.of(context).size.width / 10,
              //   child: OutlinedButton(
              //     onPressed: () {
              //       // Navigator.push(
              //       //   context,
              //       //   MaterialPageRoute(builder: (context) {
              //       //     return RegisterPage();
              //       //   }),
              //       // );
              //     },
              //     child: Text(
              //       "Sign Up",
              //       style: TextStyle(fontSize: MediaQuery.of(context).size.width / 20),
              //     ),
              //   ),
              // ),
              SizedBox(height: MediaQuery.of(context).size.width / 15),
            ],
          ),
        ),
      ],
    );
  }
}