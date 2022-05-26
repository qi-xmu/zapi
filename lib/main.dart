import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zapi/components/APIGroup/data_model.dart';
import 'package:zapi/components/DataStorage/mod.dart';

import 'package:zapi/forms/add_group.dart';
import 'package:zapi/pages/group_page.dart';
import 'package:zapi/utils/ext_widgets.dart';
import 'package:zapi/utils/standard.dart';
import 'test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initPrefs(); // 初始化存储实例
  /// TESTING
  group.addApis(apiList);
  await prefs.setString(group.name, jsonEncode(group));

  await prefs.setStringList('groupNameList', [group.name]);

  // 加载group列表 groupList
  List<String>? groupNameList = prefs.getStringList('groupNameList');
  for (String group in groupNameList!) {
    String? groupStr = prefs.getString(group);
    if (groupStr == null) continue;
    try {
      var test = jsonDecode(groupStr);
      groupList.add(ApiGroup.fromJson(test));
    } catch (e) {
      prefs.remove(group);
      print("error");
    }
  }

  // groupList.add(group);
  // String json = jsonEncode(group);
  // print(json);
  // var maps = jsonDecode(json);
  // for (var map in maps) {
  //   log(map.toString());
  // }
  // apiList[0] = ApiWidgetInfo.fromJson();

  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 1200)
    ..indicatorType = EasyLoadingIndicatorType.pulse
    ..loadingStyle = EasyLoadingStyle.light
    ..radius = 5.0;
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
        brightness: Brightness.light,
        primarySwatch: createMaterialColor(lightColor),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: createMaterialColor(Colors.white70),
      ),
      home: const MyHomePage(title: 'ZAPI'),
      builder: EasyLoading.init(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.title} API组")),
      drawer: const Drawer(child: SafeArea(child: SizedBox())),
      body: CardContainer(
        margin: const EdgeInsets.symmetric(horizontal: horMargin * 2, vertical: verMargin),
        child: ListView.builder(
            padding: const EdgeInsets.only(top: topPadding, bottom: bottomPadding),
            itemCount: groupList.length,
            itemBuilder: (BuildContext context, int i) {
              ApiGroup group = groupList[i];
              return ListTile(
                title: Text(group.name),
                subtitle: Text(group.url),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupList(group: group)));
                },
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddGroupForm()));
        },
        tooltip: '添加API组',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
