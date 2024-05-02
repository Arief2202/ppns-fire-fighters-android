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
import 'package:ppns_fire_fighters/admin/DataModel.dart';
import 'package:intl/intl.dart';
import 'dart:async';


class Users extends StatefulWidget {
  Users({super.key, this.restorationId});

  final String? restorationId;

  final columns = 5;
  final rows = 20;
  List<List<String>> makeData() {
    final List<List<String>> output = [];
    for (int i = 0; i < columns; i++) {
      final List<String> row = [];
      for (int j = 0; j < rows; j++) {
        row.add('Col$j Row$i');
      }
      output.add(row);
    }
    return output;
  }

  /// Simple generator for column title
  // List<String> makeTitleColumn() => List.generate(columns, (i) => 'Row $i');


  /// Simple generator for row title
  List<String> makeTitleRow() => List.generate(rows, (i) => 'Col $i');
  @override
  _UsersState createState() => _UsersState();
}


class _UsersState extends State<Users> {
  List<TextEditingController> _controller = [
    TextEditingController(text: ''),
    TextEditingController(text: ''),
    TextEditingController(text: ''),
    TextEditingController(text: '')
  ];

  Timer? timer;
  List<String> titleColumn = [
    "id", "Role",  "Name", "Email", "Created At"
  ];
  List<List<String>> makeData = [];
  
  
  late DataUserAPI currentData = DataUserAPI(status: "", pesan: "", data: makeData);

  @override
  void initState() {
    super.initState();
    updateValue();
    timer = Timer.periodic(Duration(milliseconds: 500), (Timer t) => updateValue());
  }


  void updateValue() async {
    var url = Uri.parse("http://${globals.endpoint}/api_user.php?read");  
    try {
      final response = await http.get(url).timeout(
        const Duration(seconds: 1),
        onTimeout: () {
          return http.Response('Error', 408);
        },
      );
      if (response.statusCode == 200) {
        var respon = Json.tryDecode(response.body);
        if (this.mounted) {
          setState(() {
            currentData = DataUserAPI.fromJson(respon);
            print(currentData);
          });
        }
      }
    } on Exception catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
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
                  margin: new EdgeInsets.only(left: 20.0, right: 10.0, top: 135),
                  child: 
                      Text(
                        "Data User",
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
                            title: "Tambahkan Data",
                            content: Column(
                              children: <Widget>[
                                TextField(
                                  decoration: InputDecoration(
                                    // icon: Icon(Icons.account_circle),
                                    labelText: 'role',
                                  ),
                                  controller: _controller[0],
                                ),
                                TextField(
                                  // obscureText: true,
                                  decoration: InputDecoration(
                                    // icon: Icon(Icons.lock),
                                    labelText: 'name',
                                  ),
                                  controller: _controller[1],
                                ),
                                TextField(
                                  // obscureText: true,
                                  decoration: InputDecoration(
                                    // icon: Icon(Icons.lock),
                                    labelText: 'email',
                                  ),
                                  controller: _controller[2],
                                ),
                                TextField(
                                  // obscureText: true,
                                  decoration: InputDecoration(
                                    // icon: Icon(Icons.lock),
                                    labelText: 'password',
                                  ),
                                  controller: _controller[3],
                                ),
                              ],
                            ),
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "Submit",
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () async{                                  
                                  var url = Uri.parse("http://${globals.endpoint}/api_user.php?create&role=${_controller[0].text}&name=${_controller[1].text}&email=${_controller[2].text}&password=${_controller[3].text}");  
                                  try {
                                    final response = await http.get(url).timeout(
                                      const Duration(seconds: 1),
                                      onTimeout: () {
                                        return http.Response('Error', 408);
                                      },
                                    );
                                  } on Exception catch (_) {}
                                  Navigator.pop(context);
                                },
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
                  child: SimpleTablePageState(
                      // titleColumn: titleColumn,
                      // data: currentData.data,
                  ),
                )
              ]
              )
          )
          
        ],
      ),
    );
  }
}

class SimpleTablePageState extends StatefulWidget {
  SimpleTablePageState({
    Key? key
  }) : super(key: key);

 @override
  State<SimpleTablePageState> createState() => SimpleTablePage();
}

class SimpleTablePage extends State<SimpleTablePageState>{//StatelessWidget {

  List<TextEditingController> _controller = [
    TextEditingController(text: ''),
    TextEditingController(text: ''),
    TextEditingController(text: ''),
    TextEditingController(text: ''),
    TextEditingController(text: ''),
    TextEditingController(text: '')
  ];
  int? selectedRole;

  Timer? timer;
  List<String> titleColumn = [
    "id", "Role",  "Name", "Email", "Created At"
  ];
  List<List<String>> makeData = [];
  
  
  late DataUserAPI data = DataUserAPI(status: "", pesan: "", data: makeData);

  @override
  void initState() {
    super.initState();
    updateValue();
    timer = Timer.periodic(Duration(milliseconds: 500), (Timer t) => updateValue());
  }


  void updateValue() async {
    var url = Uri.parse("http://${globals.endpoint}/api_user.php?read");  
    try {
      final response = await http.get(url).timeout(
        const Duration(seconds: 1),
        onTimeout: () {
          return http.Response('Error', 408);
        },
      );
      if (response.statusCode == 200) {
        var respon = Json.tryDecode(response.body);
        if (this.mounted) {
          setState(() {
            data = DataUserAPI.fromJson(respon);
          });
        }
      }
    } on Exception catch (_) {}
  }
  // void updateValue() async {
  //   var url = Uri.parse("http://${globals.endpoint}/api_user.php?read");  
  //   try {
  //     final response = await http.get(url).timeout(
  //       const Duration(seconds: 1),
  //       onTimeout: () {
  //         return http.Response('Error', 408);
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       var respon = Json.tryDecode(response.body);
  //       if (this.mounted) {
  //         setState(() {
  //           currentData = DataUserAPI.fromJson(respon);
  //         });
  //       }
  //     }
  //   } on Exception catch (_) {}
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StickyHeadersTable(
        columnsLength: titleColumn.length,
        rowsLength: data.data.length,
        columnsTitleBuilder: (i) => Text(titleColumn[i]),
        contentCellBuilder: (i, j) => Text( i!=1?(i == 4 ? data.data[j][i+1] : data.data[j][i]):(data.data[j][i] == '1' ? "Admin" : "Inspektor") ),
        legendCell: Text(''),
        cellDimensions: CellDimensions.fixed(
          contentCellWidth: 100, 
          contentCellHeight: 50, 
          stickyLegendWidth: 85, 
          stickyLegendHeight: 50
        ),
        rowsTitleBuilder: (i) => Container(
          padding: EdgeInsets.only(left: 10),
          child: ElevatedButton(
            onPressed: (){
              setState(() {
                selectedRole = int.parse(data.data[i][1]);
                _controller[0].text = data.data[i][0];
                _controller[1].text = data.data[i][1];
                _controller[2].text = data.data[i][2];
                _controller[3].text = data.data[i][3];
                // _controller[4].text = data[i][4];
                _controller[5].text = data.data[i][5];
              });
              
              Alert(
                context: context,
                title: "Edit Data Apar",
                content: Column(
                  children: <Widget>[
                    TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        // icon: Icon(Icons.account_circle),
                        labelText: 'ID',
                      ),
                      controller: _controller[0],
                    ),
                    ListTile(
                      title: const Text('Admin'),
                      leading: Radio<int>(
                        value: 1,
                        groupValue: selectedRole,
                        onChanged: (int? value) {
                          setState(() {
                            selectedRole = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Inspektor'),
                      leading: Radio<int>(
                        value: 0,
                        groupValue: selectedRole,
                        onChanged: (int? value) {
                            selectedRole = value;
                        },
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        // icon: Icon(Icons.lock),
                        labelText: 'Role',
                      ),
                      controller: _controller[1],
                    ),
                    TextField(
                      decoration: InputDecoration(
                        // icon: Icon(Icons.lock),
                        labelText: 'Name',
                      ),
                      controller: _controller[2],
                    ),
                    TextField(
                      decoration: InputDecoration(
                        // icon: Icon(Icons.lock),
                        labelText: 'Email',
                      ),
                      controller: _controller[3],
                    ),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        // icon: Icon(Icons.lock),
                        labelText: 'Password',
                      ),
                      controller: _controller[4],
                    ),
                    TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        // icon: Icon(Icons.lock),
                        labelText: 'Timestamp',
                      ),
                      controller: _controller[5],
                    ),
                  ],
                ),
                buttons: [
                  DialogButton(         
                    color: Colors.red,   
                    child: Text(
                      "Delete",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () async {
                      var url = Uri.parse("http://${globals.endpoint}/api_user.php?delete&id=${_controller[0].text}");  
                      try {
                        final response = await http.get(url).timeout(
                          const Duration(seconds: 1),
                          onTimeout: () {
                            return http.Response('Error', 408);
                          },
                        );
                      } on Exception catch (_) {}
                      Navigator.pop(context);
                    }
                  ),
                  DialogButton(            
                    child: Text(
                      "Update",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () async {
                      if(_controller[4].text == '' || _controller[4].text == null) _controller[4].text = data.data[i][4];
                      print(_controller[4].text);
                      var url = Uri.parse("http://${globals.endpoint}/api_user.php?update&id=${_controller[0].text}&role=${_controller[1].text}&name=${_controller[2].text}&email=${_controller[3].text}&password=${_controller[4].text}");  
                      try {
                        final response = await http.get(url).timeout(
                          const Duration(seconds: 1),
                          onTimeout: () {
                            return http.Response('Error', 408);
                          },
                        );
                        print(response.body);
                      } on Exception catch (_) {}
                      Navigator.pop(context);
                    }
                  )
                ]).show();
            }, 
            child: Text("Edit")
          ),
        ),
      ),
    );
  }
}