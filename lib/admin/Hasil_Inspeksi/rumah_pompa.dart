// ignore_for_file: file_names, camel_case_types, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_constructors_in_immutables, use_build_context_synchronously, sized_box_for_whitespace, sort_child_properties_last, unused_local_variable, must_be_immutable, prefer_final_fields, use_key_in_widget_constructors, unnecessary_this, depend_on_referenced_packages, non_constant_identifier_names, curly_braces_in_flow_control_structures, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:ppns_fire_fighters/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:table_sticky_headers/table_sticky_headers.dart';
import 'package:ppns_fire_fighters/admin/DataModel.dart';
import 'dart:async';
import 'package:month_year_picker/month_year_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


class HasilRumahPompa extends StatefulWidget {
  HasilRumahPompa({super.key, this.restorationId});
  final String? restorationId;

  @override
  _HasilRumahPompaState createState() => _HasilRumahPompaState();
}


class _HasilRumahPompaState extends State<HasilRumahPompa> with RestorationMixin {
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
  static String lokasiText = "Lokasi";
  static String kondisiText = "Kondisi rumah pompa Panas memadai";
  static String ventilasiText = "Ventilasi";
  static String katup_hisapText = "Katup hisap dan pelepasan pompa serta katup bypass terbuka penuh";
  static String perpipaanText = "Perpipaan bebas dari kebocoran.";
  static String pengukur_hisapText = "Pembacaan pengukur tekanan saluran hisap";
  static String pengukur_sistemText = "Pembacaan pengukur tekanan saluran sistem";
  static String tangki_hisapText = "Tangki hisap penuh";
  static String saringan_hisapText = "Saringan hisap lubang basah";
  static String katup_ujiText = "Katup uji aliran air";
  static String lampu_pengontrolText = "Lampu pilot pengontrol (daya hidup) menyala.";
  static String lampu_saklarText = "Lampu pilot normal sakelar transfer menyala";
  static String saklar_isolasiText = "Sakelar isolasi tertutup — sumber siaga (darurat).";
  static String lampu_rotasiText = "lampu pilot rotasi fase normal menyala.";
  static String level_oli_motorText = "Level oli pada kaca penglihatan motor vertical";
  static String pompa_pemeliharaanText = "Pompa pemeliharaan daya untuk tekanan jockey pump";
  static String tangki_bahan_bakarText = "Tangki bahan bakar terisi minimal dua pertiganya.";
  static String saklar_pemilihText = "Sakelar pemilih pengontrol berada pada posisi otomatis.";
  static String pembacaan_teganganText = "Pembacaan tegangan baterai";
  static String pembacaan_arusText = "Pembacaan arus pengisian baterai";
  static String lampu_bateraiText = "lampu pilot baterai menyala atau baterai rusak lampu pilot mati.";
  static String semua_lampu_alarmText = "Semua lampu pilot alarm mati";
  static String pengukur_waktuText = "Pengukur waktu berjalan mesin sedang membaca";
  static String ketinggian_oliText = "Ketinggian oli pada penggerak gigi sudut kanan";
  static String level_oli_mesinText = "Level oli bak mesin";
  static String ketinggian_airText = "Ketinggian air pendingin";
  static String tingkat_elektrolitText = "Tingkat elektrolit dalam baterai";
  static String terminal_bateraiText = "Terminal baterai bebas dari korosi";
  static String pemanas_jaketText = "Pemanas jaket air sedang beroperasi";
  static String kondisi_uapText = "Kondisi sistem uap";

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
  DateTime selectedDate = DateTime.now();
  Timer? timer;
  List<String> titleColumn = [
    "id inspeksi", 
    "Email Inspektor", 
    lokasiText,
    kondisiText,
    ventilasiText,
    katup_hisapText,
    perpipaanText,
    pengukur_hisapText,
    pengukur_sistemText,
    tangki_hisapText,
    saringan_hisapText,
    katup_ujiText,
    lampu_pengontrolText,
    lampu_saklarText,
    saklar_isolasiText,
    lampu_rotasiText,
    level_oli_motorText,
    pompa_pemeliharaanText,
    tangki_bahan_bakarText,
    saklar_pemilihText,
    pembacaan_teganganText,
    pembacaan_arusText,
    lampu_bateraiText,
    semua_lampu_alarmText,
    pengukur_waktuText,
    ketinggian_oliText,
    level_oli_mesinText,
    ketinggian_airText,
    tingkat_elektrolitText,
    terminal_bateraiText,
    pemanas_jaketText,
    kondisi_uapText,
  ];
  TextStyle tsyleTitle = TextStyle(
    fontSize: 18,
  );
  TextStyle tsyleContent = TextStyle(
    fontSize: 18,
  );
  List<String> titleColumn2 = [
    "id", "Lokasi", "Timestamp"
  ];
  
  List<String> titleColumnExport = [
    "id inspeksi", 
    "Email Inspektor",     
    lokasiText,
    kondisiText,
    ventilasiText,
    katup_hisapText,
    perpipaanText,
    pengukur_hisapText,
    pengukur_sistemText,
    tangki_hisapText,
    saringan_hisapText,
    katup_ujiText,
    lampu_pengontrolText,
    lampu_saklarText,
    saklar_isolasiText,
    lampu_rotasiText,
    level_oli_motorText,
    pompa_pemeliharaanText,
    tangki_bahan_bakarText,
    saklar_pemilihText,
    pembacaan_teganganText,
    pembacaan_arusText,
    lampu_bateraiText,
    semua_lampu_alarmText,
    pengukur_waktuText,
    ketinggian_oliText,
    level_oli_mesinText,
    ketinggian_airText,
    tingkat_elektrolitText,
    terminal_bateraiText,
    pemanas_jaketText,
    kondisi_uapText,

  ];
  List<String> titleColumnExport2 = [
    "id", "Nomor Hydrant", "Lokasi", "Timestamp"
  ];

  List<List<String>> makeData = [];
  
  
  late DataInspeksiRumahPompaAPI currentData = DataInspeksiRumahPompaAPI(status: "", pesan: "", data: makeData);
  static List<String> columnExcel = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'X', 'Y', 'Z'];
  static List<String> DropDownName = <String>['Sudah Di Inspeksi', 'Belum Di Inspeksi'];
  String dropdownValue = DropDownName.first;
  
  static List<String> FilterKerusakan = <String>['Kerusakan : Tampilkan Semua', 'Kerusakan : Tidak', 'Kerusakan : Rusak'];
  String FilterKerusakanValue = FilterKerusakan.first; 
  String kerusakan = "semua";

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
    var url = Uri.parse("http://${globals.endpoint}/api_inspeksi_rumah_pompa.php?read&start_date=${selectedDate.year}-${selectedDate.month}-1 00:00:00&end_date=${selectedDate.year}-${selectedDate.month}-31 23:59:59&kerusakan=${kerusakan}");  
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
          if(respon?.isNotEmpty ?? false){
          setState(() {
            currentData = DataInspeksiRumahPompaAPI.fromJson(respon);
          });
          }
          // print(currentData.data[0]);
        }
      }
    } on Exception catch (_) {}

    setState(() {
      tsyleTitle = TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500
      );
      tsyleContent = TextStyle(
        fontSize: 18,
        // fontWeight: FontWeight.w700
      );
    });
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
                        "Hasil Inspeksi Hydrant OHB",
                        style: TextStyle(
                          fontFamily: "SanFrancisco",
                          decoration: TextDecoration.none,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
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
                      "Export Excel",
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    onPressed: () async{
                       var status = await Permission.storage.status;
                        if (!status.isGranted) {
                          await Permission.storage.request();
                        }
                        if(currentData.data.isNotEmpty){
                          var excel = Excel.createExcel();
                          Sheet sheetObject = excel['Sheet1'];
                          // CellStyle cellStyle = CellStyle(fontFamily :getFontFamily(FontFamily.Calibri));
                          for(int a = 0; a< titleColumn.length; a++){
                            sheetObject.cell(CellIndex.indexByString('A${a+1}')).value = TextCellValue(titleColumn[a]);
                            sheetObject.cell(CellIndex.indexByString('B${a+1}')).value = TextCellValue(currentData.data[0][a]);
                          }          
                          var fileBytes = excel.save();

                          Directory appDocDirectory = await getApplicationDocumentsDirectory();
                          var dir = "/storage/emulated/0/ppns_fire_fighters/export/inspeksi_rumah_pompa_${globals.monthName[selectedDate.month-1]}_${selectedDate.year}.xlsx";
                          // var dir = "${appDocDirectory.path}/export/${inspeksi}_inspeksi_apar_${monthName[selectedDate.month-1]}_${selectedDate.year}.xlsx";
                          File(join(dir))
                            ..createSync(recursive: true)
                            ..writeAsBytesSync(fileBytes!);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Export Complete\nDir : ${dir}"),
                          ));
                        } 
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  )
                ),
            ])),
            
          Align(
              alignment: Alignment.topLeft,
              child: Column(children: [
                Container(
                  margin: EdgeInsets.only(left: 20.0, right: 10.0, top: 170),
                  child: ElevatedButton(
                    child: Text(
                      "${globals.monthName[selectedDate.month-1]} ${selectedDate.year}",
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    onPressed: () async{
                        final selected = await showMonthYearPicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(DateTime.now().year-10),
                          lastDate: DateTime(DateTime.now().year+1),
                        );
                        setState(() {
                          if(selected != null) selectedDate = selected;
                        });
                        updateValue();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  )
                ),
            ])),
            Align(
              alignment: Alignment.topRight,
              child: Column(children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height-230,
                  margin: EdgeInsets.only(top: 230),
                  // decoration: BoxDecoration(color: const Color.fromARGB(49, 244, 67, 54)),
                  child: SingleChildScrollView(child:
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(currentData.data.isNotEmpty) for(int a=0; a<titleColumn.length; a++) Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(style: tsyleTitle, "${titleColumn[a]} : "),
                            Text(style: tsyleContent, "${currentData.data[0][a]}"),
                            SizedBox(height: 10),
                        ],)
                      ],
                    ),
                  ),
                  ),
                )
              ]
              )
          )
          
        ],
      ),
    ));
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
        contentCellBuilder: (i, j) => Text((i > 1 ? data[j][i+1] : data[j][i])),
        // legendCell: Text('No Hydrant'),
        cellDimensions: CellDimensions.fixed(
          contentCellWidth: 120, 
          contentCellHeight: 50, 
          stickyLegendWidth: 85, 
          stickyLegendHeight: 50
        ),
        rowsTitleBuilder: (i) => Text(data[i][2]),
      ),
    );
  }
}