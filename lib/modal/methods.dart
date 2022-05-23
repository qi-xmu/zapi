part of modal;

/// 这个部分主要包括组件弹出的方法。
/// @author qi-xmu

void testModal(BuildContext context) {
  // ignore: avoid_print
  print("This is a modal test;");
  // showModalBottomSheet(context: context, builder: (context) => BottomDialog());
  // const snackBar = SnackBar(
  //   content: Text('Yay! A SnackBar!'),
  // );
  showDialog(context: context, builder: (context) => BottomDialog());
  // showGeneralDialog(
  //     context: context,
  //     pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
  //         BottomDialog());
}

/// Snack Bar unit
void showSnackBar(BuildContext context, SnackBar snackBar) {
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSucessSnack(BuildContext context, String text) {
  var snackBar = SnackBar(
    content: Row(children: [
      const Icon(Icons.check, color: Colors.white),
      const SizedBox(width: 5),
      Text(text),
    ]),
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
