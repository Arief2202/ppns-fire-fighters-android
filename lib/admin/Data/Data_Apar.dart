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
import 'dart:async';


class DataApar extends StatefulWidget {
  DataApar({super.key, this.restorationId});

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
  _DataAparState createState() => _DataAparState();
}


class _DataAparState extends State<DataApar> with RestorationMixin {
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
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2021),
          lastDate: DateTime(2022),
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

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        ));
      });
    }
  }

  Timer? timer;
  List<String> titleColumn = [
    "id", "Nomor",  "Lokasi", "Tanggal Kadaluarsa", "Timestamp"
  ];
  List<List<String>> makeData = [
    ["id", "Nomor",  "Lokasi", "Tanggal Kadaluarsa", "Timestamp"],
    // ["id", "Nomor",  "Lokasi", "Tanggal Kadaluarsa", "Timestamp"],
  ];
  
  
  late DataAparAPI currentData = DataAparAPI(status: "", pesan: "", data: makeData);

  @override
  void initState() {
    super.initState();
    updateValue();
    // getEndpoint();
    timer = Timer.periodic(Duration(milliseconds: 500), (Timer t) => updateValue());
  }


  void updateValue() async {
    var url = Uri.parse("http://${globals.endpoint}/api_apar.php?read");  
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
            currentData = DataAparAPI.fromJson(respon);
            // currentData = FromAPI.fromJson(Json.tryDecode(response.body));
            // _currentSliderValue = double.parse(
            //     currentData.kecerahan_lampu![_selectedIndex].kecerahan_lampu);
          });
        }
        print(currentData.data);
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
                        "Data APAR",
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
                                    labelText: 'Nomor',
                                  ),
                                ),
                                TextField(
                                  // obscureText: true,
                                  decoration: InputDecoration(
                                    // icon: Icon(Icons.lock),
                                    labelText: 'Lokasi',
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(10)),
                                OutlinedButton(
                                  onPressed: () {
                                    _restorableDatePickerRouteFuture.present();
                                  },
                                  child: const Text('Tanggal Kadaluarsa'),
                                ),
                                // TextField(
                                //   // obscureText: true,
                                //   decoration: InputDecoration(
                                //     // icon: Icon(Icons.lock),
                                //     labelText: 'Tanggal Kadaluarsa',
                                //   ),
                                // ),
                              ],
                            ),
                            buttons: [
                              DialogButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "Submit",
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StickyHeadersTable(
        columnsLength: titleColumn.length,
        rowsLength: data.length,
        columnsTitleBuilder: (i) => Text(titleColumn[i]),
        rowsTitleBuilder: (i) => Text('${i}'),
        contentCellBuilder: (i, j) => Text(data[j][i]),
        legendCell: Text(''),
        cellDimensions: CellDimensions.fixed(
          contentCellWidth: 100, 
          contentCellHeight: 50, 
          stickyLegendWidth: 85, 
          stickyLegendHeight: 50
        ),
      ),
    );
  }
}