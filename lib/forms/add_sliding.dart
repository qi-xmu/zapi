part of AddForm;

class AddSlidingForm extends StatefulWidget {
  final ApiGroup group;
  const AddSlidingForm({Key? key, required this.group}) : super(key: key);

  @override
  State<AddSlidingForm> createState() => _AddSlidingForm();
}

class _AddSlidingForm extends State<AddSlidingForm> {
  final _formKey = GlobalKey<FormState>();
  List<int> options = [0, 0];
  ApiWidgetInfo newAPI = ApiWidgetInfo(
    ApiWidgetType.SLIDING,
    APIInfo(0, "", HttpMethod.GET, "/"),
    options: [0, 100],
  );

  ApiWidgetType newType = ApiWidgetType.BUTTON;
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
              initialValue: '0',
              labelText: '请求方法',
              items: httpMethods,
              onChanged: (val) {
                int index = int.parse(val);
                newAPI.apiInfo.method = HttpMethod.values[index];
              },
              validator: (v) => v!.trim().isEmpty ? "请求方法不能为空" : null,
            ),
            TextFormField(
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: "组件名称",
              ),
              onChanged: (val) {
                newAPI.apiInfo.name = val;
              },
              validator: (v) => v!.trim().isEmpty ? "组件名称不能为空" : null,
            ),
            const Divider(),
            TextFormField(
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: "请求路径",
                prefixText: '/',
              ),
              validator: (v) => v!.trim().isEmpty ? "请求路径不能为空" : null,
              onChanged: (val) {
                newAPI.options = ["/$val"];
              },
            ),
            TextFormField(
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                icon: Icon(Icons.alternate_email),
                labelText: "滑动条控制的参数",
              ),
              validator: (v) => v!.trim().isEmpty ? "不能为空" : null,
              onChanged: (val) => newAPI.control = val,
            ),
            Row(children: [
              Expanded(
                child: TextFormField(
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(11),
                    ],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.hdr_weak, color: Colors.lightGreen),
                      labelText: "最小值",
                    ),
                    onChanged: (val) => options[0] = int.parse(val),
                    validator: (v) {
                      return v!.trim().isEmpty ? "不能为空" : null;
                    }),
              ),
              const Divider(),
              Expanded(
                child: TextFormField(
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(11),
                    ],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.hdr_strong, color: Colors.green),
                      labelText: "最大值",
                    ),
                    onChanged: (val) => options[1] = int.parse(val),
                    validator: (v) {
                      if (options[0] >= options[1]) {
                        return '不能小于最小值';
                      }
                      return v!.trim().isEmpty ? "不能为空" : null;
                    }),
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
              )),
              const Divider(),
              Expanded(
                  child: TextFormField(
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: "参数别名(可选)",
                ),
                onChanged: (val) => newAPI.responseAlias = [val],
              ))
            ]),
          ]),
        ),
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
