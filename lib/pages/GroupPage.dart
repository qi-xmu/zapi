import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:zapi/components/APIGroup/data_model.dart';
import 'package:zapi/components/APIWidget/mod.dart';
import 'package:zapi/forms/AddApi.dart';
import 'package:zapi/forms/AddGroup.dart';
import 'package:zapi/modals/mod.dart';
import 'package:zapi/standard.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../test.dart'; // 弹窗

class GroupList extends StatefulWidget {
  const GroupList({Key? key, required this.group}) : super(key: key);

  final ApiGroup group;
  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
      ),
      body: Center(
        child: ListView.builder(
            padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
            itemCount: widget.group.apiList.length,
            itemBuilder: (BuildContext context, int i) {
              return ApiWidget(info: widget.group.apiList[i]);
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddApiForm()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
