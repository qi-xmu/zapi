import 'package:flutter/material.dart';
import 'package:zapi/modals/mod.dart';

class AddGroupForm extends StatefulWidget {
  const AddGroupForm({Key? key}) : super(key: key);

  @override
  State<AddGroupForm> createState() => _AddGroupForm();
}

class _AddGroupForm extends State<AddGroupForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("添加API组"),
      ),
      body: Form(
        child: Text(""),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // save
          showSuccBlock('添加成功');
          Navigator.pop(context);
        },
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        child: const Icon(Icons.check),
      ),
    );
  }
}
