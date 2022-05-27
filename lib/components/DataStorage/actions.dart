part of data_storage;

List<String> getIDList(List<ApiGroup> groups) {
  List<String> res = [];
  for (ApiGroup group in groups) {
    res.add(group.id.toString());
  }
  return res;
}

dataLoad() {
  var groupList = [];
  List<String>? groupIDList = prefs.getStringList(GroupListKey);
  if (groupIDList != null) {
    for (String id in groupIDList) {
      String? groupStr = prefs.getString(id);
      // log(groupStr.toString());
      if (groupStr == null) continue;
      try {
        groupList.add(ApiGroup.fromJson(jsonDecode(groupStr)));
      } catch (e) {
        prefs.remove(id);
      }
    }
  }
  return groupList;
}

/// ***************************************** *********************************/
Future<void> initPrefs() async {
  prefs = await SharedPreferences.getInstance();
}

Future<void> updateGroupList(List<ApiGroup> groups) async {
  prefs.setStringList(GroupListKey, getIDList(groups));
}

Future<void> updateGroup(ApiGroup group) async {
  prefs.setString(group.id.toString(), jsonEncode(group)); // 存储group
}

Future<void> removeGroup(ApiGroup group) async {
  prefs.remove(group.id.toString());
}

/// ***************************************** *********************************/


