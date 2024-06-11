// ignore_for_file: file_names, camel_case_types, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_constructors_in_immutables, use_build_context_synchronously, sized_box_for_whitespace, sort_child_properties_last, unused_local_variable, must_be_immutable, prefer_final_fields, use_key_in_widget_constructors, unnecessary_this

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:ppns_fire_fighters/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:table_sticky_headers/table_sticky_headers.dart';
import 'package:ppns_fire_fighters/admin/DataModel.dart';
import 'dart:async';


class DataHydrantOHB extends StatefulWidget {
  DataHydrantOHB({super.key, this.restorationId});

  final String? restorationId;
  
  @override
  _DataHydrantOHBState createState() => _DataHydrantOHBState();
}


class _DataHydrantOHBState extends State<DataHydrantOHB> with RestorationMixin {
  @override
  String? get restorationId => widget.restorationId;
  final RestorableDateTime _selectedDate =
      RestorableDateTime(DateTime(2021, 7, 25));
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  @pragma('vm:entry-point')
  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year-5),
          lastDate: DateTime(DateTime.now().year+20),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  List<TextEditingController> _controller = [
    TextEditingController(text: ''),
    TextEditingController(text: ''),
    TextEditingController(text: '')
  ];

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        _controller[2].text = "${_selectedDate.value.year}-${_selectedDate.value.month}-${_selectedDate.value.day} 00:00:00";
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text(_controller[2].text),
        // ));
      });
    }
  }

  Timer? timer;
  List<String> titleColumn = [
    "id", "Nomor",  "Lokasi", "Created at"
  ];
  List<List<String>> makeData = [];
  
  
  late DataAPIHydrant currentData = DataAPIHydrant(status: "", pesan: "", data: makeData);

  @override
  void initState() {
    super.initState();
    updateValue();
    timer = Timer.periodic(Duration(milliseconds: 500), (Timer t) => updateValue());
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  void updateValue() async {
    var url = Uri.parse("http://${globals.endpoint}/api_hydrant.php?read&jenis=ohb");  
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
            currentData = DataAPIHydrant.fromJson(respon);
          });
        }
      }
    } on Exception catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
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
            
          Align(
              alignment: Alignment.topLeft,
              child: Column(children: [
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 10.0, top: 135),
                  child: 
                      Text(
                        "Data Hydrant OHB",
                        style: TextStyle(
                          fontFamily: "SanFrancisco",
                          decoration: TextDecoration.none,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
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
                  margin: EdgeInsets.only(left: 30.0, right: 10.0, top: 123),
                  child: ElevatedButton(
                    child: Text(
                      "Tambahkan Data",
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    onPressed: (){
                          setState(() {
                            _controller[2].text = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";
                          });
                          Alert(
                            context: context,
                            title: "Tambahkan Data",
                            content: Column(
                              children: <Widget>[
                                TextField(
                                  decoration: InputDecoration(
                                    // icon: Icon(Icons.account_circle),
                                    labelText: 'Nomor',
                                  ),
                                  controller: _controller[0],
                                ),
                                TextField(
                                  // obscureText: true,
                                  decoration: InputDecoration(
                                    // icon: Icon(Icons.lock),
                                    labelText: 'Lokasi',
                                  ),
                                  controller: _controller[1],
                                ),
                                Padding(padding: EdgeInsets.all(10)),
                              ],
                            ),
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "Submit",
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () async{                                  
                                  var url = Uri.parse("http://${globals.endpoint}/api_hydrant.php?create&jenis=ohb&nomor=${_controller[0].text}&lokasi=${_controller[1].text}");  
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
                  margin: EdgeInsets.only(top: 180),
                  decoration: BoxDecoration(color: const Color.fromARGB(49, 244, 67, 54)),
                  child: SimpleTablePage(
                      titleColumn: titleColumn,
                      data: currentData.data,
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


class SimpleTablePage extends StatelessWidget {
  SimpleTablePage({
    required this.data,
    required this.titleColumn,
  });

  final List<List<String>> data;
  final List<String> titleColumn;
  List<TextEditingController> _controller = [
    TextEditingController(text: ''),
    TextEditingController(text: ''),
    TextEditingController(text: ''),
    TextEditingController(text: '')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StickyHeadersTable(
        columnsLength: titleColumn.length,
        rowsLength: data.length,
        columnsTitleBuilder: (i) => Text(titleColumn[i]),
        contentCellBuilder: (i, j) => Text(data[j][i]),
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
              _controller[0].text = data[i][0];
              _controller[1].text = data[i][1];
              _controller[2].text = data[i][2];
              _controller[3].text = data[i][3];
              Alert(
                context: context,
                title: "Edit Data Hydrant OHB",
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
                    TextField(
                      decoration: InputDecoration(
                        // icon: Icon(Icons.lock),
                        labelText: 'Nomor',
                      ),
                      controller: _controller[1],
                    ),
                    TextField(
                      decoration: InputDecoration(
                        // icon: Icon(Icons.lock),
                        labelText: 'Lokasi',
                      ),
                      controller: _controller[2],
                    ),
                    TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        // icon: Icon(Icons.lock),
                        labelText: 'Created at',
                      ),
                      controller: _controller[3],
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
                      var url = Uri.parse("http://${globals.endpoint}/api_hydrant.php?delete&id=${_controller[0].text}");  
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
                      var url = Uri.parse("http://${globals.endpoint}/api_hydrant.php?update&id=${_controller[0].text}&nomor=${_controller[1].text}&lokasi=${_controller[2].text}");  
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