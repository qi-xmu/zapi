part of AddForm;

class AddButtonForm extends StatefulWidget {
  final ApiGroup group;
  const AddButtonForm({Key? key, required this.group}) : super(key: key);

  @override
  State<AddButtonForm> createState() => _AddApiForm();
}

class _AddApiForm extends State<AddButtonForm> {
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
              keyboardType: TextInputType.url,
              validator: (v) => v!.trim().isEmpty ? "请求路径不能为空" : null,
              onChanged: (val) => newAPI.apiInfo.path = "/$val",
            ),
            Row(children: [
              Expanded(
                  child: TextFormField(
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: "响应参数(可选)",
                ),
                onChanged: (val) => newAPI.response = [val],
                keyboardType: TextInputType.url,
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

Widget getTypeWidget() {
  return Text("");
}
