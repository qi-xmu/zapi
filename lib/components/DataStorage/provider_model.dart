part of data_storage;

/// 状态管理
/// 使用Provider
/// @ create by qi-xmu
/// @ date 22-5-27

class GroupListModel with ChangeNotifier {
  late List<ApiGroup> _groupList;
  String text = 'test';

  GroupListModel() {
    List<ApiGroup> groupList = [];
    List<String>? groupIDList = prefs.getStringList(GroupListKey);
    if (groupIDList != null) {
      for (String id in groupIDList) {
        String? groupStr = prefs.getString(id);
        if (groupStr == null) continue;
        try {
          groupList.add(ApiGroup.fromJson(jsonDecode(groupStr)));
        } catch (e) {
          prefs.remove(id);
        }
      }
    }
    _groupList = groupList;
  }

  get len => _groupList.length; // 获取长度
  get list => _groupList; // 获所有group
  ApiGroup getAt(int index) => _groupList[index]; // 获取特定group

  /// 添加并同步
  void add(ApiGroup group) {
    _groupList.add(group);
    updateGroup(group); // 添加group
    updateGroupList(_groupList); // 更新 name list
    notifyListeners();
  }

  /// 修改并同步
  void modify(ApiGroup group, int index) {
    _groupList[index] = group;
    updateGroup(group); // 更新group
    notifyListeners();
  }

  /// 移除并同步
  void removeAt(index) {
    removeGroup(_groupList[index]); // 移除存储group
    _groupList.removeAt(index);
    updateGroupList(_groupList); // 更新 name list
    notifyListeners();
  }
}

class GroupModel with ChangeNotifier {
  ApiGroup _group;
  GroupModel(this._group);

  removeAt(index) {
    _group.widgetList.removeAt(index);
    notifyListeners();
  }
}
