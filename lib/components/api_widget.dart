import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:zapi/api.dart';
import 'package:flutter/material.dart';
import 'package:zapi/modal/modal.dart';
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
        dynamic option = options![0];
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
        if (controlParam == null) return {};
        return {controlParam ?? "": state.toStringAsFixed(3)};

      case ApiWidgetType.INFO:
        // TODO: Handle this case.
        break;
      //TODO 这里新建一种组件的处理方式
    }
    return {};
  }

  Future<Response?> action({
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
  }) async {
    API api = API(group.url, params: apiInfo.params, headers: apiInfo.headers); // 默认参数
    api.setParams(params); // 设置自定义参数
    api.setParams(headers); // 设置自定义头部
    Response? res = await api.send(apiInfo.method, apiInfo.path);
    // log(res.toString());
    return res;
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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: verMargin, horizontal: horMargin),
            // padding: const EdgeInsets.symmetric(vertical: verPadding, horizontal: horPadding),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
            ),
            constraints: const BoxConstraints(minHeight: minHeight),
            child: ListTile(
              title: Text(widget.info.apiInfo.name),
              subtitle: Text(widget.info.options?[0]),
              // TODO ButtonWidget 点击动作
              onTap: () async {
                widget.info.genParam(0); // 生成参数
                // Load start
                var res = await widget.info.action(); // 发送信息
                // Load end
                if (res == null || res.statusCode! >= 400) {
                  // TODO 网络错误 || 参数错误
                  showFailSnack(context, "网络错误 或者 参数错误");
                } else {
                  //TODO 请求成功
                  showSucessSnack(context, "请求成功");
                }
              },
            )));
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
  Map<String, dynamic>? info;
  @override
  Widget build(BuildContext context) {
    // 生成info的list:
    List<Widget> infoWidgetList = [];
    info?.forEach((key, value) {
      infoWidgetList.add(Text("$key\t$value"));
    });
    return GestureDetector(
      onTap: () async {
        // widget.info.genParam(state); // 生成参数
        // Load start
        var res = await widget.info.action(); // 发送信息
        // Load end
        if (res == null || res.statusCode! >= 400) {
          // TODO 网络错误 || 参数错误
        } else {
          setState(() {
            info = res.data;
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: verMargin, horizontal: horMargin),
        padding: const EdgeInsets.symmetric(vertical: verPadding, horizontal: horPadding),
        decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
        constraints: const BoxConstraints(minHeight: minHeight),
        child: Column(children: [
          Text(widget.info.apiInfo.name),
          Divider(),
          SizedBox(
              height: 100,
              child: ListView(
                children: infoWidgetList,
              ))
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

class _SlidingWidget extends State<SlidingWidget> {
  double percent = 0; // 记录比例
  num value = 0; // 记录值
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: verMargin, horizontal: horMargin),
      padding: const EdgeInsets.symmetric(vertical: verPadding, horizontal: horPadding),
      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
      constraints: const BoxConstraints(minHeight: minHeight),
      child: Column(children: [
        Text(widget.info.apiInfo.name),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${widget.info.options?[0]}"),
            Text("${(percent * 100).toStringAsFixed(2)}% / ${value.toStringAsFixed(3)}"),
            Text("${widget.info.options?[1]}"),
          ],
        ),
        Slider(
            value: percent,
            label: "ce",
            max: 1.0,
            onChanged: (double percent) {
              num min = widget.info.options?[0];
              num max = widget.info.options?[1];
              num value = min + percent * (max - min);
              setState(() {
                this.value = value;
                this.percent = percent;
              });
            },
            onChangeEnd: (double state) {
              var param = widget.info.genParam(value); // 生成参数简化
              var res = widget.info.action(params: param); // 发送信息
            }),
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
        Text("${widget.info.apiInfo.name}\t$state"),
        Switch(
            value: state,
            onChanged: (bool state) async {
              // Loading
              var param = widget.info.genParam(state);
              var res = await widget.info.action(params: param);
              // Load end
              if (res == null || res.statusCode! >= 400) {
                // TODO 网络错误 || 参数错误

              } else {
                // 更新状态
                setState(() {
                  this.state = state;
                });
              }
            })
      ]),
    );
  }
}
