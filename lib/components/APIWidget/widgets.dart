part of api_widget;

/// 提供组件支持
/// 目前的组件有 信息 按键 开关 滑动
///

/// 组件路由；
class ApiWidget extends StatelessWidget {
  final int gindex;
  final int index;
  const ApiWidget({Key? key, required this.gindex, required this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var info = context.read<GroupListModel>().getAt(gindex).widgetList[index];
    switch (info.type) {
      case ApiWidgetType.BUTTON:
        return ButtonWidget(gindex: gindex, index: index);
      case ApiWidgetType.INFO:
        return InfoWidget(gindex: gindex, index: index);
      case ApiWidgetType.SLIDING:
        return SlidingWidget(gindex: gindex, index: index);
      case ApiWidgetType.SWITCH: // 开关
        return SwitchWidget(gindex: gindex, index: index);
      default:
        return const Text("Null");
    }
  }
}

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
  final int gindex;
  final int index;
  const ButtonWidget({Key? key, required this.gindex, required this.index}) : super(key: key);
  @override
  State<ButtonWidget> createState() => _ButtonWidget();
}

class _ButtonWidget extends State<ButtonWidget> with WidgetAction {
  late ApiGroup group;
  late ApiWidgetInfo info;

  // 动作
  action() async {
    showLoading();

    info.genParam(null); // 生成参数
    var res = await info.action(url: group.realUrl); // 发送信息
    if (!mounted) return; // DO NOT use BuildContext across asynchronous gaps.
    if (showResult(context, res, response: info.response[0])) {}
    EasyLoading.dismiss();
    loaded();
  }

  // 组件
  @override
  Widget build(BuildContext context) {
    group = Provider.of<GroupListModel>(context).getAt(widget.gindex);
    info = group.widgetList[widget.index];
    bool mode = isDarkMode(context);
    return widgetContainer(
        context,
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: (MediaQuery.of(context).size.width - 2 * (verMargin + horPadding) - 3 * 17) / 3,
            constraints: const BoxConstraints(minWidth: boxSize, minHeight: boxSize, maxWidth: boxSize * 2),
            child: ElevatedButton(
              onPressed: action,
              onLongPress: () => showWidgetMenu(context, widget.gindex, widget.index), // 菜单
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
              child: Text(info.apiInfo.name, maxLines: 2),
            ),
          ),
        ]));
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
        StrongText(name, size: d / 5 - 5),
        Expanded(
            child: Center(
          child: StrongText(value.toString(), color: Colors.green, size: d / 5 + 5),
        )),
      ]),
    );
  }
}

/// 信息展示的组件
class InfoWidget extends StatefulWidget {
  final int gindex;
  final int index;
  const InfoWidget({Key? key, required this.gindex, required this.index}) : super(key: key);

  @override
  State<InfoWidget> createState() => _InfoWidget();
}

class _InfoWidget extends State<InfoWidget> with WidgetAction {
  late ApiGroup group;
  late ApiWidgetInfo info;

  bool update = false;
  Map<String, dynamic> state = {};

  // 动作
  @override
  void initState() {
    group = context.read<GroupListModel>().getAt(widget.gindex);
    info = group.widgetList[widget.index];
    state = info.state ?? state; // 初始值
    // actionNoMsg(); // info自动加载
    super.initState();
  }

  action() async {
    showLoading();
    update = false;
    info.genParam(null); // 生成参数
    var res = await info.action(url: group.realUrl); // 发送信息
    if (!mounted) return;
    if (showResult(context, res, response: info.response[0])) {
      // 解析data;
      parseData(res!.data, info.response, info.responseAlias);
      update = true;
      //TODO 更新数据
      // await updateGroupByContext(context);
    }
    setState(() {});
    loaded();
  }

  actionNoMsg() async {
    var res = await info.action(url: group.realUrl); // 发送信息
    if (!mounted) return;
    if (res != null && res.statusCode! <= 400) {
      parseData(res.data, info.response, info.responseAlias);
      update = true;
      setState(() {});
    } else {
      showInfoBlock("数据更新失败");
    }
  }

  // 组件
  @override
  Widget build(BuildContext context) {
    group = Provider.of<GroupListModel>(context).getAt(widget.gindex);
    info = group.widgetList[widget.index];
    // state = info.state ?? state;
    // parseData(, info.response, info.responseAlias);

    List<Widget> infoGrids = [];
    state.forEach((key, value) {
      infoGrids.add(InfoGrid(name: key, value: value));
    });
    print(infoGrids.length);

    return GestureDetector(
      onTap: action,
      onLongPress: () => showWidgetMenu(context, widget.gindex, widget.index), // 菜单
      child: widgetContainer(
        context,
        Column(children: [
          // 状态栏
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            StrongText(info.apiInfo.name),
            Row(children: [
              Icon(update ? Icons.check : Icons.error_outline, color: update ? Colors.green : Colors.red),
            ])
          ]),
          const Divider(),
          Wrap(runSpacing: 10, spacing: verMargin, children: infoGrids),
        ]),
      ),
    );
  }
}

/// 滑动条的组件
class SlidingWidget extends StatefulWidget {
  final int gindex;
  final int index;
  const SlidingWidget({Key? key, required this.gindex, required this.index}) : super(key: key);

  @override
  State<SlidingWidget> createState() => _SlidingWidget();
}

class _SlidingWidget extends State<SlidingWidget> with WidgetAction {
  late ApiGroup group;
  late ApiWidgetInfo info;
  double percent = 0; // 记录比例
  num value = 0; // 记录值

  @override
  void initState() {
    group = context.read<GroupListModel>().getAt(widget.gindex);
    info = group.widgetList[widget.index];
    if (info.state != null) {
      percent = info.state?['percent'] ?? percent; // 初始值
      value = getValue(percent);
    }
    super.initState();
  }

  // 动作
  action(double per) async {
    showLoading();

    var param = info.genParam(value); // 生成参数简化
    var res = await info.action(url: group.realUrl, params: param); // 发送信息

    if (!mounted) return;
    if (showResult(context, res, response: info.response[0])) {
      info.state = {'percent': per};
      await updateGroupByContext(context);
    }
    loaded();
  }

  getValue(double percent) {
    num min = info.options![0]; // double
    num max = info.options![1]; // double
    num value = min + percent * (max - min);
    return value;
  }

  onChangedAction(double per) {
    setState(() {
      percent = per;
      value = getValue(per);
    });
  }

  // 组件
  @override
  Widget build(BuildContext context) {
    group = Provider.of<GroupListModel>(context).getAt(widget.gindex);
    info = group.widgetList[widget.index];

    return widgetContainer(
      context,
      Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          StrongText(info.apiInfo.name),
          Text("${(percent * 100).toStringAsFixed(2)}%",
              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        ]),
        const Divider(),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("最小值：${info.options?[0]}"),
          Text("当前值： ${value.toStringAsFixed(3)}"),
          Text("最大值：${info.options?[1]}"),
        ]),
        SizedBox(
          height: boxSize,
          child: Slider(
            value: percent,
            max: 1.0,
            activeColor: Colors.green,
            onChanged: onChangedAction,
            onChangeEnd: action,
          ),
        )
      ]),
    );
  }
}

/// 开关的组件
///
class SwitchWidget extends StatefulWidget {
  final int gindex;
  final int index;
  const SwitchWidget({Key? key, required this.gindex, required this.index}) : super(key: key);

  @override
  State<SwitchWidget> createState() => _SwitchWidget();
}

class _SwitchWidget extends State<SwitchWidget> with WidgetAction {
  late ApiGroup group;
  late ApiWidgetInfo info;
  bool state = false;

  @override
  void initState() {
    group = context.read<GroupListModel>().getAt(widget.gindex);
    info = group.widgetList[widget.index];
    if (info.state != null) {
      state = info.state?['state'] ?? state;
    }
    super.initState();
  }

  // 动作
  action(bool val) async {
    showLoading();
    var param = info.genParam(val);
    var res = await info.action(url: group.realUrl, params: param);

    // Load end
    if (!mounted) return;
    if (showResult(context, res, response: info.response[0])) {
      setState(() => state = val);
      info.state = {'state': val};
      await updateGroupByContext(context);
    }
    loaded();
  }

  /// 组件
  @override
  Widget build(BuildContext context) {
    group = Provider.of<GroupListModel>(context).getAt(widget.gindex);
    info = group.widgetList[widget.index];

    return widgetContainer(
      context,
      Container(
        width: (MediaQuery.of(context).size.width - 2 * (verMargin + horPadding) - 3 * 17) / 3,
        constraints: const BoxConstraints(minWidth: boxSize, minHeight: boxSize, maxWidth: boxSize * 2),
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Text(info.apiInfo.name),
          Switch(value: state, onChanged: action, activeColor: Colors.green),
        ]),
      ),
    );
  }
}
