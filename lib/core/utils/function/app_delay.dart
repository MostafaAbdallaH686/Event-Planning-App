abstract class AppDelay {
  static Future<void> delayLoading() async {
    await Future.delayed(Duration(milliseconds: 700));
  }
}
