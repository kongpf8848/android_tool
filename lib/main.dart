import 'package:android_tool/page/main/main_page.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setWindowMinSize(const Size(800, 600));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AndroidADBTool',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}
