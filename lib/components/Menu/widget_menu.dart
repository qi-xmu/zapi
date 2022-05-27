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

shareWidget(BuildContext context, int gindex, int index) {
  showInfoBlock("暂时未开放");
  Navigator.of(context).pop();
}

editWidget(BuildContext context, int gindex, int index) {
  Navigator.of(context).pop();
  var info = context.read<GroupListModel>().getAt(gindex).widgetList[index];

  switch (info.type) {
    case ApiWidgetType.BUTTON:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddButtonForm(gindex: gindex, index: index),
      ));
      break;
    case ApiWidgetType.INFO:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddInfoForm(gindex: gindex, index: index),
      ));
      break;
    case ApiWidgetType.SLIDING:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddSlidingForm(gindex: gindex, index: index),
      ));
      break;
    case ApiWidgetType.SWITCH: // 开关
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddButtonForm(gindex: gindex, index: index),
      ));
      break;
  }
}

deleteWidget(BuildContext context, int gindex, int index) {
  //DOING

  Provider.of<GroupListModel>(context, listen: false).removeWidget(gindex, index);
  showSuccBlock('删除成功');
  Navigator.of(context).pop();
}

showWidgetMenu(BuildContext context, int gindex, int index) async {
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
      onTap: () => widgetMenu[i]['onTap'](context, gindex, index),
    ),
  );
  await showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
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
