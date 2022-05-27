part of AddForm;

class AddSwitchForm extends StatefulWidget {
  final int gindex;
  final int? index;
  const AddSwitchForm({
    Key? key,
    required this.gindex,
    this.index,
  }) : super(key: key);

  @override
  State<AddSwitchForm> createState() => _AddSwitchForm();
}

class _AddSwitchForm extends State<AddSwitchForm> {
  final _formKey = GlobalKey<FormState>();
  late ApiGroup group;
  late ApiWidgetInfo info;

  bool isEdit = false;
  List<String> options = ["", ""];
  ApiWidgetInfo newAPI = ApiWidgetInfo(type: ApiWidgetType.SWITCH, apiInfo: APIInfo());

  @override
  initState() {
    group = context.read<GroupListModel>().getAt(widget.gindex);
    if (widget.index != null) {
      info = group.widgetList[widget.index!];
      options = info.options as List<String>;
      isEdit = true;
    }
    super.initState();
  }

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
                  initialValue: isEdit ? info.apiInfo.method.index.toString() : '0',
                  labelText: '请求方法',
                  items: httpMethods,
                  onChanged: (val) {
                    newAPI.apiInfo.method = HttpMethod.values[int.parse(val)];
                  },
                  validator: (v) => v!.trim().isEmpty ? "请求方法不能为空" : null,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  initialValue: isEdit ? info.apiInfo.name : null,
                  decoration: const InputDecoration(labelText: "组件名称"),
                  onSaved: (val) => newAPI.apiInfo.name = val ?? '',
                  validator: (v) => v!.trim().isEmpty ? "组件名称不能为空" : null,
                ),
                const Divider(),
                TextFormField(
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.next,
                  initialValue: isEdit ? info.apiInfo.path : null,
                  decoration: const InputDecoration(labelText: "请求路径"),
                  onSaved: (val) => newAPI.apiInfo.path = val ?? '',
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  initialValue: isEdit ? info.control : null,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.alternate_email),
                    labelText: "开关控制的参数",
                  ),
                  validator: (v) => v!.trim().isEmpty ? "不能为空" : null,
                  onSaved: (val) => newAPI.control = val,
                ),
                Row(children: [
                  Expanded(
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      initialValue: isEdit ? info.options[1] : null,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.clear, color: Colors.red),
                        labelText: "关闭时参数数值",
                      ),
                      onSaved: (val) => options[1] = val ?? '',
                      validator: (v) => v!.trim().isEmpty ? "不能为空" : null,
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      initialValue: isEdit ? info.options[0] : null,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.check, color: Colors.green),
                        labelText: "开启时参数数值",
                      ),
                      onSaved: (val) => options[0] = val ?? '',
                      validator: (v) => v!.trim().isEmpty ? "不能为空" : null,
                    ),
                  )
                ]),
                Row(children: [
                  Expanded(
                    child: TextFormField(
                        textInputAction: TextInputAction.next,
                        initialValue: isEdit ? info.response[0] : null,
                        decoration: const InputDecoration(labelText: "响应参数(可选)"),
                        onSaved: (val) => newAPI.response = [val],
                        keyboardType: TextInputType.url),
                  ),
                  Expanded(
                      child: TextFormField(
                    textInputAction: TextInputAction.next,
                    initialValue: isEdit ? info.responseAlias[0] : null,
                    decoration: const InputDecoration(labelText: "参数别名(可选)"),
                    onSaved: (val) => newAPI.responseAlias = [val],
                  ))
                ]),
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // save
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            newAPI.options = options;
            if (isEdit) {
              Provider.of<GroupListModel>(context, listen: false).modifyWidget(widget.gindex, widget.index!, newAPI);
              showSuccBlock('编辑成功');
            } else {
              Provider.of<GroupListModel>(context, listen: false).addWidget(widget.gindex, newAPI);
              showSuccBlock('添加成功');
            }
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
