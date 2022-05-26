/// 数据组的界面。
///
import 'package:flutter/material.dart';
import 'package:zapi/components/APIGroup/data_model.dart';
import 'package:zapi/components/APIWidget/mod.dart';
import 'package:zapi/forms/add_api.dart';

import 'package:zapi/utils/standard.dart';

class GroupList extends StatefulWidget {
  const GroupList({Key? key, required this.group}) : super(key: key);

  final ApiGroup group;
  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    for (var element in widget.group.widgetList) {
      widgetList.add(ApiWidget(info: element));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
      ),
      body: SingleChildScrollView(
          // padding: const EdgeInsets.symmetric(vertical: verMargin, horizontal: horMargin),
          padding: const EdgeInsets.only(top: topPadding, bottom: boxSize, left: verMargin, right: verMargin),
          child: Wrap(
            runSpacing: 10, // vertical
            spacing: 10, // horizontal
            children: widgetList,
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddApiForm(group: widget.group)))
              .then((value) => {setState(() {})});
        },
        tooltip: '添加API',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
