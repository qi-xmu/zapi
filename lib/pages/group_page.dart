/// 数据组的界面。
///
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:zapi/components/APIGroup/data_model.dart';
import 'package:zapi/components/APIWidget/mod.dart';

import 'package:zapi/utils/standard.dart';

import '../forms/mod.dart';

class GroupList extends StatefulWidget {
  const GroupList({Key? key, required this.group}) : super(key: key);

  final ApiGroup group;
  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = []; // DOING

    for (var awi in widget.group.widgetList) {
      widgetList.add(ApiWidget(info: awi));
    }
    return Scaffold(
      appBar: AppBar(title: Text(widget.group.name)),
      body: SingleChildScrollView(
          // padding: const EdgeInsets.symmetric(vertical: verMargin, horizontal: horMargin),
          padding: const EdgeInsets.only(top: topPadding, bottom: boxSize, left: verMargin, right: verMargin),
          child: Wrap(
            runSpacing: 10, // vertical
            spacing: 10, // horizontal
            children: widgetList,
          )),
      floatingActionButton: SpeedDial(
        children: [
          SpeedDialChild(
            child: const Icon(Icons.looks_one),
            backgroundColor: Colors.red,
            label: '添加按钮',
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AddButtonForm(group: widget.group)))
                  .then((value) => {setState(() {})});
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.looks_two),
            backgroundColor: Colors.orange,
            label: '添加开关',
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AddSwitchForm(group: widget.group)))
                  .then((value) => {setState(() {})});
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.looks_3),
            backgroundColor: Colors.green,
            label: '添加滑动条',
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AddSlidingForm(group: widget.group)))
                  .then((value) => {setState(() {})});
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.looks_4),
            backgroundColor: Colors.blue,
            label: '添加信息展示',
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AddInfoForm(group: widget.group)))
                  .then((value) => {setState(() {})});
            },
          ),
        ],
        spaceBetweenChildren: 15,
        child: const Icon(Icons.add),
      ),
    );
  }
}
