import 'package:esp32_ble_mqtt_app/main_screen/components/analog_reading_card.dart';
import 'package:esp32_ble_mqtt_app/main_screen/components/device_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return (Column(
      children: [
        Expanded(
          child: Column(
            children: [
              const DeviceCard(),
              Container(
                margin: const EdgeInsets.only(top: 30.0),
                child: const AnalogReadingCard(),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text("Fai qualcosa"),
          ),
        )
      ],
    ));
  }
}
