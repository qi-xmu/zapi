part of AddForm;

class AddButtonForm extends StatefulWidget {
  final int gindex;
  final int? index;
  const AddButtonForm({Key? key, required this.gindex, this.index}) : super(key: key);

  @override
  State<AddButtonForm> createState() => _AddApiForm();
}

class _AddApiForm extends State<AddButtonForm> {
  final _formKey = GlobalKey<FormState>();
  ApiWidgetInfo newAPI = ApiWidgetInfo(type: ApiWidgetType.BUTTON, apiInfo: APIInfo());
  bool isEdit = false;
  late ApiGroup group;
  late ApiWidgetInfo info;

  @override
  initState() {
    // group = widget.group;
    // group = Provider.of<GroupModel>(context, listen: false).group;

    group = context.read<GroupListModel>().getAt(widget.gindex);
    if (widget.index != null) {
      info = group.widgetList[widget.index!];
      isEdit = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("添加按钮")),
      body: CardContainer(
        margin: const EdgeInsets.symmetric(vertical: verMargin, horizontal: horMargin * 2),
        padding: const EdgeInsets.symmetric(vertical: verPadding, horizontal: horPadding),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            SelectFormField(
              initialValue: isEdit ? info.apiInfo.method.index.toString() : '0',
              labelText: '请求方法',
              items: httpMethods,
              onSaved: (val) {
                if (val == null) newAPI.apiInfo.method = info.apiInfo.method;
                newAPI.apiInfo.method = HttpMethod.values[int.parse(val ?? '0')];
              },
              validator: (v) => v!.trim().isEmpty ? "请求方法不能为空" : null,
            ),
            // button
            TextFormField(
              autofocus: true,
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
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // save
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
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

Widget getTypeWidget() {
  return Text("");
}
