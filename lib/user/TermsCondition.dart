// ignore_for_file: file_names, camel_case_types, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_constructors_in_immutables, use_build_context_synchronously, sized_box_for_whitespace, sort_child_properties_last, non_constant_identifier_names, no_logic_in_create_state, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, must_be_immutable, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:ppns_fire_fighters/user/input_nomor.dart';
import 'package:ppns_fire_fighters/user/inspeksi/Inspeksi_Rumah_Pompa.dart';


class TermsCondition extends StatefulWidget {
  TermsCondition({required this.code, Key? key}) : super(key: key);
  String code;
  @override
  _TermsConditionState createState() => _TermsConditionState(code: code);
}

class _TermsConditionState extends State<TermsCondition> {
  _TermsConditionState({required this.code});
  String code;
  String nfpa = "";
  String desc = "";
  @override
  void initState() {
    super.initState();
    if(code == "apar"){
      setState(() {
        nfpa = "NFPA 10";
        desc = """
Pasal F.7.2.2
1. Memastikan APAR terletak di tempat yang sudah ditentukan sebelumnya.
2. Memastikan APAR terlihat dengan mudah atau ada tanda yang menunjukkan di mana alat pemadam api berada.
3. Memastikan APAR dapat diakses dengan mudah.
4. Memastikan pengukur tekanan berada dalam rentang atau posisi yang dapat dioperasikan.
5. Memastikan tabung alat pemadam api sudah terisi penuh dengan media yang diperlukan. Untuk memastikan, Anda bisa angkat tabung APAR atau dengan cara menimbangnya. Jika dirasa berat, berarti APAR sudah terisi dengan media pemadam api.
6. Jika menggunakan alat pemadam api berukuran besar/beroda, pastikan kondisi ban, roda, troli, selang, dan Nozzle dapat berfungsi dengan baik.
7. Kemudian untuk alat pemadam yang tidak dapat diisi ulang, Anda dapat mengecek pada bagian indikator tekanan alat pemadam api ringan.""";
      });
    }
    else if(code == "hydrantIHB" || code == "hydrantOHB"){
      setState(() {
        nfpa = "NFPA 25";
        desc = """
Pasal 7.2
1. Lakukan koordinasi dengan tim K3 atau operator gedung tempat fire hydrant tersebut berada saat akan mengaktifkan hydrant.
2. Standar inspeksi hydrant diawali dengan pemeriksaan visual dari keadaan di sekitar area hydrant.
3. Lakukan pemeriksaan terhadap semua hydrant valve atau katup, sambungan, serta sistem perpipaan. Buka setiap valve hydrant, kemudian perhatikan bagaimana kinerjanya. Apabila ditemukan adanya gangguan pada kinerja sistem, maka segera ganti komponen tersebut dengan yang baru. Selain itu, cek juga bagaimana kondisi tutup valve serta lubrikasinya.
4. Pasang hydrant equipment yang meliputi hose dan Nozzle. Kondisinya komponen tersebut dalam posisi siap untuk digunakan.
5. Aktifkan hydrant pump, lalu alirkan air secara perlahan hingga ke posisi terbuka penuh.
6. Lakukan pengecekan terhadap instalasi fire hydrant pada saat air dialirkan dari pompa. Periksa apakah ditemukan adanya kebocoran. Jika ada yang bocor, maka harus segera diperbaiki.
7. Standar inspeksi hydrant juga mencakup pemeriksaan kejernihan air yang mengalir dari instalasi fire hydrant.
8. Lakukan flushing yang bertujuan untuk menghilangkan endapan dalam instalasi hydrant. Endapan tersebut harus dihilangkan karena bisa menahan laju pasokan air untuk instalasi hydrant. Selanjutnya, tutup kran air secara perlahan supaya tidak mengalami water hammer. 
9. Jika pemeriksaan dan pengujian hydrant sudah selesai dilakukan, buat dokumentasi atas kegiatan inspeksi yang sudah dilakukan kali ini.""";
      });
    }
    else if(code == "rumah_pompa"){
      setState(() {
        nfpa = "NFPA 25";
        desc = """
Pasal 8.2.2
1.	Kondisi rumah pompa Panas nya harus memadai, tidak kurang dari 40°F (5°C) untuk ruang pompa dengan pompa diesel tanpa pemanas mesin.
2.	Ventilasi bebas dioperasikan.
3.	Kondisi Katup hisap dan pelepasan pompa serta katup bypass terbuka penuh.
4.	Perpipaan bebas dari kebocoran.
5.	Pembacaan pengukur tekanan saluran hisap, saluran system, berada dalam kisaran yang aman
6.	Tangki hisap penuh
7.	Saringan hisap lubang basah tidak terhalang dan berada pada tempatnya.
8.	Katup uji aliran air berada dalam posisi tertutup.
9.	Kondisi sistem kelistrikan Lampu pilot pengontrol (daya hidup) dan Lampu pilot normal sakelar transfer menyala
10.	Sakelar isolasi tertutup — sumber siaga (darurat).
11.	Lampu pilot alarm fase mundur mati, atau lampu pilot rotasi fase normal menyala.
12.	Level oli pada kaca penglihatan motor vertikal berada dalam kisaran yang dapat diterima.
13.	Pompa pemeliharaan daya untuk tekanan (joki) disediakan.
14.	Kondisi sistem mesin diesel Tangki bahan bakar terisi minimal dua pertiganya.
15.	Sakelar pemilih pengontrol berada pada posisi otomatis.
16.	Pembacaan tegangan, arus pengisian, baterai berada dalam kisaran yang dapat diterima.
17.	lampu pilot baterai menyala atau baterai rusak lampu pilot mati.
18.	Semua lampu pilot alarm mati.
19.	Pengukur waktu berjalan mesin sedang membaca.
20.	Ketinggian oli pada penggerak gigi sudut kanan, Level oli bak mesin, Ketinggian air pendingin, Tingkat elektrolit dalam baterai, serta Kondisi sistem uap: Pembacaan pengukur tekanan uap berada dalam kisaran yang dapat diterima.
21.	Terminal baterai bebas dari korosi.
22.	Pemanas jaket air sedang beroperasi.""";
      });
    }
  }
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(    
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: <Widget>[
              
              Align(
                  alignment: Alignment.topCenter,
                  child: Column(children: [
                    Container(
                      margin: EdgeInsets.only(top: 40),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            'assets/img/logoHorizontal.png',
                            width: MediaQuery.of(context).size.width - 70,
                          ),
                        ],
                      ),
                    ),
                ])),
                
              Align(
                  alignment: Alignment.topCenter,
                  child: Column(children: [
                    Container(
                      margin: EdgeInsets.only(top: 130),
                      child: 
                          Text(
                            "AS REGULATORY INFORMATION IS USED",
                            style: TextStyle(
                              fontFamily: "SanFrancisco",
                              decoration: TextDecoration.none,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              color: Colors.black
                            ),
                          ),
                    ),
                  ]
                )
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: Column(children: [
                    Container(
                      margin: EdgeInsets.only(top: 140),
                      child: 
                          Text(
                            nfpa,
                            style: TextStyle(
                              fontFamily: "SanFrancisco",
                              decoration: TextDecoration.none,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w900,
                              fontSize: 50,
                              color: Colors.black
                            ),
                          ),
                    ),
                  ]
                )
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: Column(children: [                    
                     Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height-350,
                        margin: EdgeInsets.only(left:30, right: 30, bottom: 200 , top: 220),
                        // decoration: new BoxDecoration(color: const Color.fromARGB(49, 244, 67, 54)),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                // margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 15),
                                child: 
                                Text(desc,
                                  style: TextStyle(
                                    fontFamily: "SanFrancisco",
                                    decoration: TextDecoration.none,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12.5,
                                    color: Colors.black
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                    )
                  ]
                  )
              ),

              Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(children: [
                    Container(
                      margin: EdgeInsets.only(left:20, right: 20, top: MediaQuery.of(context).size.height-120),
                      child: 
                      Row(children: [
                        
                      Checkbox(
                          value: checked,
                          onChanged: (bool? value) {
                            setState(() {
                              checked = value!;
                            });
                          },
                        ),
                        Flexible(
                          child: Text(
                            "I have read, understand and comprehend the regulatory provisions used. I am responsible for the entered data.",
                            style: TextStyle(
                                  fontFamily: "SanFrancisco",
                                  decoration: TextDecoration.none,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 12.5,
                                  color: Colors.black
                                ),
                            ),
                        ),
                      ],)
                    ),
                  ]
                )
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Column(children: [
                    Container(
                      margin: EdgeInsets.only(left:20, right: 20, top: MediaQuery.of(context).size.height-60),
                      child: 
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white
                          ),
                          onPressed: !checked ? null : (){     
                            setState(() {
                              checked = false;
                            });                                          
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return code == "rumah_pompa" ? InspeksiRumahPompa() :  InputNomor(code: code);
                              }),
                            );
                          }, 
                          child: Text("Next")
                        ),
                    ),
                  ]
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}