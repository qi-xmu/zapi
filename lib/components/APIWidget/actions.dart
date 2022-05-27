part of api_widget;

class WidgetAction {
  bool showResult(BuildContext context, Response? res, {dynamic response}) {
    // if (!mounted) return;
    if (res == null) {
      showFailSnack(context, "网络错误");
    } else if (res.statusCode! >= 400) {
      showFailSnack(context, "参数错误 ${res.statusMessage} ${res.statusCode!}");
    } else {
      String text = response != null ? res.data[response].toString() : res.data.toString();
      showSucessSnack(context, "请求成功，返回结果：$text");
      return true;
    }
    return false;
  }
}

List<dynamic> parseData(Map<String, dynamic> data, List<dynamic> response, List<dynamic> alias) {
  List<dynamic> values = List.filled(response.length, 0);
  data.forEach((key, value) {
    int index = response.indexOf(key);
    if (index != -1 && index < alias.length) {
      values[index] = value;
    }
  });
  return values;
}
