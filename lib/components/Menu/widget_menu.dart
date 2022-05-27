part of menu;

List<Map<String, dynamic>> widgetMenu = [
  {
    'label': '分享',
    'icon': Icons.share,
    'color': lightColor,
    'onTap': shareWidget,
  },
  {
    'label': '编辑',
    'color': lightColor,
    'icon': Icons.edit,
    'onTap': editWidget,
  },
  {
    'label': '删除',
    'color': Colors.red,
    'icon': Icons.edit,
    'onTap': deleteWidget,
  },
];

shareWidget(BuildContext context, ApiGroup group, int index) {
  showInfoBlock("暂时未开放");
  Navigator.of(context).pop();
}

editWidget(BuildContext context, ApiGroup group, int index) {
  var info = group.widgetList[index];
  print(group.toString());
  dynamic page;
  switch (info.type) {
    case ApiWidgetType.BUTTON:
      page = AddButtonForm(group: group, index: index);
      break;
    case ApiWidgetType.INFO:
    case ApiWidgetType.SLIDING:
    case ApiWidgetType.SWITCH: // 开关
    default:
      return const Text("Null");
  }
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
}

deleteWidget(BuildContext context, ApiGroup group, int index) {
  // group.widgetList.removeAt(index);
  //DOING
  Provider.of<GroupModel>(context, listen: false).removeAt(0);
  Navigator.of(context).pop(); // 这个地方需要更新整个列表
}

showWidgetMenu(BuildContext context, ApiGroup group, int index) async {
  if (isDarkMode(context)) {
    widgetMenu[0]['color'] = darkColor;
    widgetMenu[1]['color'] = darkColor;
  }

  List<Widget> menuList = List.generate(
    groupMenuText.length,
    (i) => TIconText(
      text: widgetMenu[i]['label'],
      icon: widgetMenu[i]['icon'],
      color: widgetMenu[i]['color'],
      onTap: () => widgetMenu[i]['onTap'](context, group, index),
    ),
  );
  await showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    builder: (context) => Container(
      padding: const EdgeInsets.symmetric(vertical: verPadding * 2, horizontal: horPadding),
      child: Column(children: [
        const TitleText("菜单"),
        Column(children: [
          const Divider(height: 20),
          Wrap(spacing: (MediaQuery.of(context).size.width - 3 * boxSize) / 4, children: menuList)
        ]),
      ]),
    ),
  );
  //
}
