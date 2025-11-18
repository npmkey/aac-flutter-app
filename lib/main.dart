import 'package:flutter/material.dart';
import 'aacscreen.dart';
import 'tilesscreen.dart';
import 'configs.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AAC App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Sans-serif',
      ),
      home: DefaultTabController(
        length: 3, 
        child: Scaffold(
          appBar: AppBar(
            title: const Text ("AAC app"),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Palavras'),
                
                Tab(text: 'Formar Frases'),

                Tab(text: 'configurações'),
              ],
            )
          ),
          body: const TabBarView(
            children: [
              AACScreen(),

              Tilesscreen(),

              Configs(),
            ],
          )
        ),
      ),
    );
  }
}
