part of menu;

const groupMenuText = ['导出', '编辑', '删除'];
const groupMenuIcon = [Icons.share, Icons.edit, Icons.delete];
List<Color> groupMenuColor = [lightColor, lightColor, Colors.red];

const cardMenuAction = [outGroup, editGroup, deleteGroup];

showGroupMenu(BuildContext context, ApiGroup group) async {
  if (isDarkMode(context)) {
    groupMenuColor[0] = darkColor;
    groupMenuColor[1] = darkColor;
  }
  await showModalBottomSheet(
    context: context,
    isDismissible: false,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    builder: (context) => BottomMenu(
      title: const Text("菜单"),
      content: Column(children: [
        const Divider(height: 20),
        SizedBox(
          height: boxSize * 2,
          child: GridView.count(
            crossAxisCount: 3,
            children: List.generate(
              groupMenuText.length,
              (i) => TIconText(
                text: groupMenuText[i],
                icon: groupMenuIcon[i],
                color: groupMenuColor[i],
                onTap: () => cardMenuAction[i](context, group),
              ),
            ),
          ),
        ),
      ]),
    ),
  );
  //
}

outGroup(BuildContext context, ApiGroup group) {
  Navigator.of(context).pop();
}

editGroup(BuildContext context, ApiGroup group) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddGroupForm(group: group))).then((value) {
    Navigator.of(context).pop();
  });
}

deleteGroup(BuildContext context, ApiGroup group) {
  groupList.remove(group);
  removeGroup(group); // 更新存储
  showSuccBlock("删除成功");
  //
  Navigator.of(context).pop();
}
