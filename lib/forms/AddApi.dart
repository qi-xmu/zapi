import 'package:flutter/material.dart';
import 'package:zapi/modals/mod.dart';

class AddApiForm extends StatefulWidget {
  const AddApiForm({Key? key}) : super(key: key);

  @override
  State<AddApiForm> createState() => _AddApiForm();
}

class _AddApiForm extends State<AddApiForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("添加API"),
      ),
      body: const Form(
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
