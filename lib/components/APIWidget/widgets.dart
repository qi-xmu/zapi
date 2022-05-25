part of api_widget;

/// 提供组件支持
///
///

/// 组件路由；
class ApiWidget extends StatelessWidget {
  final ApiWidgetInfo info;
  const ApiWidget({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (info.type) {
      case ApiWidgetType.BUTTON:
        return ButtonWidget(info: info);
      case ApiWidgetType.INFO:
        return InfoWidget(info: info);
      case ApiWidgetType.SLIDING:
        return SlidingWidget(info: info);
      case ApiWidgetType.SWITCH:
        return SwitchWidget(info: info);
      // TODO switch 这里可以新增类型；
      default:
        return const Text("Null");
    }
  }
}

// DOING 修改样式 定义一个组件的Container
/// 这里可以声明所有组件的容器样式
Widget widgetContainer(BuildContext context, Widget widget) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: verMargin, horizontal: horMargin),
    padding: const EdgeInsets.symmetric(vertical: verPadding, horizontal: horPadding),
    decoration: BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(color: lightColor.withOpacity(0.1), blurRadius: 1, spreadRadius: 2),
      ],
    ),
    constraints: const BoxConstraints(minHeight: minHeight),
    child: widget,
  );
}

/// TODO 各个组件的样式修改。
/// 按键的组件
class ButtonWidget extends StatefulWidget {
  final ApiWidgetInfo info;
  const ButtonWidget({Key? key, required this.info}) : super(key: key);
  @override
  State<ButtonWidget> createState() => _ButtonWidget();
}

class _ButtonWidget extends State<ButtonWidget> with WidgetAction {
  // 变量
  // ...

  // 动作
  action() async {
    widget.info.genParam(0); // 生成参数
    showLoading();
    var res = await widget.info.action(); // 发送信息
    if (!mounted) return; // DO NOT use BuildContext across asynchronous gaps.
    if (showResult(context, res, response: widget.info.response?[0])) {}
    EasyLoading.dismiss();
    loaded();
  }

  // 组件
  @override
  Widget build(BuildContext context) {
    return widgetContainer(
      context,
      ListTile(
        dense: true,
        title: TitleText(widget.info.apiInfo.name),
        subtitle: Text(widget.info.options?[0]),
        onTap: action,
      ),
    );
  }
}

class InfoGrid extends StatelessWidget {
  final String name;
  final dynamic value;
  const InfoGrid({Key? key, required this.name, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: const EdgeInsets.symmetric(vertical: verPadding, horizontal: horPadding),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(color: lightColor.withOpacity(0.05), blurRadius: 1, spreadRadius: 2),
        ],
      ),
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      child: Column(children: [
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(
            child: Center(
                child: Text(
          value.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 20),
        )))
      ]),
    );
  }
}

/// 信息展示的组件
class InfoWidget extends StatefulWidget {
  final ApiWidgetInfo info;
  const InfoWidget({Key? key, required this.info}) : super(key: key);

  @override
  State<InfoWidget> createState() => _InfoWidget();
}

class _InfoWidget extends State<InfoWidget> with WidgetAction {
  Map<String, dynamic>? info;
  bool update = false;
  // 动作
  action() async {
    showLoading();
    setState(() => update = false);
    widget.info.genParam(null); // 生成参数
    var res = await widget.info.action(); // 发送信息
    if (!mounted) return;
    if (showResult(context, res, response: widget.info.response![0])) {
      setState(() {
        update = true;
        info = res!.data;
      });
    }
    loaded();
  }

  @override
  void initState() {
    update = false;
    initData(); // info自动加载
    super.initState();
  }

  initData() async {
    var res = await widget.info.action(); // 发送信息
    if (!mounted) return;
    if (res != null && res.statusCode! <= 400) {
      setState(() {
        update = true;
        info = res.data;
      });
    } else {
      showSuccBlock("数据更新失败");
    }
  }

  // 组件
  @override
  Widget build(BuildContext context) {
    // 生成info的list:
    List<Widget> widgetList = [];
    info?.forEach((key, value) {
      widgetList.add(InfoGrid(name: key, value: value));
    });
    return widgetContainer(
      context,
      GestureDetector(
        onTap: action,
        child: Column(children: [
          // 状态栏
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            TitleText("名称：${widget.info.apiInfo.name}"),
            Row(children: [
              Icon(
                update ? Icons.check : Icons.error_outline,
                color: update ? Colors.green : Colors.red,
              ),
            ])
          ]),
          const Divider(),
          GridView.count(shrinkWrap: true, crossAxisCount: 3, children: widgetList),
          const Divider(),
        ]),
      ),
    );
  }
}

/// 滑动条的组件
class SlidingWidget extends StatefulWidget {
  final ApiWidgetInfo info;
  const SlidingWidget({Key? key, required this.info}) : super(key: key);

  @override
  State<SlidingWidget> createState() => _SlidingWidget();
}

class _SlidingWidget extends State<SlidingWidget> with WidgetAction {
  double percent = 0; // 记录比例
  num value = 0; // 记录值

  // 动作
  action(double state) async {
    showLoading();
    var param = widget.info.genParam(value); // 生成参数简化
    var res = await widget.info.action(params: param); // 发送信息
    loaded();

    if (!mounted) return;
    if (showResult(context, res, response: widget.info.response?[0])) {}
  }

  onChangedAction(double percent) {
    num min = widget.info.options?[0];
    num max = widget.info.options?[1];
    num value = min + percent * (max - min);
    setState(() {
      this.value = value;
      this.percent = percent;
    });
  }

  // 组件
  @override
  Widget build(BuildContext context) {
    return widgetContainer(
      context,
      Column(children: [
        Text(widget.info.apiInfo.name),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("${widget.info.options?[0]}"),
          Text("${(percent * 100).toStringAsFixed(2)}% / ${value.toStringAsFixed(3)}"),
          Text("${widget.info.options?[1]}"),
        ]),
        Slider(value: percent, max: 1.0, onChanged: onChangedAction, onChangeEnd: action),
      ]),
    );
  }
}

/// 开关的组件
///
class SwitchWidget extends StatefulWidget {
  final ApiWidgetInfo info;
  const SwitchWidget({Key? key, required this.info}) : super(key: key);

  @override
  State<SwitchWidget> createState() => _SwitchWidget();
}

class _SwitchWidget extends State<SwitchWidget> with WidgetAction {
  bool val = false;
  // 动作
  action(bool state) async {
    showLoading();

    // Loading
    var param = widget.info.genParam(state);
    var res = await widget.info.action(params: param);

    // Load end
    if (!mounted) return;
    if (showResult(context, res, response: widget.info.response?[0])) {
      setState(() {
        val = state;
      });
    }
    loaded();
  }

  /// 组件
  @override
  Widget build(BuildContext context) {
    return widgetContainer(
      context,
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text("${widget.info.apiInfo.name}\t$val"),
        Switch(value: val, onChanged: action),
      ]),
    );
  }
}
