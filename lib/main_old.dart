import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  String appGroupId = "group.homeScreenApp";
  String androidWidgetName = "MyHomeWidget";
  String dataKey = "text_from_flutter_app";

  @override
  void initState() {
    super.initState();

    HomeWidget.setAppGroupId(appGroupId);
  }

  Future<void> increse() async {
    setState(() {
      _counter++;
    });

    String data = "Count = ${_counter}";
    data = "Treenix?";
    await HomeWidget.saveWidgetData(dataKey, data);

    await HomeWidget.updateWidget(androidName: androidWidgetName);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                _counter.toString(),
                style: TextStyle(fontSize: 30),
              ),
              ElevatedButton(
                  onPressed: () {
                    increse();
                  },
                  child: Text(
                    "+",
                    style: TextStyle(fontSize: 30),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
