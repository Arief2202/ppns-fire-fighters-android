// ignore_for_file: file_names, camel_case_types, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_constructors_in_immutables, use_build_context_synchronously, sized_box_for_whitespace, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:ppns_fire_fighters/admin/Hasil_Inspeksi.dart';
import 'package:ppns_fire_fighters/admin/Users.dart';
import 'package:ppns_fire_fighters/admin/DataAparHydrant.dart';
import 'package:ppns_fire_fighters/manajemen/PieChartPage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'dart:async';
import 'package:ppns_fire_fighters/globals.dart' as globals;
import 'package:ppns_fire_fighters/notification.dart';
import 'package:ppns_fire_fighters/admin/DataModel.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class DashboardAdmin extends StatefulWidget {
  DashboardAdmin({Key? key}) : super(key: key);

  @override
  _DashboardAdminState createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  @override
  void initState() {
    super.initState();
    notif.initialize(flutterLocalNotificationsPlugin);
    globals.timerNotif = Timer.periodic(
        Duration(milliseconds: 1000), (Timer t) => updateNotification());
  }

  void updateNotification() async {
    try {
      final response = await http.get(Uri.parse("http://${globals.endpoint}/api_notification.php?read&user_id=${globals.user_id}")).timeout(
        const Duration(seconds: 1),
        onTimeout: () {
          return http.Response('Error', 408);
        },
      );
      if (response.statusCode == 200) {
        var respon = Json.tryDecode(response.body)['data'];
        for (int a = 0; a < respon.length; a++) {
          notif.showNotif(
              id: int.parse(respon[a]['id']),
              head: respon[a]['title'],
              body: respon[a]['content'],
              fln: flutterLocalNotificationsPlugin);
              
          try {
            await http.get(Uri.parse("http://${globals.endpoint}/api_notification.php?displayed&notif_id=${respon[a]['id']}")).timeout(
              const Duration(seconds: 1),
              onTimeout: () {
                return http.Response('Error', 408);
              },
            );
          } on Exception catch (_){}
        }
      }
    } on Exception catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                              if(globals.timerNotif != null) globals.timerNotif!.cancel();
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
                margin: EdgeInsets.only(left: 30.0, right: 20.0, top: 40),
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
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 50),
                  width: MediaQuery.of(context).size.width-50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "ADMIN DASHBOARD",
                        style: TextStyle(
                            fontFamily: "SanFrancisco",
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w900,
                            fontSize: 30,
                            color: Color.fromARGB(255, 255, 50, 50)),
                      ),
                    ],
                  )),
              Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return DataAparHydrant();
                      }),
                    );
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width - 50,
                      padding: EdgeInsets.all(5),
                      height: 100,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2),
                            child: Image.asset(
                              'assets/img/inputData.png',
                              width: 100,
                              height: 100,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "DATA APAR & HYDRANT",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "Description",
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                        ],
                      )),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                margin: EdgeInsets.all(10),
              ),
              Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return HasilInspeksi();
                      }),
                    );
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width - 50,
                      padding: EdgeInsets.all(5),
                      height: 100,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2),
                            child: Image.asset(
                              'assets/img/hasilInspeksi.png',
                              width: 100,
                              height: 100,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "HASIL INSPEKSI",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "Description",
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                        ],
                      )),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                margin: EdgeInsets.all(10),
              ),
              
              Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return PieChartPage();
                      }),
                    );
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width - 50,
                      padding: EdgeInsets.all(5),
                      height: 100,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2),
                            child: Image.asset(
                              'assets/img/hasilInspeksi.png',
                              width: 100,
                              height: 100,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pie Chart",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "Description",
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                        ],
                      )),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                margin: EdgeInsets.all(10),
              ),
              Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return Users();
                      }),
                    );
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width - 50,
                      padding: EdgeInsets.all(5),
                      height: 100,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2),
                            child: Image.asset(
                              'assets/img/users.png',
                              width: 100,
                              height: 100,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "USERS",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "Description",
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                        ],
                      )),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                margin: EdgeInsets.all(10),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
