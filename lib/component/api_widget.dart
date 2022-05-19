import 'dart:developer';

import 'package:zapi/api.dart';
import 'package:flutter/material.dart';
import 'package:zapi/standard.dart';

/// TODO enum 这里可以新增类型
enum ApiWidgetType {
  BUTTON, // 按钮
  SWITCH, // 开关
  SLIDING, // 滑动条
  INFO, // 获取信息
}

class ApiWidgetInfo {
  ApiWidgetType type;
  ApiGroup group;
  APIInfo apiInfo;

  String? controlParam;
  List<dynamic>? options;

  ApiWidgetInfo(
    this.type,
    this.group,
    this.apiInfo, {
    this.controlParam,
    this.options,
  });

  /// TODO genParams
  /// 根据类型生成控制
  Map<String, dynamic>? genParam(dynamic state) {
    switch (type) {
      case ApiWidgetType.BUTTON:
        int index = state ? 0 : 1;
        assert(options!.length > index);
        dynamic option = options![index];
        apiInfo.path = option;
        break;
      case ApiWidgetType.SWITCH:
        int index = state ? 0 : 1;
        assert(options!.length > index);
        dynamic option = options![index];
        if (controlParam == null) return {};
        return {controlParam ?? "": option};
      case ApiWidgetType.SLIDING:
        // DOING: Handle this case. 1~100 == min~max
        num min = options?[0];
        num max = options?[1];
        num val = min + state * (max - min);

        if (controlParam == null) return {};
        return {controlParam ?? "": val.toStringAsFixed(3)};

      case ApiWidgetType.INFO:
        // TODO: Handle this case.
        break;
      //TODO 这里新建一种组件的处理方式
    }
    return {};
  }

  void action({
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
  }) async {
    API api = API(group.url, params: apiInfo.params, headers: apiInfo.headers); // 默认参数
    api.setParams(params); // 设置自定义参数
    api.setParams(headers); // 设置自定义头部
    var res = await api.send(apiInfo.method, apiInfo.path);
    log(res.toString());
  }
}

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

/// DOING ButtonWidget
/// 按键的组件
class ButtonWidget extends StatefulWidget {
  final ApiWidgetInfo info;
  const ButtonWidget({Key? key, required this.info}) : super(key: key);

  @override
  State<ButtonWidget> createState() => _ButtonWidget();
}

class _ButtonWidget extends State<ButtonWidget> {
  late bool state = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        // TODO ButtonWidget 点击动作
        onTap: () {
          setState(() {
            state = !state;
          });
          widget.info.genParam(state);
          widget.info.action();
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: verMargin, horizontal: horMargin),
          padding: const EdgeInsets.symmetric(vertical: verPadding, horizontal: horPadding),
          decoration: BoxDecoration(
            color: state ? Colors.blue : Colors.green,
            border: Border.all(width: 1, color: Colors.black),
          ),
          constraints: const BoxConstraints(minHeight: minHeight),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("${widget.info.apiInfo.name}\t$state"),
          ]),
        ));
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

class _InfoWidget extends State<InfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: verMargin, horizontal: horMargin),
      padding: const EdgeInsets.symmetric(vertical: verPadding, horizontal: horPadding),
      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
      constraints: const BoxConstraints(minHeight: minHeight),
      child: Row(children: [
        Text(widget.info.apiInfo.name),
      ]),
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

class _SlidingWidget extends State<SlidingWidget> {
  double state = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: verMargin, horizontal: horMargin),
      padding: const EdgeInsets.symmetric(vertical: verPadding, horizontal: horPadding),
      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
      constraints: const BoxConstraints(minHeight: minHeight),
      child: Column(children: [
        Text("${widget.info.apiInfo.name}\t${state.toStringAsFixed(3)}"),
        Slider(
          value: state,
          max: 1.0,
          onChanged: (double val) {
            setState(() {
              this.state = val;
            });
          },
          onChangeEnd: (double val) {
            var param = widget.info.genParam(state);
            widget.info.action(params: param);
          },
        )
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

class _SwitchWidget extends State<SwitchWidget> {
  bool state = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: verMargin, horizontal: horMargin),
      padding: const EdgeInsets.symmetric(vertical: verPadding, horizontal: horPadding),
      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
      constraints: const BoxConstraints(minHeight: minHeight),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(widget.info.apiInfo.name + "\t${state}"),
        Switch(
            value: state,
            onChanged: (bool state) {
              setState(() {
                this.state = state;
              });
              var param = widget.info.genParam(state);
              widget.info.action(params: param);
            })
      ]),
    );
  }
}
