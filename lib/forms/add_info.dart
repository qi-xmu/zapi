part of AddForm;

class AddInfoForm extends StatefulWidget {
  final ApiGroup group;
  const AddInfoForm({Key? key, required this.group}) : super(key: key);

  @override
  State<AddInfoForm> createState() => _AddInfoForm();
}

class _AddInfoForm extends State<AddInfoForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> response = ['', '', ''];
  List<String> alias = ['', '', ''];

  ApiWidgetInfo newAPI = ApiWidgetInfo(
    type: ApiWidgetType.INFO,
    apiInfo: APIInfo(),
  );

  ApiWidgetType newType = ApiWidgetType.BUTTON;
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
              onChanged: (val) => newAPI.apiInfo.path = "/$val",
            ),
            const Divider(),
            Row(children: [
              Expanded(
                  child: TextFormField(
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "响应参数1"),
                onChanged: (val) => response[0] = val,
              )),
              const Divider(),
              Expanded(
                  child: TextFormField(
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "参数别名1"),
                onChanged: (val) => alias[0] = val,
              ))
            ]),
            Row(children: [
              Expanded(
                  child: TextFormField(
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "响应参数2"),
                onChanged: (val) => response[1] = val,
              )),
              const Divider(),
              Expanded(
                  child: TextFormField(
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "参数别名2"),
                onChanged: (val) => alias[1] = val,
              ))
            ]),
            Row(children: [
              Expanded(
                  child: TextFormField(
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "响应参数3"),
                onChanged: (val) => response[2] = val,
              )),
              const Divider(),
              Expanded(
                  child: TextFormField(
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "参数别名3"),
                onChanged: (val) => alias[2] = val,
              ))
            ]),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // save
          if (_formKey.currentState!.validate()) {
            newAPI.response = response;
            newAPI.responseAlias = alias;
            widget.group.addApi(newAPI);
            // updateGroupList(widget.group); // 存储
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
