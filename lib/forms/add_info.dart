part of AddForm;

class AddInfoForm extends StatefulWidget {
  final ApiGroup group;
  const AddInfoForm({Key? key, required this.group}) : super(key: key);

  @override
  State<AddInfoForm> createState() => _AddInfoForm();
}

class _AddInfoForm extends State<AddInfoForm> {
  final _formKey = GlobalKey<FormState>();

  ApiWidgetInfo newAPI = ApiWidgetInfo(
    ApiWidgetType.BUTTON,
    APIInfo(0, "", HttpMethod.GET, "/"),
  );

  ApiWidgetType newType = ApiWidgetType.BUTTON;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("添加API"),
      ),
      body: CardContainer(
        margin: const EdgeInsets.symmetric(vertical: verMargin, horizontal: horMargin * 2),
        padding: const EdgeInsets.symmetric(vertical: verPadding, horizontal: horPadding),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                SelectFormField(
                  autofocus: true,
                  icon: const Icon(Icons.http),
                  initialValue: '0',
                  labelText: '请求方法',
                  items: httpMethods,
                  onChanged: (val) {
                    int index = int.parse(val);
                    newAPI.apiInfo.method = HttpMethod.values[index];
                  },
                  validator: (v) => v!.trim().isEmpty ? "请求方法不能为空" : null,
                  onSaved: (val) {},
                ),
                SelectFormField(
                  initialValue: '0',
                  icon: const Icon(Icons.toys),
                  labelText: '组件类型',
                  items: apiWidgetType,
                  onChanged: (val) {
                    int index = int.parse(val);
                    newAPI.type = ApiWidgetType.values[index];
                  },
                  validator: (v) => v!.trim().isEmpty ? "组件类型不能为空" : null,
                  onSaved: (val) => print(val),
                ),
                // button
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
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: "响应参数(可选)",
                        ),
                        onChanged: (val) {
                          newAPI.response = [val];
                        },
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: "参数别名(可选)",
                        ),
                        onChanged: (val) {
                          newAPI.responseAlias = [val];
                        },
                      ),
                    )
                  ],
                ),
              ],
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // save
          if (_formKey.currentState!.validate()) {
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
