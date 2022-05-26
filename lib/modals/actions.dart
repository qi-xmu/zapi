part of modal;

/// 这个部分主要包括组件弹出的方法。提供接口。
/// @author qi-xmu

/// Snack Bar unit
void showSnackBar(BuildContext context, SnackBar snackBar) {
  ScaffoldMessenger.of(context).clearSnackBars(); // 先清除前一个
  ScaffoldMessenger.of(context).showSnackBar(snackBar); // 生成下一个
}

/// 底部显示成功的信息
void showSucessSnack(BuildContext context, String text) {
  var snackBar = SnackBar(
    content: Column(mainAxisSize: MainAxisSize.min, children: [
      Row(children: [
        const Icon(Icons.check, color: Colors.white),
        const SizedBox(width: 5),
        Expanded(child: Text(text, style: const TextStyle(color: Colors.white)))
      ]),
    ]),
    duration: const Duration(milliseconds: 500),
    backgroundColor: Colors.green,
  );
  showSnackBar(context, snackBar);
}

/// 底部显示失败的信息
void showFailSnack(BuildContext context, String text) {
  var snackBar = SnackBar(
    content: Row(children: [
      const Icon(Icons.warning_amber, color: Colors.white),
      const SizedBox(width: 5),
      Expanded(child: Text(text, style: const TextStyle(color: Colors.white))),
    ]),
    backgroundColor: Colors.red,
  );
  showSnackBar(context, snackBar);
}

/// 显示加载
void showLoading() {
  EasyLoading.dismiss();
  EasyLoading.show();
}

/// 消除加载
void loaded() {
  EasyLoading.dismiss();
}

/// 成功 在中间显示信息块
void showSuccBlock(String text) => EasyLoading.showSuccess(text);

/// 信息
void showInfoBlock(String text) => EasyLoading.showInfo(text);
