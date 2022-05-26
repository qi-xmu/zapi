part of data_storage;

Future<void> initPrefs() async {
  prefs = await SharedPreferences.getInstance();
}
