import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:zapi/components/APIGroup/data_model.dart';
import 'package:zapi/components/DataStorage/mod.dart';
import 'package:zapi/modals/mod.dart';

import 'package:zapi/utils/ext_widgets.dart';
import 'package:zapi/utils/standard.dart';

// ignore: must_be_immutable
class AddGroupForm extends StatefulWidget {
  ApiGroup? group; // 可变
  AddGroupForm({Key? key, this.group}) : super(key: key);

  @override
  State<AddGroupForm> createState() => _AddGroupForm();
}

class _AddGroupForm extends State<AddGroupForm> {
  var newGroup = ApiGroup(0, '', '');
  final _formKey = GlobalKey<FormState>();
  String prefix = "http://";
  bool isEdit = false;

  @override
  Widget build(BuildContext context) {
    if (widget.group != null) {
      isEdit = true; // 编辑选项
      newGroup = widget.group!;
    }
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
                  initialValue: isEdit ? widget.group?.name : null,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: "API组名称",
                  ),
                  onChanged: (val) {
                    newGroup.name = val;
                  },
                  onSaved: (val) {
                    newGroup.name = val ?? '';
                  },
                  validator: (v) => v!.trim().isEmpty ? "API组名称不能为空" : null,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  initialValue: isEdit ? widget.group?.url : null,
                  decoration: InputDecoration(
                    labelText: "URL",
                    prefixText: prefix,
                  ),
                  keyboardType: TextInputType.url,
                  onChanged: (val) {
                    newGroup.url = prefix + val;
                  },
                  validator: (v) => v!.trim().isEmpty ? "URL不能为空" : null,
                ),
              ],
            ),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // save
          if (_formKey.currentState!.validate()) {
            if (isEdit) {
              widget.group = newGroup;
              showSuccBlock('修改成功');
            } else {
              groupList.add(newGroup);
              showSuccBlock('添加成功');
            }
            updateGroupList(newGroup);
            Navigator.pop(context);
          } else {
            showInfoBlock('操作失败');
          }
        },
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        child: const Icon(Icons.check),
      ),
    );
  }
}
