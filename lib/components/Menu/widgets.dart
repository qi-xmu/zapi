part of menu;

/// 弹出菜单
class BottomMenu extends StatelessWidget {
  const BottomMenu({Key? key, required this.title, required this.content}) : super(key: key);
  final Widget title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(mainAxisSize: MainAxisSize.min, children: [title, content]),
    );
  }
}

/// 上图下字
class TIconText extends StatelessWidget {
  final String text;
  final Color? color;
  final IconData? icon;
  final void Function()? onTap;
  const TIconText({
    Key? key,
    required this.text,
    required this.icon,
    this.color,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: boxSize,
      height: boxSize,
      child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(flex: 2, child: Icon(icon, size: 28, color: color)),
            Expanded(flex: 1, child: Text(text, style: TextStyle(color: color)))
          ])),
    );
  }
}
