import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:zapi/components/APIGroup/data_model.dart';
import 'package:zapi/components/DataStorage/mod.dart';

import 'package:zapi/forms/group_form.dart';
import 'package:zapi/pages/group_page.dart';

import 'package:zapi/utils/ext_widgets.dart';
import 'package:zapi/utils/standard.dart';
import 'components/Menu/mod.dart';

import 'package:zapi/test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initPrefs(); // 初始化存储实例
  /// TESTING
  prefs.clear();

  testGroup.addApis(apiList); // 测试代码
  await prefs.setString(testGroup.id.toString(), jsonEncode(testGroup));
  await prefs.setStringList(GroupListKey, [testGroup.id.toString()]);
  print(prefs.getKeys());

  ///TESING end

  // 加载group列表 groupList

  // test;
  // groupList.add(testGroup);

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
    return ChangeNotifierProvider<GroupListModel>(
      create: (_) => GroupListModel(),
      lazy: false,
      child: MaterialApp(
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
      ),
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
        child: Consumer<GroupListModel>(
          builder: (ctx, glm, child) => ListView.builder(
              padding: const EdgeInsets.only(top: topPadding, bottom: bottomPadding),
              itemCount: glm.len,
              itemBuilder: (BuildContext context, int i) {
                ApiGroup group = glm.getAt(i);
                return ListTile(
                  title: Text(group.name),
                  subtitle: Text(group.realUrl),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => GroupList(gindex: i)),
                    );
                  },
                  onLongPress: () async {
                    await showGroupMenu(context, i);
                  }, // 菜单
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddGroupForm()))
              .then((value) => setState(() {}));
        },
        tooltip: '添加API组',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
