// Smart Home Dashboard — Flutter
// Single-file demo. Paste into lib/main.dart of a new Flutter project.

import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(SmartHomeApp());
}

class SmartHomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartHome Dashboard',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF05060A),
        primaryColor: Color(0xFF6EE7B7),
        textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Inter'),
      ),
      home: DashboardPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const int maxPoints = 30;
  final Random _rnd = Random();
  Timer? _timer;

  List<double> tempData = List<double>.filled(maxPoints, double.nan);
  List<double> humData = List<double>.filled(maxPoints, double.nan);
  List<String> labels = List<String>.filled(maxPoints, '');

  // Device states
  bool doorOpen = false;
  bool lightOn = false;

  DateTime? lastSync;

  @override
  void initState() {
    super.initState();
    // seed some data
    for (int i = 0; i < 10; i++) _generateSample();
    _timer = Timer.periodic(Duration(seconds: 5), (_) => _generateSample());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  double _randDouble(double min, double max) {
    return (min + _rnd.nextDouble() * (max - min));
  }

  void _generateSample() {
    final t = double.parse((_randDouble(22.0, 31.0)).toStringAsFixed(1));
    final h = double.parse((_randDouble(30.0, 78.0)).toStringAsFixed(0));

    setState(() {
      labels.add(_timeLabel());
      labels.removeAt(0);

      tempData.add(t);
      tempData.removeAt(0);

      humData.add(h);
      humData.removeAt(0);

      lastSync = DateTime.now();
    });
  }

  String _timeLabel() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}:${now.second.toString().padLeft(2,'0')}";
  }

  void _triggerFeeder() {
    // replace with real API call
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Perintah: Berikan makanan — terkirim (simulasi)')));
  }

  void _toggleDoor([bool? val]) {
    setState(() {
      doorOpen = val ?? !doorOpen;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pintu: ${doorOpen ? 'Terbuka' : 'Terkunci'}')));
  }

  void _toggleLight([bool? val]) {
    setState(() {
      lightOn = val ?? !lightOn;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lampu: ${lightOn ? 'Nyala' : 'Mati'}')));
  }

  Widget _buildSensorCard(IconData icon, String title, String value, String subtitle) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(colors: [Colors.white.withOpacity(0.02), Colors.white.withOpacity(0.01)]),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white.withOpacity(0.02)),
            child: Icon(icon, size: 24, color: Colors.white70),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.w700)),
              SizedBox(height: 6),
              Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: Colors.white60, fontSize: 12)),
            ]),
          )
        ],
      ),
    );
  }

  LineChartData _buildChartData() {
    final spotsTemp = <FlSpot>[];
    final spotsHum = <FlSpot>[];
    for (int i = 0; i < tempData.length; i++) {
      final t = tempData[i];
      final h = humData[i];
      if (!t.isNaN) spotsTemp.add(FlSpot(i.toDouble(), t));
      if (!h.isNaN) spotsHum.add(FlSpot(i.toDouble(), h));
    }

    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      lineTouchData: LineTouchData(enabled: true),
      minY: 10,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: spotsTemp,
          isCurved: true,
          barWidth: 2.2,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
          color: Color(0xFF6EE7B7),
        ),
        LineChartBarData(
          spots: spotsHum,
          isCurved: true,
          barWidth: 2.2,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
          color: Color(0xFF8B5CF6),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final tempVal = tempData.last.isNaN ? '--' : '${tempData.last.toStringAsFixed(1)} °C';
    final humVal = humData.last.isNaN ? '--' : '${humData.last.toStringAsFixed(0)} %';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Container(width:56,height:56,decoration:BoxDecoration(borderRadius:BorderRadius.circular(12),gradient:LinearGradient(colors:[Color(0xFF8B5CF6),Color(0xFF6EE7B7)])),child:Center(child:Text('SH',style:TextStyle(fontWeight:FontWeight.w800)))),
                    SizedBox(width:12),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('SmartHome — Dashboard', style: TextStyle(fontSize:18, fontWeight: FontWeight.w700)),
                      SizedBox(height:4),
                      Text('${DateTime.now().toLocal()}', style: TextStyle(color: Colors.white60, fontSize:12)),
                    ])
                  ]),
                  Row(children: [
                    ElevatedButton(onPressed: (){ _generateSample(); }, child: Text('Refresh')),
                    SizedBox(width:8),
                    ElevatedButton(onPressed: (){}, child: Text('Futuristic'))
                  ])
                ],
              ),

              SizedBox(height:18),

              // Content
              Expanded(
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Sidebar
                  Container(
                    width: 320,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), gradient: LinearGradient(colors: [Colors.white.withOpacity(0.02), Colors.white.withOpacity(0.01)]), border: Border.all(color: Colors.white.withOpacity(0.04))),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Ringkasan Sensor', style: TextStyle(fontWeight: FontWeight.w700)), SizedBox(height:4), Text('Update realtime (simulasi)', style: TextStyle(color: Colors.white60))]),
                              Text('Status: Online', style: TextStyle(color: Colors.white60))
                            ]),
                            SizedBox(height:12),
                            GridView.count(
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 1,
                              shrinkWrap: true,
                              mainAxisSpacing: 10,
                              childAspectRatio: 3.6,
                              children: [
                                _buildSensorCard(Icons.thermostat, 'Temperatur', tempVal, 'Sensor: DHT22'),
                                _buildSensorCard(Icons.water_drop, 'Kelembapan', humVal, 'Sensor: DHT22'),
                                _buildSensorCard(Icons.wb_sunny_outlined, 'Cahaya', '-- lx', 'Sensor: BH1750'),
                                _buildSensorCard(Icons.cloud, 'Air Quality', '-- AQI', 'Sensor: MQ-135'),
                              ],
                            )
                          ]),
                        ),

                        SizedBox(height:12),

                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), gradient: LinearGradient(colors: [Colors.white.withOpacity(0.02), Colors.white.withOpacity(0.01)]), border: Border.all(color: Colors.white.withOpacity(0.04))),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Perangkat', style: TextStyle(fontWeight: FontWeight.w700)),
                            SizedBox(height:6),
                            Text('Kontrol cepat', style: TextStyle(color: Colors.white60, fontSize:12)),
                            SizedBox(height:10),
                            // Feeder
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Pet Feeder', style: TextStyle(fontWeight: FontWeight.w600)), SizedBox(height:4), Text('Terjadwal & manual', style: TextStyle(color: Colors.white60, fontSize:12))]),
                              ElevatedButton(onPressed: _triggerFeeder, child: Text('Berikan'))
                            ]),
                            SizedBox(height:10),
                            // Door
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Pintu Otomatis', style: TextStyle(fontWeight: FontWeight.w600)), SizedBox(height:4), Text('Sensor gerak & RFID', style: TextStyle(color: Colors.white60, fontSize:12))]),
                              Row(children: [
                                Switch(value: doorOpen, onChanged: (v) => _toggleDoor(v)),
                                SizedBox(width:6),
                                Text(doorOpen ? 'Terbuka' : 'Terkunci')
                              ])
                            ]),
                            SizedBox(height:10),
                            // Light
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Lampu Ruang', style: TextStyle(fontWeight: FontWeight.w600)), SizedBox(height:4), Text('Intensitas dan mood', style: TextStyle(color: Colors.white60, fontSize:12))]),
                              Row(children: [
                                Switch(value: lightOn, onChanged: (v) => _toggleLight(v)),
                                SizedBox(width:6),
                                Text(lightOn ? 'Nyala' : 'Mati')
                              ])
                            ]),

                          ]),
                        ),

                      ],
                    ),
                  ),

                  SizedBox(width:18),

                  // Main area
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      Container(
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), gradient: LinearGradient(colors: [Colors.white.withOpacity(0.02), Colors.white.withOpacity(0.01)]), border: Border.all(color: Colors.white.withOpacity(0.04))),
                        height: 260,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Grafik — Temperatur & Kelembapan', style: TextStyle(fontWeight: FontWeight.w700)), SizedBox(height:4), Text('Perubahan waktu nyata (simulasi)', style: TextStyle(color: Colors.white60, fontSize:12))]),
                            Text('Range: 24 jam', style: TextStyle(color: Colors.white60))
                          ]),
                          SizedBox(height:12),
                          Expanded(
                            child: LineChart(
                              _buildChartData(),
                              swapAnimationDuration: Duration(milliseconds: 0),
                            ),
                          )
                        ]),
                      ),

                      SizedBox(height:12),

                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), gradient: LinearGradient(colors: [Colors.white.withOpacity(0.02), Colors.white.withOpacity(0.01)]), border: Border.all(color: Colors.white.withOpacity(0.04))),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Shortcut Cepat', style: TextStyle(fontWeight: FontWeight.w700)),
                          SizedBox(height:8),
                          Wrap(spacing: 12, runSpacing: 12, children: [
                            _shortcutButton('Feeder', Icons.ramen_dining, _triggerFeeder),
                            _shortcutButton('Pintu', Icons.door_front, () => _toggleDoor()),
                            _shortcutButton('Lampu', Icons.lightbulb, () => _toggleLight()),
                            _shortcutButton('Vakum', Icons.cleaning_services, () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Vakum: Mulai pembersihan (simulasi)')))),
                            _shortcutButton('Mode Malam', Icons.nights_stay, () { _toggleLight(false); _toggleDoor(false); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mode Malam: Diaktifkan (simulasi)'))); }),
                          ])
                        ]),
                      ),

                      SizedBox(height:12),

                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('© SmartHome • Elegan & Futuristik — Simulasi', style: TextStyle(color: Colors.white60)),
                        Text('Last sync: ${lastSync == null ? '-' : '${lastSync!.hour.toString().padLeft(2,'0')}:${lastSync!.minute.toString().padLeft(2,'0')}:${lastSync!.second.toString().padLeft(2,'0')}' }', style: TextStyle(color: Colors.white60))
                      ])

                    ]),
                  )
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _shortcutButton(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.03)), gradient: LinearGradient(colors: [Colors.white.withOpacity(0.01), Colors.white.withOpacity(0.02)])),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width:36,height:36,decoration:BoxDecoration(borderRadius:BorderRadius.circular(8), color: Colors.white.withOpacity(0.02)), child: Icon(icon, size:18)),
          SizedBox(height:8),
          Text(label, style: TextStyle(fontSize:13))
        ]),
      ),
    );
  }
}

/*
  PUBSPEC: add these dependencies to pubspec.yaml

  dependencies:
    flutter:
      sdk: flutter
    fl_chart: ^0.60.0

  NOTES:
  - This is a single-file demo that simulates sensor data. Replace the _generateSample() method
    with real network calls (HTTP/WebSocket/MQTT) to feed live data.
  - For device commands, call your backend API in _triggerFeeder(), _toggleDoor(), and _toggleLight().
  - To improve structure for a production app, separate state into providers or bloc.
*/
