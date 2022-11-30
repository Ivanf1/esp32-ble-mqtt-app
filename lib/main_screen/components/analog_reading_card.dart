import 'package:esp32_ble_mqtt_app/main_screen/components/analog_reading_chart.dart';
import 'package:flutter/cupertino.dart';

import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;

class AnalogReadingCard extends StatelessWidget {
  const AnalogReadingCard({super.key});

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
          child: AnalogReadingChart.withSampleData(),
        )
      ],
    ));
  }
}
