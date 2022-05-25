import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zapi/components/APIGroup/data_model.dart';

import 'package:zapi/forms/add_api.dart';
import 'package:zapi/forms/add_group.dart';
import 'package:zapi/modals/mod.dart'; // 弹窗
import 'package:zapi/pages/group_page.dart';
import 'package:zapi/utils/standard.dart';
import 'test.dart';

void main() {
  group.addApis(apiList);

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
      drawer: const Drawer(child: const SafeArea(child: SizedBox())),
      body: Center(
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
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddGroupForm()));
        },
        tooltip: '添加API组',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
