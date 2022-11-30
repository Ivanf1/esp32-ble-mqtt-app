import 'dart:typed_data';

import 'package:esp32_ble_mqtt_app/main_screen/components/analog_reading_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;

class AnalogReadingCard extends StatefulWidget {
  final BluetoothService analogReadingService;

  const AnalogReadingCard({super.key, required this.analogReadingService});

  @override
  State<StatefulWidget> createState() => _AnalogReadingCardState();
}

class _AnalogReadingCardState extends State<AnalogReadingCard> {
  List<charts.Series<AnalogReadingTimeSeries, DateTime>> seriesList = [];
  List<AnalogReadingTimeSeries> analogReadingList = [];
  BluetoothCharacteristic? analogReadingCharacteristic;

  void _startNotification() async {
    await analogReadingCharacteristic!.setNotifyValue(true);
    analogReadingCharacteristic!.value.listen((value) {
      var v = ByteData.sublistView(Uint8List.fromList(value.reversed.toList()))
          .getUint32(0);
      setState(() {
        analogReadingList.add(AnalogReadingTimeSeries(v, DateTime.now()));
        seriesList = [
          charts.Series<AnalogReadingTimeSeries, DateTime>(
            id: 'Sales',
            colorFn: (_, __) => charts.ColorUtil.fromDartColor(
              const Color.fromARGB(255, 44, 90, 91),
            ),
            domainFn: (AnalogReadingTimeSeries reading, _) => reading.time,
            measureFn: (AnalogReadingTimeSeries reading, _) => reading.value,
            data: analogReadingList,
          )
        ];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    analogReadingCharacteristic =
        widget.analogReadingService.characteristics[0];
    seriesList = [
      charts.Series<AnalogReadingTimeSeries, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(
          const Color.fromARGB(255, 44, 90, 91),
        ),
        domainFn: (AnalogReadingTimeSeries reading, _) => reading.time,
        measureFn: (AnalogReadingTimeSeries reading, _) => reading.value,
        data: analogReadingList,
      )
    ];
    _startNotification();
  }

  @override
  Widget build(BuildContext context) {
    return (Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            children: const [
              Text(
                "Analog Reading",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 7, 68, 79),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 200,
          padding: const EdgeInsets.all(18.0),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            color: Color.fromARGB(255, 249, 249, 249),
          ),
          child: AnalogReadingChart(
            seriesList,
            animate: true,
          ),
        )
      ],
    ));
  }
}

class AnalogReadingTimeSeries {
  final int value;
  final DateTime time;

  AnalogReadingTimeSeries(this.value, this.time);
}
