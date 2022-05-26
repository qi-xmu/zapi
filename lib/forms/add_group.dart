import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:zapi/components/APIGroup/data_model.dart';
import 'package:zapi/components/DataStorage/mod.dart';
import 'package:zapi/modals/mod.dart';
import 'package:zapi/test.dart';
import 'package:zapi/utils/ext_widgets.dart';
import 'package:zapi/utils/standard.dart';
import 'package:zapi/utils/tools.dart';

class AddGroupForm extends StatefulWidget {
  const AddGroupForm({Key? key}) : super(key: key);

  @override
  State<AddGroupForm> createState() => _AddGroupForm();
}

class _AddGroupForm extends State<AddGroupForm> {
  var newGroup = ApiGroup(0, '', '');
  final _formKey = GlobalKey<FormState>();
  String prefix = "http://";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("添加API组"),
      ),
      body: CardContainer(
          margin: const EdgeInsets.symmetric(vertical: verMargin, horizontal: horMargin * 2),
          padding: const EdgeInsets.symmetric(vertical: verPadding, horizontal: horPadding),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SelectFormField(
                  initialValue: prefix,
                  labelText: '协议',
                  items: const [
                    {'label': 'HTTP', 'value': 'http://'},
                    {'label': 'HTTPS', 'value': 'https://'},
                  ],
                  onChanged: (val) => {setState(() => prefix = val)},
                  validator: (v) => v!.trim().isEmpty ? "请求方法不能为空" : null,
                ),
                TextFormField(
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: "API组名称",
                  ),
                  onChanged: (val) {
                    newGroup.name = val;
                  },
                  validator: (v) => v!.trim().isEmpty ? "API组名称不能为空" : null,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "URL",
                    prefixText: prefix,
                  ),
                  onChanged: (val) {
                    newGroup.url = prefix + val;
                  },
                  validator: (v) => v!.trim().isEmpty ? "URL不能为空" : null,
                ),
              ],
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // save
          if (_formKey.currentState!.validate()) {
            groupList.add(newGroup);
            prefs.setStringList(GroupListKey, getNameList(groupList));
            prefs.setString(newGroup.name, jsonEncode(newGroup)); // 存储
            showSuccBlock('添加成功');
            Navigator.pop(context);
          } else {
            showInfoBlock('添加失败');
          }
        },
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        child: const Icon(Icons.check),
      ),
    );
  }
}
