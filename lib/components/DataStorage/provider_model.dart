part of data_storage;

/// 状态管理
/// 使用Provider
/// @ create by qi-xmu
/// @ date 22-5-27
///
///****************************************************************************** */
///
///这里定义group list的更新方法
///部分widget也在这里
///

class GroupListModel with ChangeNotifier {
  late List<ApiGroup> _groupList;

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
  ApiGroup getAt(int gindex) => _groupList[gindex]; // 获取特定group

  /// 添加并同步
  void add(ApiGroup group) {
    _groupList.add(group);
    updateGroup(group); // 添加group
    updateGroupList(_groupList); // 更新 name list
    notifyListeners();
  }

  /// 修改并同步
  void modify(ApiGroup group, int gindex) {
    _groupList[gindex] = group;
    updateGroup(group); // 更新group
    notifyListeners();
  }

  /// 移除并同步
  void removeAt(gindex) {
    removeGroup(_groupList[gindex]); // 移除存储group
    _groupList.removeAt(gindex);
    updateGroupList(_groupList); // 更新 name list
    notifyListeners();
  }

  ///****************************************************************************** */
  ///
  ///这里定义group的更新方法
  ///

  /// index：指定操作的group
  void addWidget(int gindex, ApiWidgetInfo newWidget) {
    ApiGroup group = _groupList[gindex];
    group.addApi(newWidget);
    updateGroup(_groupList[gindex]);
    notifyListeners();
  }

  //modifyWidget
  void modifyWidget(int gindex, int index, ApiWidgetInfo info) {
    _groupList[gindex].widgetList[index] = info;
    updateGroup(_groupList[gindex]);
    notifyListeners();
  }

  // removeWidget
  void removeWidget(int gindex, int index) {
    _groupList[gindex].widgetList.removeAt(index);
    updateGroup(_groupList[gindex]);
    notifyListeners();
  }
}

// class GroupModel with ChangeNotifier {
//   ApiGroup _group;
//   GroupModel(this._group);

//   ApiGroup get group => _group;
//   int get len => _group.widgetList.length;

//   test() => print('test');

//   getWidgetAt(int index) {
//     return _group.widgetList[index];
//   }

//   addWidget(ApiWidgetInfo info) {
//     _group.widgetList.add(info);
//     notifyListeners();
//   }

//   modifyWidget(int index, ApiWidgetInfo info) {
//     _group.widgetList[index] = info;
//     notifyListeners();
//   }

//   removeAt(index) {
//     _group.widgetList.removeAt(index);
//     notifyListeners();
//   }
// }
