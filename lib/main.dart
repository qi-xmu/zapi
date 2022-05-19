import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:zapi/component/api_widget.dart';
import 'api.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   //Initialize Logging
//   await FlutterLogs.initLogs(
//       logLevelsEnabled: [LogLevel.INFO, LogLevel.WARNING, LogLevel.ERROR, LogLevel.SEVERE],
//       timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
//       directoryStructure: DirectoryStructure.FOR_DATE,
//       logTypesEnabled: ["device", "network", "errors"],
//       logFileExtension: LogFileExtension.LOG,
//       logsWriteDirectoryName: "MyLogs",
//       logsExportDirectoryName: "MyLogs/Exported",
//       debugFileOperations: true,
//       isDebuggable: true);

//   runApp(const MyApp());
// }
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZAPI',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'ZAPI'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() async {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });

    API test = API("http://api.xmu-maker.cn:2233");
    var res = await test.send(HttpMethod.GET, "/");
    log(res.toString());
    res = await test.send(HttpMethod.GET, "/temp");
    log(res.toString());
  }

  ApiGroup group = ApiGroup("http://api.xmu-maker.cn:2233");

  List<APIInfo> apiList = [
    APIInfo(1, "按键", HttpMethod.GET, ""),
    APIInfo(2, "信息", HttpMethod.GET, "/temp"),
    APIInfo(3, "滑动", HttpMethod.GET, "/"),
    APIInfo(4, "开关", HttpMethod.GET, "/"),
  ];
  late List<ApiWidgetInfo> infoList = [
    ApiWidgetInfo(ApiWidgetType.BUTTON, group, apiList[0], controlParam: "", options: ["/0", "/1"]),
    ApiWidgetInfo(ApiWidgetType.INFO, group, apiList[1], controlParam: "state", options: ["info"]),
    ApiWidgetInfo(ApiWidgetType.SLIDING, group, apiList[2], controlParam: "state", options: [0.1, 1]),
    ApiWidgetInfo(ApiWidgetType.SWITCH, group, apiList[3], controlParam: "state", options: ["off", "on"]),
  ];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: ListView.builder(
            itemCount: infoList.length,
            itemBuilder: (BuildContext context, int i) {
              return ApiWidget(info: infoList[i]);
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
