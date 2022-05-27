part of AddForm;

class AddSlidingForm extends StatefulWidget {
  final int gindex;
  final int? index;
  const AddSlidingForm({
    Key? key,
    required this.gindex,
    this.index,
  }) : super(key: key);

  @override
  State<AddSlidingForm> createState() => _AddSlidingForm();
}

class _AddSlidingForm extends State<AddSlidingForm> {
  final _formKey = GlobalKey<FormState>();
  ApiWidgetInfo newAPI = ApiWidgetInfo(type: ApiWidgetType.SLIDING, apiInfo: APIInfo(), options: [0, 100]);
  List<num> options = [0, 1];

  bool isEdit = false;

  late ApiGroup group;
  late ApiWidgetInfo info;

  @override
  initState() {
    group = context.read<GroupListModel>().getAt(widget.gindex);
    if (widget.index != null) {
      info = group.widgetList[widget.index!];
      options[0] = info.options[0];
      options[1] = info.options[1];
      isEdit = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("添加滑动控制"),
      ),
      body: CardContainer(
        margin: const EdgeInsets.symmetric(vertical: verMargin, horizontal: horMargin * 2),
        padding: const EdgeInsets.symmetric(vertical: verPadding, horizontal: horPadding),
        child: Form(
          key: _formKey,
          child: ListView(children: [
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
                labelText: "滑动条控制的参数",
              ),
              onSaved: (val) => newAPI.control = val,
              validator: (v) => v!.trim().isEmpty ? "不能为空" : null,
            ),
            Row(children: [
              Expanded(
                child: TextFormField(
                    textInputAction: TextInputAction.next,
                    initialValue: isEdit ? info.options[0].toString() : null,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(11),
                    ],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.hdr_weak, color: Colors.lightGreen),
                      labelText: "最小值",
                    ),
                    onChanged: (val) => options[0] = int.tryParse(val) ?? 0, // on change 比较限制
                    validator: (v) {
                      return v!.trim().isEmpty ? "不能为空" : null;
                    }),
              ),
              const Divider(),
              Expanded(
                child: TextFormField(
                    textInputAction: TextInputAction.next,
                    initialValue: isEdit ? info.options[1].toString() : null,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(11),
                    ],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.hdr_strong, color: Colors.green),
                      labelText: "最大值",
                    ),
                    onChanged: (val) => options[1] = int.tryParse(val) ?? 1,
                    validator: (v) {
                      if (options[0] >= options[1]) return '不能小于最小值';
                      return v!.trim().isEmpty ? "不能为空" : null;
                    }),
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
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // save
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            if (isEdit) {
              newAPI.options = options;
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
