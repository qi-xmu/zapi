part of AddForm;

class AddButtonForm extends StatefulWidget {
  final ApiGroup group;
  final int? index;
  const AddButtonForm({Key? key, required this.group, this.index}) : super(key: key);

  @override
  State<AddButtonForm> createState() => _AddApiForm();
}

class _AddApiForm extends State<AddButtonForm> {
  final _formKey = GlobalKey<FormState>();
  bool isEdit = false;

  ApiWidgetInfo newAPI = ApiWidgetInfo(
    type: ApiWidgetType.BUTTON,
    apiInfo: APIInfo(),
  );
  @override
  initState() {
    if (widget.index != null) {
      isEdit = true;
    }
    super.initState();
  }

  ApiWidgetType newType = ApiWidgetType.BUTTON;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("添加按钮"),
      ),
      body: CardContainer(
        margin: const EdgeInsets.symmetric(vertical: verMargin, horizontal: horMargin * 2),
        padding: const EdgeInsets.symmetric(vertical: verPadding, horizontal: horPadding),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            SelectFormField(
              autofocus: true,
              initialValue: isEdit ? widget.group.widgetList[widget.index!].apiInfo.method.index.toString() : '0',
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
              initialValue: isEdit ? widget.group.widgetList[widget.index!].apiInfo.name : null,
              decoration: const InputDecoration(
                labelText: "组件名称",
              ),
              // onChanged: (val) {
              //   newAPI.apiInfo.name = val;
              // },
              onSaved: (val) => newAPI.apiInfo.name = val ?? '',
              validator: (v) => v!.trim().isEmpty ? "组件名称不能为空" : null,
            ),
            const Divider(),
            TextFormField(
              textInputAction: TextInputAction.next,
              initialValue: isEdit ? widget.group.widgetList[widget.index!].apiInfo.path.substring(1) : null,
              decoration: const InputDecoration(
                labelText: "请求路径",
                prefixText: '/',
              ),
              keyboardType: TextInputType.url,
              validator: (v) => v!.trim().isEmpty ? "请求路径不能为空" : null,
              onSaved: (val) => newAPI.apiInfo.path = '/${val ?? ''}',
            ),
            Row(children: [
              Expanded(
                  child: TextFormField(
                textInputAction: TextInputAction.next,
                initialValue: isEdit ? (widget.group.widgetList[widget.index!].response ?? [null])[0] : null,
                decoration: const InputDecoration(
                  labelText: "响应参数(可选)",
                ),
                onSaved: (val) => newAPI.response = [val],
                keyboardType: TextInputType.url,
              )),
              const Divider(),
              Expanded(
                  child: TextFormField(
                textInputAction: TextInputAction.next,
                initialValue: isEdit ? (widget.group.widgetList[widget.index!].responseAlias ?? [null])[0] : null,
                decoration: const InputDecoration(
                  labelText: "参数别名(可选)",
                ),
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
            print(newAPI);
            if (isEdit) {
              widget.group.widgetList[widget.index!] = newAPI;
              showSuccBlock('编辑成功');
            } else {
              widget.group.addApi(newAPI);
              showSuccBlock('添加成功');
            }
            updateGroup(widget.group);
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
