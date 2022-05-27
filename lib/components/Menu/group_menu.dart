part of menu;

const groupMenuText = ['导出', '编辑', '删除'];
const groupMenuIcon = [Icons.share, Icons.edit, Icons.delete, Icons.abc];
List<Color> groupMenuColor = [lightColor, lightColor, Colors.red, Colors.black];

const cardMenuAction = [outGroup, editGroup, deleteGroup, deleteGroup];

outGroup(BuildContext context, int index) {
  showInfoBlock("暂时未开放");
  Navigator.of(context).pop();
}

editGroup(BuildContext context, int index) {
  Navigator.of(context).pop();
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => AddGroupForm(index: index),
  ));
}

deleteGroup(BuildContext context, int index) {
  Provider.of<GroupListModel>(context, listen: false).removeAt(index);
  showSuccBlock("删除成功");
  Navigator.of(context).pop();
}

showGroupMenu(BuildContext context, int index) async {
  if (isDarkMode(context)) {
    groupMenuColor[0] = darkColor;
    groupMenuColor[1] = darkColor;
  }

  List<Widget> menuList = List.generate(
    groupMenuText.length,
    (i) => TIconText(
        text: groupMenuText[i],
        icon: groupMenuIcon[i],
        color: groupMenuColor[i],
        onTap: () => cardMenuAction[i](context, index)),
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
}
