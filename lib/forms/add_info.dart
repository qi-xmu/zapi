part of AddForm;

class AddInfoForm extends StatefulWidget {
  final int gindex;
  final int? index;
  const AddInfoForm({Key? key, required this.gindex, this.index}) : super(key: key);

  @override
  State<AddInfoForm> createState() => _AddInfoForm();
}

class _AddInfoForm extends State<AddInfoForm> {
  final _formKey = GlobalKey<FormState>();

  ApiWidgetInfo newAPI = ApiWidgetInfo(type: ApiWidgetType.INFO, apiInfo: APIInfo());
  List<String> response = ['', '', ''];
  List<String> alias = ['', '', ''];
  bool isEdit = false;

  late ApiGroup group;
  late ApiWidgetInfo info;

  @override
  void initState() {
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
      appBar: AppBar(
        title: const Text("添加信息展示"),
      ),
      body: CardContainer(
        margin: const EdgeInsets.symmetric(vertical: verMargin, horizontal: horMargin * 2),
        padding: const EdgeInsets.symmetric(vertical: verPadding, horizontal: horPadding),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            SelectFormField(
              icon: const Icon(Icons.http),
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
            const Divider(),
            Row(children: [
              Expanded(
                  child: TextFormField(
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.next,
                initialValue: isEdit ? info.response[0] : null,
                decoration: const InputDecoration(labelText: "响应参数1"),
                onSaved: (val) => response[0] = val ?? '',
              )),
              Expanded(
                  child: TextFormField(
                textInputAction: TextInputAction.next,
                initialValue: isEdit ? info.responseAlias[0] : null,
                decoration: const InputDecoration(labelText: "参数别名1"),
                onSaved: (val) => alias[0] = val ?? '',
              ))
            ]),
            Row(children: [
              Expanded(
                  child: TextFormField(
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.next,
                initialValue: isEdit ? info.response[1] : null,
                decoration: const InputDecoration(labelText: "响应参数2"),
                onSaved: (val) => response[1] = val ?? '',
              )),
              Expanded(
                  child: TextFormField(
                textInputAction: TextInputAction.next,
                initialValue: isEdit ? info.responseAlias[1] : null,
                decoration: const InputDecoration(labelText: "参数别名2"),
                onSaved: (val) => alias[1] = val ?? '',
              ))
            ]),
            Row(children: [
              Expanded(
                  child: TextFormField(
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.next,
                initialValue: isEdit ? info.response[2] : null,
                decoration: const InputDecoration(labelText: "响应参数3"),
                onSaved: (val) => response[2] = val ?? '',
              )),
              Expanded(
                  child: TextFormField(
                textInputAction: TextInputAction.next,
                initialValue: isEdit ? info.responseAlias[2] : null,
                decoration: const InputDecoration(labelText: "参数别名3"),
                onSaved: (val) => alias[2] = val ?? '',
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
            newAPI.response = response;
            newAPI.responseAlias = alias;
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
