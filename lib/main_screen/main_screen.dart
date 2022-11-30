import 'package:esp32_ble_mqtt_app/bluetooth_uuid/bluetooth_uuid.dart';
import 'package:esp32_ble_mqtt_app/main_screen/components/analog_reading_card.dart';
import 'package:esp32_ble_mqtt_app/main_screen/components/device_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class MainScreen extends StatefulWidget {
  final BluetoothDevice device;

  const MainScreen({super.key, required this.device});

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<Widget>> _discoverServicesAndCharacteristics() async {
    final List<BluetoothService> services =
        await widget.device.discoverServices();
    final Map<String, BluetoothService> serviceNameToService =
        <String, BluetoothService>{};

    for (BluetoothService service in services) {
      serviceNameToService[bluetoothUUIDToString(service.uuid.toString())] =
          service;
    }

    List<Widget> mainPageWidgets = [
      Expanded(
        child: Column(
          children: [
            DeviceCard(
              deviceName: widget.device.name,
              bluetoothDeviceInfoService:
                  serviceNameToService["Device Information"]!,
            ),
            Container(
              margin: const EdgeInsets.only(top: 30.0),
              child: AnalogReadingCard(
                analogReadingService: serviceNameToService["Analog Service"]!,
              ),
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
    ];

    return Future.value(mainPageWidgets);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Widget>>(
      future: _discoverServicesAndCharacteristics(),
      builder: ((context, snapshot) {
        if (!snapshot.hasData) {
          return Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.3,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            ],
          );
        } else {
          return Column(
            children: snapshot.data!,
          );
        }
      }),
    );
  }
}
