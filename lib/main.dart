import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taboo/screens/home_screen.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await TabooService.loadDefaultCards();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Taboo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.purple),
      home: const HomeScreen(),
    );
  }
}
