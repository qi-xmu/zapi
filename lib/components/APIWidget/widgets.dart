part of api_widget;

/// 提供组件支持
/// 目前的组件有 信息 按键 开关 滑动
///

/// 组件路由；
class ApiWidget extends StatelessWidget {
  final dynamic info; // list or ApiWidget
  const ApiWidget({Key? key, required this.info}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    switch (info.type) {
      case ApiWidgetType.BUTTON:
        // return ButtonWidget(info: info);
        return widgetContainer(context, ButtonWidget(info: info));
      case ApiWidgetType.INFO:
        return InfoWidget(info: info);
      case ApiWidgetType.SLIDING:
        return SlidingWidget(info: info);
      case ApiWidgetType.SWITCH: // 开关
        // return SwitchWidget(info: info);
        return widgetContainer(context, SwitchWidget(info: info));
      // return GridContainer(children: [SwitchWidget(info: info)]);
      // TODO switch 这里可以新增类型；
      default:
        return const Text("Null");
    }
  }
}

// DOING 修改样式 定义一个组件的Container
/// 这里可以声明所有组件的容器样式
Widget widgetContainer(BuildContext context, Widget widget) {
  return CardContainer(
    padding: const EdgeInsets.symmetric(vertical: verPadding, horizontal: horPadding),
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
    bool mode = isDarkMode(context);
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        width: (MediaQuery.of(context).size.width - 2 * (verMargin + horPadding) - 3 * 17) / 3,
        constraints: const BoxConstraints(minWidth: boxSize, minHeight: boxSize, maxWidth: boxSize * 2),
        child: ElevatedButton(
          onPressed: action,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            foregroundColor: MaterialStateProperty.all(mode ? darkColor : lightColor),
            elevation: MaterialStateProperty.all(2),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                side: BorderSide(color: (mode ? lightColor : darkColor).withOpacity(0.1)),
                borderRadius: BorderRadius.circular(radius),
              ),
            ),
            fixedSize: MaterialStateProperty.all(const Size(boxSize, boxSize)),
          ),
          child: Text(widget.info.apiInfo.name, maxLines: 2),
        ),
      ),
    ]);
  }
}

/// 信息格子
class InfoGrid extends StatelessWidget {
  final String name;
  final dynamic value;
  const InfoGrid({Key? key, required this.name, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double d = (MediaQuery.of(context).size.width - 2 * (verMargin + horPadding) - 3 * 17) / 3;
    d = d > boxSize * 1.5 ? boxSize * 1.5 : d;
    d = d > boxSize ? d : boxSize;
    return CardContainer(
      opacity: 0,
      width: d,
      height: d - 5,
      padding: const EdgeInsets.symmetric(vertical: verPadding, horizontal: horPadding),
      constraints: const BoxConstraints(minWidth: boxSize, minHeight: boxSize),
      child: Column(children: [
        Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: d / 5 - 3)),
        Expanded(
            child: Center(
                child: Text(
          value.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: d / 5 + 5),
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
      showInfoBlock("数据更新失败");
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
    return GestureDetector(
      onTap: action,
      child: widgetContainer(
        context,
        Column(children: [
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
          Wrap(
            runSpacing: 10, // vertical
            spacing: verMargin, // horizontal
            children: widgetList,
          ),
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

    if (!mounted) return;
    if (showResult(context, res, response: widget.info.response?[0])) {}
    loaded();
  }

  onChangedAction(double percent) {
    num min = widget.info.options![0]; // double
    num max = widget.info.options![1]; // double
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
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          TitleText("名称：${widget.info.apiInfo.name}"),
          Text("${(percent * 100).toStringAsFixed(2)}%",
              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        ]),
        const Divider(),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("最小值：${widget.info.options?[0]}"),
          Text("当前值： ${value.toStringAsFixed(3)}"),
          Text("最大值：${widget.info.options?[1]}"),
        ]),
        SizedBox(
          height: boxSize,
          child: Slider(value: percent, max: 1.0, onChanged: onChangedAction, onChangeEnd: action),
        )
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
    var info = widget.info;
    var param = info.genParam(state);
    var res = await info.action(params: param);

    // Load end
    if (!mounted) return;
    if (showResult(context, res, response: info.response?[0])) {
      setState(() => val = state);
    }
    loaded();
  }

  /// 组件
  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 2 * (verMargin + horPadding) - 3 * 17) / 3,
      constraints: const BoxConstraints(minWidth: boxSize, minHeight: boxSize, maxWidth: boxSize * 2),
      child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Text(widget.info.apiInfo.name),
        Switch(value: val, onChanged: action, activeColor: Colors.green),
      ]),
    );
  }
}
