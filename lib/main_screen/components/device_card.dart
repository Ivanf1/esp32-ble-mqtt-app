import 'package:esp32_ble_mqtt_app/bluetooth_uuid/bluetooth_uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DeviceCard extends StatefulWidget {
  final String deviceName;
  final BluetoothService bluetoothDeviceInfoService;

  const DeviceCard(
      {super.key,
      required this.deviceName,
      required this.bluetoothDeviceInfoService});

  @override
  State<StatefulWidget> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  Map<String, String> characteristicNameAndValue = <String, String>{};

  @override
  void initState() {
    super.initState();
    _getCharacteristicValues();
  }

  void _getCharacteristicValues() async {
    for (BluetoothCharacteristic characteristic
        in widget.bluetoothDeviceInfoService.characteristics) {
      List<int> value = await characteristic.read();
      List<int> filteredList = value.where((element) => element != 0).toList();
      setState(() {
        characteristicNameAndValue[
                bluetoothUUIDToString(characteristic.uuid.toString())] =
            String.fromCharCodes(filteredList);
      });
    }
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
                "Device",
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
          padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20.0),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromARGB(255, 44, 90, 91),
                Color.fromARGB(220, 62, 121, 118),
              ],
            ),
          ),
          child: SizedBox(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        widget.deviceName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5.0),
                      child: const Text(
                        "DevKitC",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5.0),
                      child: DeviceInfoText(
                        fieldName: "Firmware",
                        fieldValue: characteristicNameAndValue
                                .containsKey("Firmware Revision String")
                            ? characteristicNameAndValue[
                                "Firmware Revision String"]!
                            : "",
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5.0),
                      child: DeviceInfoText(
                        fieldName: "Hardware",
                        fieldValue: characteristicNameAndValue
                                .containsKey("Hardware Revision String")
                            ? characteristicNameAndValue[
                                "Hardware Revision String"]!
                            : "",
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5.0),
                      child: DeviceInfoText(
                        fieldName: "Software",
                        fieldValue: characteristicNameAndValue
                                .containsKey("Software Revision String")
                            ? characteristicNameAndValue[
                                "Software Revision String"]!
                            : "",
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30.0),
                  child: Image.asset(
                    "assets/images/ESP32_38Pines_ESPWROOM32.png",
                    width: 120,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}

class DeviceInfoText extends StatelessWidget {
  final String fieldName;
  final String fieldValue;

  const DeviceInfoText(
      {super.key, required this.fieldName, required this.fieldValue});

  @override
  Widget build(BuildContext context) {
    return (Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "$fieldName: ",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          fieldValue,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    ));
  }
}
