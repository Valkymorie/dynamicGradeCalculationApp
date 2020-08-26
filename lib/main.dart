import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dersAdi;
  int dersKredi;
  double dersHarfNotu;
  var key = GlobalKey<FormState>();
  List<Dersler> tumDersler = [];
  double ortalama;
  int toplamKrediSayisi = 40;
  int dissmisibleKey=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tumDersler = [];
    toplamKrediSayisi = 40;
    dissmisibleKey=0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("NOT HESAPLAMA"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (key.currentState.validate()) {
              key.currentState.save();
            }
          });
        },
        child: Icon(Icons.add),
      ),
      body: OrientationBuilder(builder: (BuildContext context, Orientation orientation ){
        return appBody(orientation);
      }),
    );
  }

  String dersAdiKontrol(String input) {
    if (input.length < 3) {
      return "Ders adı en az 3 karakter olmalı";
    } else
      return null;
  }

  void dersAdiKayit(String input) {
    setState(() {
      if (dersHarfNotu == null || dersKredi == null) {
        Toast.show("Kredi veya ders Harf notunu boş", context);
      } else {
        if ((toplamKrediSayisi - dersKredi) >= 0) {
          dersAdi = input;
          tumDersler.add(Dersler(dersAdi, dersKredi, dersHarfNotu));
          ortalama = 0;
          toplamKrediSayisi = toplamKrediSayisi - dersKredi;
          ortalamaHesapla();
        } else {
          Toast.show(
              "toplam kredi sayısı 40'ı aşamaz kalan kredi sayisi: ${toplamKrediSayisi.toString()}",
              context);
        }
      }
    });
  }

  List<DropdownMenuItem<int>> dersKrediItems() {
    List<DropdownMenuItem<int>> dersKredileri = [];

    for (int i = 2; i <= 6; i = i + 2) {
      dersKredileri.add(
        DropdownMenuItem<int>(
          value: i,
          child: Text("${i} KREDİ"),
        ),
      );
    }
    return dersKredileri;
  }

  List<DropdownMenuItem<double>> dersHarfNotuItems() {
    List<DropdownMenuItem<double>> dersHarfNotlari = [];

    dersHarfNotlari.add(
      DropdownMenuItem<double>(child: Text("AA"), value: 4),
    );
    dersHarfNotlari.add(
      DropdownMenuItem<double>(child: Text("BA"), value: 3.5),
    );
    dersHarfNotlari.add(
      DropdownMenuItem<double>(child: Text("BB"), value: 3),
    );
    dersHarfNotlari.add(
      DropdownMenuItem<double>(child: Text("CB"), value: 2.5),
    );
    dersHarfNotlari.add(
      DropdownMenuItem<double>(child: Text("CC"), value: 2),
    );
    dersHarfNotlari.add(
      DropdownMenuItem<double>(child: Text("DC"), value: 1.5),
    );
    dersHarfNotlari.add(
      DropdownMenuItem<double>(child: Text("DD"), value: 1),
    );
    dersHarfNotlari.add(
      DropdownMenuItem<double>(child: Text("FD"), value: 0.5),
    );
    dersHarfNotlari.add(
      DropdownMenuItem<double>(child: Text("FF"), value: 0),
    );
    return dersHarfNotlari;
  }

  Widget listeElemanBuilder(BuildContext context, int index) {

    dissmisibleKey++;
    
    return Container(
      child: Column(
        children: <Widget>[
          Dismissible(
              key: Key(dissmisibleKey.toString()),
              direction: DismissDirection.horizontal,
              onDismissed: (direction){
                setState(() {
                  tumDersler.removeAt(index);
                  ortalamaHesapla();
                });
              },
              child: Card(
                child: ListTile(
                  title: Text(tumDersler[index].dersAdi),
                  subtitle:
                      Text(tumDersler[index].dersKredi.toString() + " kredi"),
                  trailing: Text(tumDersler[index].dersHarfNotu.toString()),
                ),
              )),
          Divider(
            color: Colors.black87,
            indent: 3,
            endIndent: 3,
            height: 5,
            thickness: 2,
          ),
        ],
      ),
    );
  }

  void ortalamaHesapla() {
    double geciciToplamNot = 0;
    double geciciToplamKredi = 0;
    double geciciKredi;
    double geciciNot;

    for (var ders in tumDersler) {
      geciciKredi = ders.dersKredi.toDouble();
      geciciNot = ders.dersHarfNotu;
      geciciToplamNot += (geciciNot * geciciKredi);
      geciciToplamKredi += geciciKredi;
    }

    ortalama = geciciToplamNot / geciciToplamKredi;
  }

  Widget appBody(Orientation orientation) {

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            //color: Colors.green.shade200,
            child: Form(
              key: key,
              child: orientation == Orientation.portrait ? Column(
                children: <Widget>[
                  TextFormField(
                    autofocus: false,
                    autocorrect: false,
                    //autovalidate: false,
                    onSaved: dersAdiKayit,
                    validator: dersAdiKontrol,
                    decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 2.0,
                        ),
                      ),
                      hintText: "Ders Adı Giriniz",
                      labelText: "Ders Adı",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            hint: Text("Ders Kredi"),
                            items: dersKrediItems(),
                            onChanged: (input) {
                              setState(() {
                                dersKredi = input;
                              });
                            },
                            value: dersKredi,
                          ),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                              style: BorderStyle.solid,
                              color: Colors.black,
                              width: 2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.all(4),
                      ),
                      Container(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<double>(
                            hint: Text("Harf Notu"),
                            items: dersHarfNotuItems(),
                            onChanged: (input) {
                              setState(() {
                                dersHarfNotu = input;
                              });
                            },
                            value: dersHarfNotu,
                          ),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                              style: BorderStyle.solid,
                              color: Colors.black,
                              width: 2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.all(4),
                        margin: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ],
                  ),
                  Container(
                    child: Center(
                      child: Text(
                          tumDersler.length==0
                              ? "DERS GİRİLMEMİŞTİR"
                              : "ORTALAMA ${ortalama.toStringAsFixed(2)}"),
                    ),
                  ),
                  Divider(
                    color: Colors.black87,
                    height: 10,
                    thickness: 2,
                    indent: 1,
                    endIndent: 1,
                  )
                ],
              ) : Text("data"),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              //color: Colors.red.shade200,
              child: ListView.builder(
                itemBuilder: listeElemanBuilder,
                itemCount: tumDersler.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Dersler {
  String dersAdi;
  int dersKredi;
  double dersHarfNotu;

  Dersler(this.dersAdi, this.dersKredi, this.dersHarfNotu);
}
