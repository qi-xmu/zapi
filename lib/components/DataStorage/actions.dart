part of data_storage;

Future<void> initPrefs() async {
  prefs = await SharedPreferences.getInstance();
}

// Future<void> updateGroupList(ApiGroup? group) async {
//   prefs.setStringList(GroupListKey, getIDList(groupList));
// }

Future<void> updateGroupList(ApiGroup group) async {
  prefs.setString(group.id.toString(), jsonEncode(group)); // 存储
  prefs.setStringList(GroupListKey, getIDList(groupList));
}

Future<void> updateGroup(ApiGroup? group) async {
  if (group == null) return;
  prefs.setString(group.id.toString(), jsonEncode(group)); // 存储
}

Future<void> updateGroupByContext(BuildContext context) async {
  ApiGroup? group = context.findAncestorWidgetOfExactType<GroupList>()?.group;

  if (group == null) return;
  prefs.setString(group.id.toString(), jsonEncode(group)); // 存储
}

Future<void> removeGroup(ApiGroup group) async {
  prefs.remove(group.id.toString());
  prefs.setStringList(GroupListKey, getIDList(groupList));
}
