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

// DONE 定义一个组件的Container
// TODO 修改容器样式
/// 这里可以声明所有组件的容器样式
Widget widgetContainer(BuildContext context, Widget widget) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: verMargin, horizontal: horMargin),
    padding: const EdgeInsets.symmetric(vertical: verPadding, horizontal: horPadding),
    decoration: BoxDecoration(
      border: Border.all(width: 1, color: Colors.black),
    ),
    constraints: const BoxConstraints(minHeight: minHeight),
    child: widget,
  );
}

/// DOING ButtonWidget
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
    // Load start
    showLoading();
    var res = await widget.info.action(); // 发送信息
    // Load end
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
        title: Text(widget.info.apiInfo.name),
        subtitle: Text(widget.info.options?[0]),
        onTap: action,
      ),
    );
  }
}

/// TODO InfoWidget
/// 信息展示的组件
class InfoWidget extends StatefulWidget {
  final ApiWidgetInfo info;
  const InfoWidget({Key? key, required this.info}) : super(key: key);

  @override
  State<InfoWidget> createState() => _InfoWidget();
}

class _InfoWidget extends State<InfoWidget> with WidgetAction {
  Map<String, dynamic>? info;
  // 动作
  action() async {
    widget.info.genParam(null); // 生成参数
    showLoading();

    var res = await widget.info.action(); // 发送信息
    // Load end

    if (!mounted) return;
    if (showResult(context, res, response: widget.info.response![0])) {
      setState(() {
        info = res!.data;
      });
    }
    loaded();
  }

  // 组件
  @override
  Widget build(BuildContext context) {
    // 生成info的list:
    List<Widget> infoWidgetList = [];
    info?.forEach((key, value) {
      infoWidgetList.add(Text("$key\t$value"));
    });
    return widgetContainer(
      context,
      GestureDetector(
        onTap: action,
        child: Column(children: [
          Text(widget.info.apiInfo.name),
          const Divider(),
          SizedBox(
            height: 100,
            child: ListView(children: infoWidgetList),
          )
        ]),
      ),
    );
  }
}

/// TODO SlidingWidget
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
        Slider(
          value: percent,
          label: "ce",
          max: 1.0,
          onChanged: onChangedAction,
          onChangeEnd: action,
        ),
      ]),
    );
  }
}

/// TODO SwitchWidget
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
