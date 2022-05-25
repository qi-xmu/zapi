part of modal;

/// 这个部分主要包括组件弹出的方法。
/// @author qi-xmu

/// Snack Bar unit
void showSnackBar(BuildContext context, SnackBar snackBar) {
  ScaffoldMessenger.of(context).clearSnackBars(); // 先清除前一个
  ScaffoldMessenger.of(context).showSnackBar(snackBar); // 生成下一个
}

void showSucessSnack(BuildContext context, String text) {
  var snackBar = SnackBar(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(children: [
          const Icon(Icons.check, color: Colors.white),
          const SizedBox(width: 5),
          Expanded(
            child: Text(text),
          )
        ]),
      ],
    ),
    duration: const Duration(milliseconds: 500),
    backgroundColor: Colors.green,
  );
  showSnackBar(context, snackBar);
}

void showFailSnack(BuildContext context, String text) {
  var snackBar = SnackBar(
    content: Row(children: [
      const Icon(Icons.warning_amber, color: Colors.white),
      const SizedBox(width: 5),
      Text(text),
    ]),
    backgroundColor: Colors.red,
  );
  showSnackBar(context, snackBar);
}

void showLoading() {
  EasyLoading.dismiss();
  EasyLoading.show();
}

void loaded() {
  EasyLoading.dismiss();
}

void showSuccBlock(String text) => EasyLoading.showSuccess(text);
