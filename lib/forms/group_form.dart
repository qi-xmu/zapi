import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:zapi/components/APIGroup/data_model.dart';
import 'package:zapi/components/DataStorage/mod.dart';
import 'package:zapi/modals/mod.dart';

import 'package:zapi/utils/ext_widgets.dart';
import 'package:zapi/utils/standard.dart';

class AddGroupForm extends StatefulWidget {
  final int? index;
  const AddGroupForm({Key? key, this.index}) : super(key: key);

  @override
  State<AddGroupForm> createState() => _AddGroupForm();
}

class _AddGroupForm extends State<AddGroupForm> {
  var newGroup = ApiGroup();
  final _formKey = GlobalKey<FormState>();
  String prefix = 0.toString();
  bool isEdit = false;
  late List<ApiGroup> groups;
  late ApiGroup group;

  @override
  void initState() {
    groups = Provider.of<GroupListModel>(context, listen: false).list;
    if (widget.index != null) {
      group = groups[widget.index!];
      prefix = group.proto.index.toString();
      isEdit = true; // 编辑选项
      newGroup = group;
    }
    super.initState();
  }

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
                    {'label': 'HTTP', 'value': '0'},
                    {'label': 'HTTPS', 'value': '1'},
                  ],
                  onChanged: (val) => {setState(() => prefix = val)},
                  onSaved: (val) => {newGroup.proto = Protocol.values[int.parse(val ?? "0")]},
                  validator: (v) => v!.trim().isEmpty ? "请求方法不能为空" : null,
                ),
                TextFormField(
                  autofocus: true,
                  initialValue: isEdit ? group.name : null,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: "API组名称",
                  ),
                  onSaved: (val) => newGroup.name = val ?? '',
                  validator: (v) => v!.trim().isEmpty ? "API组名称不能为空" : null,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  initialValue: isEdit ? group.url : null,
                  decoration: InputDecoration(
                    labelText: "URL",
                    prefixText: ProtoStr[int.parse(prefix)],
                  ),
                  keyboardType: TextInputType.url,
                  onSaved: (val) => newGroup.url = val ?? '',
                  validator: (v) => v!.trim().isEmpty ? "URL不能为空" : null,
                ),
              ],
            ),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // save
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            if (isEdit) {
              Provider.of<GroupListModel>(context, listen: false).modify(newGroup, widget.index!);
              showSuccBlock('修改成功');
            } else {
              Provider.of<GroupListModel>(context, listen: false).add(newGroup);
              showSuccBlock('添加成功');
            }
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
