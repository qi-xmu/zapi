part of data_storage;

void initPrefs() async {
  prefs = await SharedPreferences.getInstance();
}
