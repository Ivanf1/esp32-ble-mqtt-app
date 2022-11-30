import 'package:esp32_ble_mqtt_app/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(const MyApp());
}

Map<int, Color> color = {
  50: const Color.fromRGBO(44, 90, 91, 1),
  100: const Color.fromRGBO(44, 90, 91, 1),
  200: const Color.fromRGBO(44, 90, 91, 1),
  300: const Color.fromRGBO(44, 90, 91, 1),
  400: const Color.fromRGBO(44, 90, 91, 1),
  500: const Color.fromRGBO(44, 90, 91, 1),
  600: const Color.fromRGBO(44, 90, 91, 1),
  700: const Color.fromRGBO(44, 90, 91, 1),
  800: const Color.fromRGBO(44, 90, 91, 1),
  900: const Color.fromRGBO(44, 90, 91, 1),
};

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF2C5A5B, color),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final FlutterBlue flutterBlue = FlutterBlue.instance;

  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BluetoothDevice? connectedDevice;

  void setConnectedDevice(BluetoothDevice? deviceName) {
    setState(() {
      connectedDevice = deviceName;
    });
  }

  void _autoConnectToDevice(BluetoothDevice device) async {
    widget.flutterBlue.stopScan();

    try {
      await device.connect();
    } on PlatformException catch (e) {
      if (e.code != 'already_connected') {
        rethrow;
      }
    }

    setState(() {
      connectedDevice = device;
    });
  }

  void _scanAndSearchDevice() async {
    widget.flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        if (device.name.startsWith("ESP_GATTS_DEMO")) {
          _autoConnectToDevice(device);
        }
      }
    });

    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        if (result.device.name.startsWith("ESP_GATTS_DEMO")) {
          _autoConnectToDevice(result.device);
        }
      }
    });

    widget.flutterBlue.startScan();
  }

  @override
  void initState() {
    super.initState();
    _scanAndSearchDevice();
  }

  Widget _buildView() {
    if (connectedDevice != null) {
      return MainScreen(
        device: connectedDevice!,
      );
    } else {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 1.3,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: IconButton(
          // icon: const Icon( Icons.menu_rounded, color: Color.fromARGB(255, 44, 90, 91),),
          // icon: Image.asset("assets/images/Menu_Button.svg"),
          icon: SvgPicture.asset("assets/images/Menu_Button.svg"),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        child: _buildView(),
      ),
    );
  }
}
