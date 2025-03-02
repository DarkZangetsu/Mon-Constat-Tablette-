import 'dart:io';
import 'package:constat/screens/welcom_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestAppPermissions();

  runApp(const MyApp());
}

Future<void> requestAppPermissions() async {
  if (Platform.isAndroid) {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;

    // Android 13+ (API 33+)
    if (androidInfo.version.sdkInt >= 33) {
      await [
        Permission.camera,
        Permission.microphone,
        Permission.photos,
        Permission.audio,
        Permission.videos,
      ].request();
    } else {
      await [
        Permission.camera,
        Permission.microphone,
        Permission.storage,
      ].request();
    }
  } else if (Platform.isIOS) {
    // Pour iOS
    await [
      Permission.camera,
      Permission.microphone,
      Permission.photos,
    ].request();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mon constat tablette',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WelcomeScreen(),
    );
  }
}