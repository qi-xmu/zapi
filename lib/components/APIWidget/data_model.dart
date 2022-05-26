part of api_widget;

/// 提供数据的抽象

/// TODO enum 这里可以新增类型
enum ApiWidgetType {
  BUTTON, // 按钮 0
  SWITCH, // 开关 1
  SLIDING, // 滑动条 2
  INFO, // 信息组件 3
}

class ApiWidgetInfo {
  late String url; // 在加入组别后自动赋值
  ApiWidgetType type; // 类别
  // ApiGroup group; //所属组别， 身份验证
  APIInfo apiInfo; // api信息

  String? control; // 控制参数
  List<dynamic>? options; // 请求选项
  List<dynamic>? response; // 响应信息
  List<dynamic>? responseAlias; // 响应别名

  ApiWidgetInfo(
    this.type,
    this.apiInfo, {
    this.control,
    this.options,
    this.response,
    this.responseAlias,
  });

  // 序列化
  ApiWidgetInfo.fromJson(Map<String, dynamic> json)
      : type = ApiWidgetType.values[json['type']],
        url = json['url'],
        apiInfo = APIInfo.fromJson(json['apiInfo']),
        control = json['control'],
        options = json['options'],
        response = json['response'],
        responseAlias = json['responseAlias'];

  Map<String, dynamic> toJson() => {
        'type': type.index,
        'url': url,
        'apiInfo': apiInfo,
        'control': control,
        'options': options,
        'response': response,
        'responseAlias': responseAlias,
      };

  /// 根据类型生成控制
  Map<String, dynamic>? genParam(dynamic state) {
    if (state == null) return {};
    switch (type) {
      // 按键
      case ApiWidgetType.BUTTON:
        dynamic option = options![0];
        apiInfo.path = option;
        break;
      // 开关
      case ApiWidgetType.SWITCH:
        int index = state ? 0 : 1;

        assert(options!.length > index);

        if (control == null) break;
        return {control ?? "": options![index]};
      // 滑动
      case ApiWidgetType.SLIDING:
        // DOING: Handle this case. 1~100 == min~max
        if (control == null) return {};
        return {control ?? "": state.toStringAsFixed(3)};
      // 信息
      case ApiWidgetType.INFO:
        break;
    }
    return {};
  }

  // 数据解析
  dynamic parseData(Map<String, dynamic> data) {
    //利用respose何alisa解析
    if (response == null) return data;
    String tmp = "";
    response?.forEach((element) => {tmp += "\n$element: \t${data[element]}"});
    return tmp;
  }

  // 发送api请求
  Future<Response?> action({
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
  }) async {
    API api = API(url, params: apiInfo.params, headers: apiInfo.headers); // 默认参数
    api.setParams(params); // 设置自定义参数
    api.setParams(headers); // 设置自定义头部
    Response? res = await api.send(apiInfo.method, apiInfo.path);
    // log(res.toString());
    return res;
  }

  @override
  String toString() {
    return [type, apiInfo, control, options, response, responseAlias].toString();
  }
}
