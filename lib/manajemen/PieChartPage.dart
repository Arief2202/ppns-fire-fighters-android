// ignore_for_file: file_names, camel_case_types, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_constructors_in_immutables, use_build_context_synchronously, sized_box_for_whitespace, sort_child_properties_last, unused_import

import 'package:flutter/material.dart';
import 'package:ppns_fire_fighters/admin/Hasil_Inspeksi.dart';
import 'package:ppns_fire_fighters/admin/Users.dart';
import 'package:ppns_fire_fighters/admin/DataAparHydrant.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'dart:async';
import 'package:ppns_fire_fighters/globals.dart' as globals;
import 'package:ppns_fire_fighters/notification.dart';
import 'package:ppns_fire_fighters/admin/DataModel.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart';
import 'package:month_year_picker/month_year_picker.dart';

String inspeksi = 'sudah';

class PieChartPage extends StatefulWidget {
  PieChartPage({Key? key, this.restorationId});
  final String? restorationId;

  @override
  _PieChartPageState createState() => _PieChartPageState();
}

class _PieChartPageState extends State<PieChartPage> with RestorationMixin {
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
          firstDate: DateTime(DateTime.now().year - 5),
          lastDate: DateTime(DateTime.now().year + 20),
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
        _controller[2].text =
            "${_selectedDate.value.year}-${_selectedDate.value.month}-${_selectedDate.value.day} 00:00:00";
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text(_controller[2].text),
        // ));
      });
    }
  }

  DateTime selectedDate = DateTime.now();
  static List<String> DropDownName = <String>[
    'Sudah Di Inspeksi',
    'Belum Di Inspeksi'
  ];
  String dropdownValue = DropDownName.first;

  Map<String, double> dataMapApar = {
    "Rusak": 0,
    "Belum di inspeksi": 0,
    "Normal": 0,
  };
  Map<String, double> dataMapIHB = {
    "Rusak": 0,
    "Belum di inspeksi": 0,
    "Normal": 0,
  };
  Map<String, double> dataMapOHB = {
    "Rusak": 0,
    "Belum di inspeksi": 0,
    "Normal": 0,
  };

  @override
  void initState() {
    print(selectedDate);
    updateValue();
    globals.timerData = Timer.periodic(Duration(milliseconds: 500), (Timer t) => updateValue());
    super.initState();
  }
  
  @override
  void dispose() {
    globals.timerData!.cancel();
    super.dispose();
  }


  void updateValue() async{
    try {
      final response = await http.get(Uri.parse("http://${globals.endpoint}/api_chart.php?read&start_date=${selectedDate.year}-${selectedDate.month}-1 00:00:00&end_date=${selectedDate.year}-${selectedDate.month}-31 23:59:59")).timeout(
        const Duration(seconds: 1),
        onTimeout: () {
          return http.Response('Error', 408);
        },
      );
      if (response.statusCode == 200) {
        var respon = Json.tryDecode(response.body)['data'];
        print(respon);
        if(this.mounted){
          setState(() {
            dataMapApar['Rusak'] = double.parse(respon['apar']['rusak']);
            dataMapApar['Belum di inspeksi'] = double.parse(respon['apar']['belum']);
            dataMapApar['Normal'] = double.parse(respon['apar']['normal']);
            
            dataMapIHB['Rusak'] = double.parse(respon['ihb']['rusak']);
            dataMapIHB['Belum di inspeksi'] = double.parse(respon['ihb']['belum']);
            dataMapIHB['Normal'] = double.parse(respon['ihb']['normal']);

            dataMapOHB['Rusak'] = double.parse(respon['ohb']['rusak']);
            dataMapOHB['Belum di inspeksi'] = double.parse(respon['ohb']['belum']);
            dataMapOHB['Normal'] = double.parse(respon['ohb']['normal']);
          });
        }
      }
    } on Exception catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          DialogButton(
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () async {
                                if(globals.timerData != null) globals.timerData!.cancel();
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
                    margin: EdgeInsets.only(left: 20.0, right: 10.0, top: 120),
                    child: ElevatedButton(
                      child: Text(
                        "${globals.monthName[selectedDate.month - 1]} ${selectedDate.year}",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        final selected = await showMonthYearPicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(DateTime.now().year - 10),
                          lastDate: DateTime(DateTime.now().year + 1),
                        );
                        setState(() {
                          if (selected != null) selectedDate = selected;
                        });
                        // updateValue();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                    )),
              ])),
          // Align(
          //     alignment: Alignment.topRight,
          //     child: Column(children: [
          //       Container(
          //           margin: EdgeInsets.only(left: 20.0, right: 10.0, top: 120),
          //           height: 48,
          //           width: MediaQuery.of(context).size.width - 200,
          //           child: DropdownButton(
          //             value: dropdownValue,
          //             icon: Icon(Icons.arrow_downward),
          //             iconSize: 24,
          //             elevation: 16,
          //             isExpanded: true,
          //             style: TextStyle(color: Colors.blue, fontSize: 14.0),
          //             underline: Container(
          //               height: 2,
          //               color: Colors.blue,
          //             ),
          //             onChanged: (String? newValue) {
          //               setState(() {
          //                 dropdownValue = newValue!;
          //                 if (newValue == DropDownName[0])
          //                   inspeksi = "sudah";
          //                 else if (newValue == DropDownName[1])
          //                   inspeksi = "belum";
          //                 else
          //                   inspeksi = "sudah";
          //               });
          //               // updateValue();
          //             },
          //             items: DropDownName.map<DropdownMenuItem<String>>(
          //                 (String value) {
          //               return DropdownMenuItem<String>(
          //                 value: value,
          //                 child: Text(value),
          //               );
          //             }).toList(),
          //           )),
          //     ])),

          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 200),
              height: MediaQuery.of(context).size.height - 200,
              // width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  PieChart(
                    dataMap: dataMapApar,
                    animationDuration: Duration(milliseconds: 800),
                    chartLegendSpacing: 32,
                    chartRadius: MediaQuery.of(context).size.width / 3.2,
                    // colorList: colorList,
                    initialAngleInDegree: 0,
                    chartType: ChartType.ring,
                    ringStrokeWidth: 32,
                    centerText: "APAR",
                    legendOptions: LegendOptions(
                      showLegendsInRow: false,
                      legendPosition: LegendPosition.right,
                      showLegends: true,
                      // legendShape: _BoxShape.circle,
                      legendTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    chartValuesOptions: ChartValuesOptions(
                      showChartValueBackground: true,
                      showChartValues: true,
                      showChartValuesInPercentage: false,
                      showChartValuesOutside: false,
                      decimalPlaces: 1,
                    ),
                  ),
                  SizedBox(height: 50),
                  PieChart(
                    dataMap: dataMapIHB,
                    animationDuration: Duration(milliseconds: 800),
                    chartLegendSpacing: 32,
                    chartRadius: MediaQuery.of(context).size.width / 3.2,
                    // colorList: colorList,
                    initialAngleInDegree: 0,
                    chartType: ChartType.ring,
                    ringStrokeWidth: 32,
                    centerText: "Hydrant\nIHB",
                    legendOptions: LegendOptions(
                      showLegendsInRow: false,
                      legendPosition: LegendPosition.right,
                      showLegends: true,
                      // legendShape: _BoxShape.circle,
                      legendTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    chartValuesOptions: ChartValuesOptions(
                      showChartValueBackground: true,
                      showChartValues: true,
                      showChartValuesInPercentage: false,
                      showChartValuesOutside: false,
                      decimalPlaces: 1,
                    ),
                  ),
                  SizedBox(height: 50),
                  PieChart(
                    dataMap: dataMapOHB,
                    animationDuration: Duration(milliseconds: 800),
                    chartLegendSpacing: 32,
                    chartRadius: MediaQuery.of(context).size.width / 3.2,
                    // colorList: colorList,
                    initialAngleInDegree: 0,
                    chartType: ChartType.ring,
                    ringStrokeWidth: 32,
                    centerText: "Hydrant\nOHB",
                    legendOptions: LegendOptions(
                      showLegendsInRow: false,
                      legendPosition: LegendPosition.right,
                      showLegends: true,
                      // legendShape: _BoxShape.circle,
                      legendTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    chartValuesOptions: ChartValuesOptions(
                      showChartValueBackground: true,
                      showChartValues: true,
                      showChartValuesInPercentage: false,
                      showChartValuesOutside: false,
                      decimalPlaces: 1,
                    ),
                  )
                ],
              )),
            ),
          ),

          // Align(
          //     alignment: Alignment.topRight,
          //     child: Column(children: [
          //       Text("Test"),
          //       // Container(
          //       //   width: MediaQuery.of(context).size.width,
          //       //   height: MediaQuery.of(context).size.height-220,
          //       //   margin: EdgeInsets.only(top: 220),
          //       //   decoration: BoxDecoration(color: const Color.fromARGB(49, 244, 67, 54)),
          //       //   child: SimpleTablePage(
          //       //       titleColumn: inspeksi == "sudah" ? titleColumn : titleColumn2,
          //       //       data: inspeksi == "sudah" ? currentData.data : currentDataApar.data,
          //       //   ),
          //       // )
          //     ]
          //     )
          // )
        ],
      ),
    ));
  }
}
