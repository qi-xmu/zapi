part of AddForm;

class AddSwitchForm extends StatefulWidget {
  final ApiGroup group;
  const AddSwitchForm({Key? key, required this.group}) : super(key: key);

  @override
  State<AddSwitchForm> createState() => _AddSwitchForm();
}

class _AddSwitchForm extends State<AddSwitchForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> options = ["", ""];

  ApiWidgetInfo newAPI = ApiWidgetInfo(
    ApiWidgetType.SWITCH,
    APIInfo(0, "", HttpMethod.GET, "/"),
  );

  ApiWidgetType newType = ApiWidgetType.BUTTON;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("添加开关"),
      ),
      body: CardContainer(
        margin: const EdgeInsets.symmetric(vertical: verMargin, horizontal: horMargin * 2),
        padding: const EdgeInsets.symmetric(vertical: verPadding, horizontal: horPadding),
        child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SelectFormField(
                  autofocus: true,
                  initialValue: '0',
                  labelText: '请求方法',
                  items: httpMethods,
                  onChanged: (val) {
                    int index = int.parse(val);
                    newAPI.apiInfo.method = HttpMethod.values[index];
                  },
                  validator: (v) => v!.trim().isEmpty ? "请求方法不能为空" : null,
                ),
                // button
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: "开关名称",
                  ),
                  onChanged: (val) => newAPI.apiInfo.name = val,
                  validator: (v) => v!.trim().isEmpty ? "开关名称不能为空" : null,
                ),
                const Divider(),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: "请求路径",
                    prefixText: '/',
                  ),
                  validator: (v) => v!.trim().isEmpty ? "请求路径不能为空" : null,
                  onChanged: (val) => newAPI.options = ["/$val"],
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.alternate_email),
                    labelText: "开关控制的参数",
                  ),
                  validator: (v) => v!.trim().isEmpty ? "不能为空" : null,
                  onChanged: (val) => newAPI.control = val,
                ),
                Row(children: [
                  Expanded(
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.clear, color: Colors.red),
                        labelText: "关闭时参数数值",
                      ),
                      onChanged: (val) => options[1] = val,
                      validator: (v) => v!.trim().isEmpty ? "不能为空" : null,
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.check, color: Colors.green),
                        labelText: "开启时参数数值",
                      ),
                      onChanged: (val) => options[0] = val,
                      validator: (v) => v!.trim().isEmpty ? "不能为空" : null,
                    ),
                  )
                ]),
                Row(children: [
                  Expanded(
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: "响应参数(可选)",
                      ),
                      onChanged: (val) => newAPI.response = [val],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: "参数别名(可选)",
                      ),
                      onChanged: (val) => newAPI.responseAlias = [val],
                    ),
                  )
                ]),
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // save
          if (_formKey.currentState!.validate()) {
            newAPI.options = options;
            widget.group.addApi(newAPI);
            prefs.setString(widget.group.name, jsonEncode(widget.group)); // 存储
            showSuccBlock('添加成功');
            Navigator.pop(context);
          }
        },
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        child: const Icon(Icons.check),
      ),
    );
  }
}
