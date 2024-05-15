// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, non_constant_identifier_names, prefer_interpolation_to_compose_strings, prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:ppns_fire_fighters/manajemen/PieChartPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ppns_fire_fighters/user/Dashboard.dart';
import 'package:ppns_fire_fighters/admin/Dashboard_Admin.dart';
import 'package:ppns_fire_fighters/landingPage.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:ppns_fire_fighters/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;
import 'package:month_year_picker/month_year_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(
    Phoenix(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: <LocalizationsDelegate<Object>>[
            GlobalMaterialLocalizations.delegate,
            MonthYearPickerLocalizations.delegate,
      ],
      // supportedLocales: <Locale>[
      //   Locale('id', 'ID'), // Indonesia
      //   // ... other locales the app supports
      // ],
      debugShowCheckedModeBanner: false,
      title: 'Auto Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoaderOverlay(child: MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    autoLogIn();
  }

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? endpoint = prefs.getString('endpoint');
    if(endpoint == null){
          Alert(
            context: context,
            type: AlertType.error,
            title: "Connection Failed!",
            desc: "Please check IP Endpoint",
            buttons: [
              DialogButton(
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () async {
                  await prefs.remove('user_email');
                  await prefs.remove('user_password');
                  setState(() {
                    globals.user_email = "";
                    globals.user_password = "";
                  });
                  Navigator.pop(context);
                }
              )
            ],
          ).show();
    }
    else {
      var url = Uri.parse('http://' + endpoint + '/checkConnection.php');
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
          final String? user_email = prefs.getString('user_email');
          final String? user_password = prefs.getString('user_password');
          if (user_email != null && user_password != null) {
              setState(() {
                globals.loadingAutologin = true;
              });
              context.loaderOverlay.show();
              var url = Uri.parse('http://' + globals.endpoint + '/loginEncrypted.php');
              final response = await http.post(url, body: {'email': user_email, 'password': user_password});

              if (response.statusCode == 200) {
                setState(() {
                  globals.endpoint = endpoint;
                });
                Map<String, dynamic> parsed = jsonDecode(response.body);
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('user_id', (parsed['data']['user']['id']).toString());
                await prefs.setString('user_role', parsed['data']['user']['role']);
                await prefs.setString('user_name', parsed['data']['user']['name']);
                await prefs.setString('user_email', parsed['data']['user']['email']);
                await prefs.setString('user_password', parsed['data']['user']['password']);
                setState(() {
                  globals.user_id = (parsed['data']['user']['id']).toString();
                  globals.user_role = parsed['data']['user']['role'];
                  globals.user_name = parsed['data']['user']['name'];
                  globals.user_email = parsed['data']['user']['email'];
                  globals.user_password = parsed['data']['user']['password'];
                  globals.isLoggedIn = true;
                });
                if(globals.user_role == "1"){
                    var status = await Permission.notification.status;
                    if (!status.isGranted) {
                        print("Notification access denied!");
                        Alert(
                          context: context,
                          type: AlertType.error,
                          title: "Notification Permission Denied!",
                          desc: "Please allow notification permission on system setting",
                          style: AlertStyle(
                            titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            descStyle: TextStyle(fontSize: 14),
                          ),
                          buttons: [
                            DialogButton(
                              child: Text(
                                "OK",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () async {
                                Navigator.pop(context);
                              }
                            )
                          ],
                        ).show();
                    }
                    else{
                      print("notificaiton access granted");
                    }
                }


              } else {
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
                Alert(
                  context: context,
                  type: AlertType.info,
                  title: "Login Failed!",
                  desc: "Please relogin",
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
              setState(() {
                globals.loadingAutologin = false;
              });
              context.loaderOverlay.hide();
              return;
            }

          
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
                onPressed: () async {
                  await prefs.remove('user_email');
                  await prefs.remove('user_password');
                  setState(() {
                    globals.user_email = "";
                    globals.user_password = "";
                  });
                  Navigator.pop(context);
                }
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
              onPressed: () async {
                await prefs.remove('user_email');
                await prefs.remove('user_password');
                setState(() {
                  globals.user_email = "";
                  globals.user_password = "";
                });
                Navigator.pop(context);
              }
            )
          ],
        ).show();
        // rethrow;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return globals.loadingAutologin ? Scaffold() : Scaffold(body: globals.isLoggedIn ? (globals.user_role == "0" ? Dashboard() : globals.user_role == "1" ? DashboardAdmin() : PieChartPage()) : LandingPage());
  }
}