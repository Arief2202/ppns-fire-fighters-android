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


class Users extends StatefulWidget {
  Users({Key? key}) : super(key: key);

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  void initState() {
    super.initState();
  }

  // List<String> tableHeader = ["email", "name", "role", "id"];
  // List<List<String>> data = [
  //   ["1", "admin@gmail.com", "Admin", "Admin", "1"],
  //   ["2", "arief.d2022@gmail.com", "Arief", "Inspektor", "2"],
  //   ["3", "jimmy@gmail.com", "Jimmy", "Inspektor", "3"],
  //   ["4", "steve@gmail.com", "Stave", "Inspektor", "4"],
  // ];
  
  List<String> tableHeader = ["id", "email", "name", "role"];
  List<List<String>> data = [
    ["1", "admin@gmail.com", "Admin", "Admin", ""],
    ["2", "arief.d2022@gmail.com", "Arief", "Inspektor", ""],
    ["3", "jimmy@gmail.com", "Jimmy", "Inspektor", ""],
    ["4", "steve@gmail.com", "Stave", "Inspektor", ""],
  ];


  @override
  Widget build(BuildContext context) {
    // List<dynamic> data = [
    //   {"id": 1, "role": "1", "name": "admin", "email": "admin", "Timestamp": "2023-04-13 03:02:24"},
    //   {"id": 2, "role": "0", "name": "arief", "email": "arief.d2202@gmail.com", "Timestamp": "2023-04-13 03:02:24"},
    //   {"id": 3, "role": "0", "name": "arief", "email": "arief.d2202@gmail.com", "Timestamp": "2023-04-13 03:02:24"},
    //   {"id": 1, "role": "1", "name": "admin", "email": "admin", "Timestamp": "2023-04-13 03:02:24"},
    //   {"id": 2, "role": "0", "name": "arief", "email": "arief.d2202@gmail.com", "Timestamp": "2023-04-13 03:02:24"},
    //   {"id": 3, "role": "0", "name": "arief", "email": "arief.d2202@gmail.com", "Timestamp": "2023-04-13 03:02:24"},
    //   {"id": 1, "role": "1", "name": "admin", "email": "admin", "Timestamp": "2023-04-13 03:02:24"},
    //   {"id": 2, "role": "0", "name": "arief", "email": "arief.d2202@gmail.com", "Timestamp": "2023-04-13 03:02:24"},
    //   {"id": 3, "role": "0", "name": "arief", "email": "arief.d2202@gmail.com", "Timestamp": "2023-04-13 03:02:24"},
    //   {"id": 1, "role": "1", "name": "admin", "email": "admin", "Timestamp": "2023-04-13 03:02:24"},
    //   {"id": 2, "role": "0", "name": "arief", "email": "arief.d2202@gmail.com", "Timestamp": "2023-04-13 03:02:24"},
    //   {"id": 3, "role": "0", "name": "arief", "email": "arief.d2202@gmail.com", "Timestamp": "2023-04-13 03:02:24"},
    //   {"id": 1, "role": "1", "name": "admin", "email": "admin", "Timestamp": "2023-04-13 03:02:24"},
    //   {"id": 2, "role": "0", "name": "arief", "email": "arief.d2202@gmail.com", "Timestamp": "2023-04-13 03:02:24"},
    //   {"id": 3, "role": "0", "name": "arief", "email": "arief.d2202@gmail.com", "Timestamp": "2023-04-13 03:02:24"},
    //   {"id": 1, "role": "1", "name": "admin", "email": "admin", "Timestamp": "2023-04-13 03:02:24"},
    //   {"id": 2, "role": "0", "name": "arief", "email": "arief.d2202@gmail.com", "Timestamp": "2023-04-13 03:02:24"},
    //   {"id": 3, "role": "0", "name": "arief", "email": "arief.d2202@gmail.com", "Timestamp": "2023-04-13 03:02:24"},
    //   {"id": 1, "role": "1", "name": "admin", "email": "admin", "Timestamp": "2023-04-13 03:02:24"},
    //   {"id": 2, "role": "0", "name": "arief", "email": "arief.d2202@gmail.com", "Timestamp": "2023-04-13 03:02:24"},
    //   {"id": 3, "role": "0", "name": "arief", "email": "arief.d2202@gmail.com", "Timestamp": "2023-04-13 03:02:24"},
    //   {"id": 1, "role": "1", "name": "admin", "email": "admin", "Timestamp": "2023-04-13 03:02:24"},
    //   {"id": 2, "role": "0", "name": "arief", "email": "arief.d2202@gmail.com", "Timestamp": "2023-04-13 03:02:24"},
    //   {"id": 3, "role": "0", "name": "arief", "email": "arief.d2202@gmail.com", "Timestamp": "2023-04-13 03:02:24"},
    //   {"id": 1, "role": "1", "name": "admin", "email": "admin", "Timestamp": "2023-04-13 03:02:24"},
    //   {"id": 2, "role": "0", "name": "arief", "email": "arief.d2202@gmail.com", "Timestamp": "2023-04-13 03:02:24"},
    //   {"id": 3, "role": "0", "name": "arief", "email": "arief.d2202@gmail.com", "Timestamp": "2023-04-13 03:02:24"},
    // ];

    return Container(
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
                  margin: new EdgeInsets.only(left: 30.0, right: 10.0, top: 130),
                  child: 
                      Text(
                        "USERS",
                        style: TextStyle(
                          fontFamily: "SanFrancisco",
                          decoration: TextDecoration.none,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w900,
                          fontSize: 30,
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
                  margin: new EdgeInsets.only(left: 30.0, right: 10.0, top: 123),
                  child: ElevatedButton(
                    child: Text(
                      "Tambahkan Data",
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    onPressed: (){
                          Alert(
                            context: context,
                            title: "Tambahkan User",
                            content: Column(
                              children: <Widget>[
                                TextField(
                                  decoration: InputDecoration(
                                    // icon: Icon(Icons.account_circle),
                                    labelText: 'Data1',
                                  ),
                                ),
                                TextField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    // icon: Icon(Icons.lock),
                                    labelText: 'Data2',
                                  ),
                                ),
                                TextField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    // icon: Icon(Icons.lock),
                                    labelText: 'Data3',
                                  ),
                                ),
                                TextField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    // icon: Icon(Icons.lock),
                                    labelText: 'Data4',
                                  ),
                                ),
                                TextField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    // icon: Icon(Icons.lock),
                                    labelText: 'Data5',
                                  ),
                                ),
                              ],
                            ),
                            buttons: [
                              DialogButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "Create",
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                              )
                            ]).show();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  )
                ),
            ])),
            
            
          Align(
              alignment: Alignment.topRight,
              child: Column(children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height-180,
                  margin: new EdgeInsets.only(top: 180),
                  decoration: new BoxDecoration(color: const Color.fromARGB(49, 244, 67, 54)),
                  child: SimpleTablePage(data: data, titleRow: tableHeader),
                )
              ]
              )
          )
          
        ],
      ),
    );
  }
}


class SimpleTablePage extends StatelessWidget {
  SimpleTablePage({
    required this.data,
    required this.titleRow,
  });

  final List<List<String>> data;
  final List<String> titleRow;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: StickyHeadersTable(
        columnsLength: titleRow.length,
        rowsLength: data.length,
        columnsTitleBuilder: (i) => Text(titleRow[i]),
        rowsTitleBuilder: (i) => Container(
          padding: EdgeInsets.only(left: 10),
          child: ElevatedButton(
            onPressed: (){
              print(data[i][0]);
              Alert(
                context: context,
                title: "Edit User",
                content: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        // icon: Icon(Icons.account_circle),
                        labelText: 'Data1',
                      ),
                    ),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        // icon: Icon(Icons.lock),
                        labelText: 'Data2',
                      ),
                    ),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        // icon: Icon(Icons.lock),
                        labelText: 'Data3',
                      ),
                    ),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        // icon: Icon(Icons.lock),
                        labelText: 'Data4',
                      ),
                    ),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        // icon: Icon(Icons.lock),
                        labelText: 'Data5',
                      ),
                    ),
                  ],
                ),
                buttons: [
                  DialogButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Update",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )
                ]).show();
            }, 
            child: Text("Edit")
          ),
        ),
        contentCellBuilder: (i, j) => Text(data[j][i]),
        legendCell: Text('Action'),
        cellDimensions: CellDimensions.fixed(
          contentCellWidth: 100, 
          contentCellHeight: 60, 
          stickyLegendWidth: 85, 
          stickyLegendHeight: 60
        ),
        // cellDimensions: CellDimensions.uniform(
        //   width: (screenWidth/2),
        //   height: 60,
        // ),
      ),
    );
  }
}